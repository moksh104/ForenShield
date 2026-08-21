<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Cloudinary\Configuration\Configuration;
use Cloudinary\Api\Upload\UploadApi;

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

if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo json_encode(['error' => 'No image uploaded or upload error.']);
    exit;
}

$fileSize = $_FILES['image']['size'];
if ($fileSize > 5 * 1024 * 1024) { // 5MB limit
    http_response_code(400);
    echo json_encode(['error' => 'File size exceeds the 5MB limit.']);
    exit;
}

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mimeType = finfo_file($finfo, $_FILES['image']['tmp_name']);
finfo_close($finfo);

$allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp'];
if (!in_array($mimeType, $allowedMimeTypes)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid file type. Only JPEG, PNG, and WebP are allowed.']);
    exit;
}

$fileTmpPath = $_FILES['image']['tmp_name'];
$folder = $_POST['folder'] ?? 'forenshield/general';

try {
    Configuration::instance([
      'cloud' => [
        'cloud_name' => CLOUDINARY_CLOUD_NAME, 
        'api_key' => CLOUDINARY_API_KEY, 
        'api_secret' => CLOUDINARY_API_SECRET],
      'url' => [
        'secure' => true]]);

    $upload = (new UploadApi())->upload($fileTmpPath, [
        'folder' => $folder,
        'overwrite' => true,
        'resource_type' => 'auto'
    ]);

    $url = $upload['secure_url'] ?? $upload['url'];
    $publicId = $upload['public_id'];

    echo json_encode([
        'success' => true,
        'url' => $url,
        'public_id' => $publicId
    ]);

} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
