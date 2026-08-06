<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

header('Content-Type: application/json');

// Validate JWT Header
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

$authUserId = $decoded->sub ?? null;
if (!$authUserId) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid token payload.']);
    exit;
}

// Parse Input
$payload = json_decode(file_get_contents('php://input'), true);
$userId = (int)($payload['user_id'] ?? $authUserId);
$fcmToken = trim($payload['fcm_token'] ?? '');

if (!$fcmToken) {
    http_response_code(400);
    echo json_encode(['error' => 'FCM token is required.']);
    exit;
}

try {
    $db = getDb();
    $stmt = $db->prepare('UPDATE users SET fcm_token = :fcm_token WHERE id = :id');
    $stmt->execute([
        'fcm_token' => $fcmToken,
        'id' => $userId,
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'FCM token saved successfully.',
        'user_id' => $userId,
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to save FCM token: ' . $e->getMessage()]);
}
