<?php
// ======================================================================
// CORS Policy for ForenShield API
//
// Design:
//   - Browser requests from known origins: restricted allowlist via env
//   - Native Flutter requests: no Origin header; CORS headers are
//     irrelevant for native Dio/HTTP clients. Do NOT emit wildcard *.
//   - JWT authentication is the actual API authorization mechanism.
//     CORS alone does not protect the API from programmatic callers.
// ======================================================================

$allowedOrigins = array_filter(
    explode(',', getenv('ALLOWED_ORIGINS') ?: ''),
    fn($o) => !empty(trim($o))
);

$requestOrigin = $_SERVER['HTTP_ORIGIN'] ?? '';

if (!empty($requestOrigin)) {
    // Browser request with an Origin header.
    if (in_array(trim($requestOrigin), $allowedOrigins, true)) {
        header('Access-Control-Allow-Origin: ' . trim($requestOrigin));
        header('Vary: Origin');
    }
    // If the origin is NOT in the allowlist, we intentionally do NOT set
    // Access-Control-Allow-Origin. The browser will block the request.
}
// If $requestOrigin is empty (native mobile, Postman, cURL), we also do
// NOT set Access-Control-Allow-Origin. These callers are authorized
// exclusively via JWT on each protected endpoint.

header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
