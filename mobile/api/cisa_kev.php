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

$token = $matches[1];

try {
    $decoded = JWT::decode($token, new Key(JWT_SECRET, 'HS256'));
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

// ── Configuration ─────────────────────────────────────────────────────────────

const CISA_KEV_URL    = 'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json';
const CACHE_TTL       = 1200;   // 20 minutes in seconds
const RESULTS_PER_PAGE = 20;    // latest N entries to return
const FETCH_TIMEOUT   = 15;     // seconds for remote fetch

$cacheFile = sys_get_temp_dir() . '/forenshield_cisa_kev.json';
$cacheMetaFile = sys_get_temp_dir() . '/forenshield_cisa_kev_meta.json';

// ── Cache Helpers ─────────────────────────────────────────────────────────────

/**
 * Returns the age of the cache file in seconds, or null if it does not exist.
 */
function getCacheAge(string $metaFile): ?int {
    if (!file_exists($metaFile)) {
        return null;
    }
    $meta = json_decode(file_get_contents($metaFile), true);
    if (!isset($meta['fetched_at'])) {
        return null;
    }
    return (int)(time() - $meta['fetched_at']);
}

/**
 * Reads the cached payload, or null if it does not exist / is unreadable.
 */
function readCache(string $cacheFile): ?array {
    if (!file_exists($cacheFile)) {
        return null;
    }
    $raw = @file_get_contents($cacheFile);
    if ($raw === false) {
        return null;
    }
    $data = json_decode($raw, true);
    return is_array($data) ? $data : null;
}

/**
 * Writes payload + metadata to disk cache.
 */
function writeCache(string $cacheFile, string $metaFile, array $payload): void {
    @file_put_contents($cacheFile, json_encode($payload), LOCK_EX);
    @file_put_contents($metaFile, json_encode(['fetched_at' => time()]), LOCK_EX);
}

// ── Fetch from CISA with cURL ─────────────────────────────────────────────────

/**
 * Fetches the CISA KEV feed via cURL.
 *
 * @return array|null Raw decoded JSON array on success, null on any failure.
 */
function fetchCisaKev(): ?array {
    $ch = curl_init(CISA_KEV_URL);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_MAXREDIRS      => 3,
        CURLOPT_TIMEOUT        => FETCH_TIMEOUT,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_USERAGENT      => 'ForenShield/1.0 (CISA KEV Client)',
        CURLOPT_HTTPHEADER     => ['Accept: application/json'],
    ]);

    $body    = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlErr = curl_error($ch);
    curl_close($ch);

    if ($body === false || !empty($curlErr)) {
        error_log("[cisa_kev] cURL error: $curlErr");
        return null;
    }

    if ($httpCode < 200 || $httpCode >= 300) {
        error_log("[cisa_kev] Unexpected HTTP $httpCode from CISA.");
        return null;
    }

    $decoded = json_decode($body, true);
    if (json_last_error() !== JSON_ERROR_NONE || !is_array($decoded)) {
        error_log('[cisa_kev] JSON parse error: ' . json_last_error_msg());
        return null;
    }

    return $decoded;
}

// ── Normalise a Single Vulnerability Entry ────────────────────────────────────

/**
 * Maps a raw CISA KEV entry to a clean, Flutter-friendly array.
 */
function normaliseEntry(array $entry): array {
    return [
        'cve_id'             => isset($entry['cveID'])            ? (string)$entry['cveID']            : 'N/A',
        'vendor'             => isset($entry['vendorProject'])    ? (string)$entry['vendorProject']    : 'Unknown Vendor',
        'product'            => isset($entry['product'])          ? (string)$entry['product']          : 'Unknown Product',
        'vulnerability_name' => isset($entry['vulnerabilityName']) ? (string)$entry['vulnerabilityName'] : 'Unknown Vulnerability',
        'severity'           => isset($entry['severity'])         ? strtoupper((string)$entry['severity']) : 'N/A',
        'date_added'         => isset($entry['dateAdded'])        ? (string)$entry['dateAdded']        : '',
        'required_action'    => isset($entry['requiredAction'])   ? (string)$entry['requiredAction']   : 'Refer to vendor advisory.',
        'due_date'           => isset($entry['dueDate'])          ? (string)$entry['dueDate']          : '',
        'known_ransomware'   => isset($entry['knownRansomwareCampaignUse']) ? (string)$entry['knownRansomwareCampaignUse'] : 'Unknown',
    ];
}

// ── Main Logic ────────────────────────────────────────────────────────────────

$cacheAge     = getCacheAge($cacheMetaFile);
$isCacheValid = $cacheAge !== null && $cacheAge < CACHE_TTL;
$cachedData   = readCache($cacheFile);
$fromCache    = false;

if ($isCacheValid && $cachedData !== null) {
    // Serve from cache
    $kevData   = $cachedData;
    $fromCache = true;
} else {
    // Fetch fresh data from CISA
    $fetched = fetchCisaKev();

    if ($fetched !== null) {
        writeCache($cacheFile, $cacheMetaFile, $fetched);
        $kevData  = $fetched;
        $cacheAge = 0;
    } elseif ($cachedData !== null) {
        // Fetch failed but stale cache exists — serve stale with warning
        $kevData   = $cachedData;
        $fromCache = true;
        error_log('[cisa_kev] Serving stale cache due to fetch failure.');
    } else {
        // No cache, no live data
        http_response_code(503);
        echo json_encode([
            'success' => false,
            'error'   => 'Unable to load live threat intelligence. The CISA feed is temporarily unavailable.',
        ]);
        exit;
    }
}

// ── Parse & Paginate ──────────────────────────────────────────────────────────

$rawVulnerabilities = $kevData['vulnerabilities'] ?? [];

if (!is_array($rawVulnerabilities)) {
    http_response_code(502);
    echo json_encode([
        'success' => false,
        'error'   => 'Unexpected format from CISA KEV feed.',
    ]);
    exit;
}

$totalCount = count($rawVulnerabilities);

// CISA feed is already sorted oldest-first; reverse to get newest first.
$reversed = array_reverse($rawVulnerabilities);

// Take the top N most recently added
$slice = array_slice($reversed, 0, RESULTS_PER_PAGE);

// Normalise each entry for Flutter consumption
$normalised = array_map('normaliseEntry', $slice);

// ── Response ──────────────────────────────────────────────────────────────────

echo json_encode([
    'success'           => true,
    'total'             => $totalCount,
    'count'             => count($normalised),
    'cache_age_seconds' => $fromCache ? (int)$cacheAge : 0,
    'from_cache'        => $fromCache,
    'vulnerabilities'   => $normalised,
]);
