<?php
require_once __DIR__ . '/../cors.php';
require_once __DIR__ . '/../config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';

if (!preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$token = $matches[1];

try {
    $decoded = JWT::decode($token, new Key(JWT_SECRET, 'HS256'));
    $userId = $decoded->sub;
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid token']);
    exit;
}

$db = getDb();
$stmt = $db->prepare('SELECT id, device_name, platform, app_version, ip_address, login_at, last_active, is_current, fcm_token FROM device_sessions WHERE user_id = :user_id ORDER BY last_active DESC');
$stmt->execute(['user_id' => $userId]);
$devices = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode(['devices' => $devices]);
