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

$apiKey = defined('VT_API_KEY') ? VT_API_KEY : getenv('VT_API_KEY');
if (!$apiKey) {
    http_response_code(500);
    echo json_encode(['error' => 'VirusTotal API key is not configured.']);
    exit;
}

$query = $_GET['query'] ?? '';
if (empty($query)) {
    http_response_code(400);
    echo json_encode(['error' => 'Query parameter is required.']);
    exit;
}

$query = trim($query);
$cacheKey = md5($query);
$cacheFile = sys_get_temp_dir() . '/forenshield_vt_' . $cacheKey . '.json';
$cacheTtl = 43200; // 12 hours

// ── Cache Check ───────────────────────────────────────────────────────────────

if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheTtl) {
    $rawCache = file_get_contents($cacheFile);
    $cacheData = json_decode($rawCache, true);
    if (is_array($cacheData)) {
        echo json_encode([
            'success' => true,
            'from_cache' => true,
            'data' => $cacheData
        ]);
        exit;
    }
}

// ── Determine Type & Endpoint ─────────────────────────────────────────────────

$endpoint = '';

if (preg_match('/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/', $query)) {
    // IPv4 Address
    $endpoint = "https://www.virustotal.com/api/v3/ip_addresses/" . urlencode($query);
} elseif (preg_match('/^https?:\/\//i', $query)) {
    // URL
    $id = rtrim(strtr(base64_encode($query), '+/', '-_'), '=');
    $endpoint = "https://www.virustotal.com/api/v3/urls/" . $id;
} elseif (preg_match('/^[a-fA-F0-9]{32}$|^[a-fA-F0-9]{40}$|^[a-fA-F0-9]{64}$/', $query)) {
    // Hash (MD5, SHA-1, SHA-256)
    $endpoint = "https://www.virustotal.com/api/v3/files/" . strtolower($query);
} else {
    // Domain fallback
    $endpoint = "https://www.virustotal.com/api/v3/domains/" . urlencode($query);
}

// ── Fetch from VirusTotal ─────────────────────────────────────────────────────

$ch = curl_init($endpoint);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_TIMEOUT => 15,
    CURLOPT_HTTPHEADER => [
        "x-apikey: " . $apiKey,
        "Accept: application/json"
    ]
]);

$responseBody = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlErr = curl_error($ch);
curl_close($ch);

if ($responseBody === false || $httpCode !== 200) {
    // If rate limited or not found
    if ($httpCode === 404) {
        $errorMsg = 'No analysis available for this indicator on VirusTotal.';
    } elseif ($httpCode === 429) {
        $errorMsg = 'VirusTotal rate limit exceeded. Please try again later.';
    } else {
        $errorMsg = 'Live VirusTotal analysis is currently unavailable.';
    }
    
    // Serve stale cache if available
    if (file_exists($cacheFile)) {
        $rawCache = file_get_contents($cacheFile);
        $cacheData = json_decode($rawCache, true);
        if (is_array($cacheData)) {
            echo json_encode([
                'success' => true,
                'from_cache' => true,
                'stale' => true,
                'data' => $cacheData
            ]);
            exit;
        }
    }
    
    http_response_code(503);
    echo json_encode([
        'success' => false,
        'error' => $errorMsg
    ]);
    exit;
}

$vtData = json_decode($responseBody, true);
$attributes = $vtData['data']['attributes'] ?? [];
$stats = $attributes['last_analysis_stats'] ?? [];

// ── Map Data ──────────────────────────────────────────────────────────────────

$malicious = $stats['malicious'] ?? 0;
$suspicious = $stats['suspicious'] ?? 0;
$harmless = $stats['harmless'] ?? 0;
$undetected = $stats['undetected'] ?? 0;
$total = $malicious + $suspicious + $harmless + $undetected;

$detectionRatio = $total > 0 ? "$malicious / $total" : 'N/A';

$riskLevel = 'Low';
if ($malicious >= 5) {
    $riskLevel = 'Critical';
} elseif ($malicious >= 1 || $suspicious >= 3) {
    $riskLevel = 'High';
} elseif ($suspicious >= 1) {
    $riskLevel = 'Medium';
}

$firstSeen = 'Unknown';
if (isset($attributes['first_submission_date'])) {
    $firstSeen = date('Y-m-d H:i:s', $attributes['first_submission_date']) . ' UTC';
}

$lastAnalysis = 'Unknown';
if (isset($attributes['last_analysis_date'])) {
    $lastAnalysis = date('Y-m-d H:i:s', $attributes['last_analysis_date']) . ' UTC';
}

$mappedData = [
    'Detection ratio' => $detectionRatio,
    'Risk level' => $riskLevel,
    'File hash' => $attributes['sha256'] ?? $query,
    'File type' => $attributes['type_description'] ?? 'N/A',
    'File size' => isset($attributes['size']) ? number_format($attributes['size'] / 1024, 2) . ' KB' : 'N/A',
    'First seen' => $firstSeen,
    'Last analysis' => $lastAnalysis,
    'Malicious' => (string)$malicious,
    'Suspicious' => (string)$suspicious,
    'Harmless' => (string)$harmless,
    'Undetected' => (string)$undetected,
    'Reputation' => (string)($attributes['reputation'] ?? '0')
];

// Save cache
file_put_contents($cacheFile, json_encode($mappedData), LOCK_EX);

echo json_encode([
    'success' => true,
    'from_cache' => false,
    'data' => $mappedData
]);
