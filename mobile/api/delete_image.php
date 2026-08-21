<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Cloudinary\Configuration\Configuration;
use Cloudinary\Api\Admin\AdminApi;

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
    $userId = $decoded->sub ?? null;
    if (!$userId) {
        throw new Exception('Invalid token payload.');
    }
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$publicId = $data['public_id'] ?? null;

if (!$publicId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing public_id.']);
    exit;
}

try {
    Configuration::instance([
      'cloud' => [
        'cloud_name' => CLOUDINARY_CLOUD_NAME, 
        'api_key' => CLOUDINARY_API_KEY, 
        'api_secret' => CLOUDINARY_API_SECRET],
      'url' => [
        'secure' => true]]);

    $adminApi = new AdminApi();
    $result = $adminApi->deleteAssets($publicId);

    echo json_encode([
        'success' => true,
        'result' => $result
    ]);

} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
