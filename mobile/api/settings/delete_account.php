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
$password = $payload['password'] ?? '';

if (!$password) {
    http_response_code(400);
    echo json_encode(['error' => 'Password is required.']);
    exit;
}

$db = getDb();
$stmt = $db->prepare('SELECT password_hash FROM users WHERE id = :user_id');
$stmt->execute(['user_id' => $userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user || !password_verify($password, $user['password_hash'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid password.']);
    exit;
}

try {
    $db->beginTransaction();
    
    // Delete user-owned records in order
    $db->prepare('DELETE FROM refresh_tokens WHERE user_id = ?')->execute([$userId]);
    $db->prepare('DELETE FROM device_sessions WHERE user_id = ?')->execute([$userId]);
    $db->prepare('DELETE FROM login_history WHERE user_id = ?')->execute([$userId]);
    $db->prepare('DELETE FROM notifications WHERE user_id = ?')->execute([$userId]);
    $db->prepare('DELETE FROM achievements WHERE user_id = ?')->execute([$userId]);
    $db->prepare('DELETE FROM leaderboard WHERE user_id = ?')->execute([$userId]);
    
    // Core user record
    $db->prepare('DELETE FROM users WHERE id = ?')->execute([$userId]);
    
    $db->commit();
    echo json_encode(['success' => true]);
} catch (Exception $e) {
    $db->rollBack();
    http_response_code(500);
    echo json_encode(['error' => 'Failed to delete account.']);
}
