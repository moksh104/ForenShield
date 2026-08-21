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

$authUserId = (int)($decoded->sub ?? 0);
if (!$authUserId) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid token payload.']);
    exit;
}

$db = getDb();
$input = json_decode(file_get_contents('php://input'), true);
$notificationId = (int)($input['notification_id'] ?? $_GET['id'] ?? 0);
$markAll = !empty($input['mark_all']);

try {
    if ($markAll) {
        $stmt = $db->prepare('UPDATE notifications SET is_read = TRUE WHERE user_id = :user_id');
        $stmt->execute(['user_id' => $authUserId]);
    } elseif ($notificationId > 0) {
        $stmt = $db->prepare('UPDATE notifications SET is_read = TRUE WHERE id = :id AND user_id = :user_id');
        $stmt->execute(['id' => $notificationId, 'user_id' => $authUserId]);
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Valid notification_id or mark_all flag required.']);
        exit;
    }

    echo json_encode([
        'success' => true,
        'message' => 'Notification(s) marked as read.',
    ]);
} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
