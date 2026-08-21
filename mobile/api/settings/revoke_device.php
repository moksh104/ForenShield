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

$payload = json_decode(file_get_contents('php://input'), true);
$sessionId = $payload['session_id'] ?? null;

if (!$sessionId) {
    http_response_code(400);
    echo json_encode(['error' => 'Session ID is required']);
    exit;
}

$db = getDb();
$stmt = $db->prepare('DELETE FROM device_sessions WHERE id = ? AND user_id = ?');
$stmt->execute([$sessionId, $userId]);

echo json_encode(['success' => true]);
