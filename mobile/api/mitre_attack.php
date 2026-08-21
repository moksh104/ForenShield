<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// ── JWT Authentication ────────────────────────────────────────────────────────

$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $authorization = $headers['Authorization'];
} elseif (isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}

if (!$authorization || !preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    http_response_code(401);
    echo json_encode(['error' => 'Missing or invalid Authorization header.']);
    exit;
}

try {
    JWT::decode($matches[1], new Key(JWT_SECRET, 'HS256'));
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

// ── Configuration ─────────────────────────────────────────────────────────────

const MITRE_STIX_URL = 'https://raw.githubusercontent.com/mitre-attack/attack-stix-data/master/enterprise-attack/enterprise-attack.json';
const CACHE_TTL = 86400; // 24 hours
$cacheFile = sys_get_temp_dir() . '/forenshield_mitre_cache.json';
$cacheMetaFile = sys_get_temp_dir() . '/forenshield_mitre_meta.json';

// Allow parsing of the large STIX file
ini_set('memory_limit', '512M');
set_time_limit(120);

// ── Helpers ───────────────────────────────────────────────────────────────────

function getCacheAge(string $metaFile): ?int {
    if (!file_exists($metaFile)) return null;
    $meta = json_decode(file_get_contents($metaFile), true);
    return isset($meta['fetched_at']) ? (int)(time() - $meta['fetched_at']) : null;
}

function fetchAndParseStix(): ?array {
    $ch = curl_init(MITRE_STIX_URL);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_TIMEOUT        => 30,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_USERAGENT      => 'ForenShield/1.0 (MITRE STIX Parser; contact@forenshield.app)',
        CURLOPT_HTTPHEADER     => ['Accept: application/json'],
    ]);

    $body = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlErr = curl_error($ch);
    curl_close($ch);

    if ($body === false || $httpCode < 200 || $httpCode >= 300) {
        error_log("[mitre] Failed to fetch STIX JSON: HTTP $httpCode, cURL error: $curlErr");
        return null;
    }

    $stixData = json_decode($body, true);
    if (!isset($stixData['objects']) || !is_array($stixData['objects'])) {
        error_log("[mitre] Invalid STIX JSON structure.");
        return null;
    }

    $techniques = [];

    foreach ($stixData['objects'] as $obj) {
        if (($obj['type'] ?? '') === 'attack-pattern') {
            // Find external ID
            $extId = 'UNKNOWN';
            if (isset($obj['external_references']) && is_array($obj['external_references'])) {
                foreach ($obj['external_references'] as $ref) {
                    if (($ref['source_name'] ?? '') === 'mitre-attack') {
                        $extId = $ref['external_id'] ?? 'UNKNOWN';
                        break;
                    }
                }
            }
            
            // Sub-techniques have a dot in ID (e.g. T1110.001), skip them to keep the list clean,
            // or keep them. We will keep only main techniques to reduce payload size.
            if (strpos($extId, '.') !== false) {
                continue; 
            }

            // Find Tactic (kill_chain_phases)
            $tactic = 'Unknown Tactic';
            if (isset($obj['kill_chain_phases']) && is_array($obj['kill_chain_phases'])) {
                foreach ($obj['kill_chain_phases'] as $phase) {
                    if (($phase['kill_chain_name'] ?? '') === 'mitre-attack') {
                        $tactic = ucwords(str_replace('-', ' ', $phase['phase_name'] ?? 'unknown'));
                        break;
                    }
                }
            }

            // Find Platform
            $platform = 'Unknown Platform';
            if (isset($obj['x_mitre_platforms']) && is_array($obj['x_mitre_platforms'])) {
                $platform = implode(', ', $obj['x_mitre_platforms']);
            }

            $description = $obj['description'] ?? 'No description available.';
            $detection = $obj['x_mitre_detection'] ?? 'No specific detection guidance provided by MITRE ATT&CK for this technique.';
            
            $techniques[] = [
                'id'          => $extId,
                'name'        => $obj['name'] ?? 'Unnamed Technique',
                'description' => $description,
                'tactic'      => $tactic,
                'platform'    => $platform,
                'detection'   => $detection,
                'mitigation'  => 'Mitigation details not directly available in STIX technique object. Please consult MITRE ATT&CK portal for specific mitigations.'
            ];
        }
    }

    return $techniques;
}

// ── Main Logic ────────────────────────────────────────────────────────────────

$cacheAge = getCacheAge($cacheMetaFile);
$isCacheValid = $cacheAge !== null && $cacheAge < CACHE_TTL;
$fromCache = false;

if ($isCacheValid && file_exists($cacheFile)) {
    $rawCache = file_get_contents($cacheFile);
    $techniques = json_decode($rawCache, true);
    if (is_array($techniques)) {
        $fromCache = true;
    } else {
        $isCacheValid = false;
    }
}

if (!$fromCache) {
    $techniques = fetchAndParseStix();

    if ($techniques !== null) {
        file_put_contents($cacheFile, json_encode($techniques), LOCK_EX);
        file_put_contents($cacheMetaFile, json_encode(['fetched_at' => time()]), LOCK_EX);
    } elseif (file_exists($cacheFile)) {
        // Fallback to stale cache
        $rawCache = file_get_contents($cacheFile);
        $techniques = json_decode($rawCache, true);
        $fromCache = true;
        error_log("[mitre] Served stale cache due to fetch failure.");
    } else {
        http_response_code(503);
        echo json_encode([
            'success' => false,
            'error'   => 'Unable to load live MITRE ATT&CK techniques.',
        ]);
        exit;
    }
}

echo json_encode([
    'success'           => true,
    'from_cache'        => $fromCache,
    'cache_age_seconds' => $fromCache ? (int)$cacheAge : 0,
    'data'              => $techniques,
]);
