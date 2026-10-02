<?php
// ======================================================================
// Universal getallheaders() Polyfill (for CLI, FastCGI, Windows PHP dev server)
// ======================================================================
if (!function_exists('getallheaders')) {
    function getallheaders() {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (substr($name, 0, 5) == 'HTTP_') {
                $headerName = str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))));
                $headers[$headerName] = $value;
            } elseif ($name === 'CONTENT_TYPE') {
                $headers['Content-Type'] = $value;
            } elseif ($name === 'CONTENT_LENGTH') {
                $headers['Content-Length'] = $value;
            } elseif ($name === 'AUTHORIZATION') {
                $headers['Authorization'] = $value;
            }
        }
        if (!isset($headers['Authorization'])) {
            if (isset($_SERVER['REDIRECT_HTTP_AUTHORIZATION'])) {
                $headers['Authorization'] = $_SERVER['REDIRECT_HTTP_AUTHORIZATION'];
            } elseif (isset($_SERVER['PHP_AUTH_USER'])) {
                $headers['Authorization'] = 'Basic ' . base64_encode($_SERVER['PHP_AUTH_USER'] . ':' . ($_SERVER['PHP_AUTH_PW'] ?? ''));
            }
        }
        return $headers;
    }
}

// ======================================================================
// CORS Policy for ForenShield API (Supports Web Dev & Chrome PNA)
// ======================================================================

$allowedOrigins = array_filter(
    explode(',', getenv('ALLOWED_ORIGINS') ?: ''),
    fn($o) => !empty(trim($o))
);

$requestOrigin = $_SERVER['HTTP_ORIGIN'] ?? '';

if (!empty($requestOrigin) && !headers_sent()) {
    $origin = trim($requestOrigin);
    $isLocalDev = preg_match('#^https?://(localhost|127\.0\.0\.1|10\.\d+\.\d+\.\d+|192\.168\.\d+\.\d+|172\.(1[6-9]|2[0-9]|3[0-1])\.\d+\.\d+)(:\d+)?$#i', $origin);
    
    if (empty($allowedOrigins) || in_array($origin, $allowedOrigins, true) || in_array('*', $allowedOrigins, true) || $isLocalDev) {
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Access-Control-Allow-Credentials: true');
        header('Vary: Origin');
    }
} else if (!headers_sent()) {
    header('Access-Control-Allow-Origin: *');
}

if (!headers_sent()) {
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_PRIVATE_NETWORK'])) {
        header('Access-Control-Allow-Private-Network: true');
    }
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin, Access-Control-Request-Method, Access-Control-Request-Headers, Cache-Control');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Content-Type: application/json; charset=UTF-8');
}

if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
