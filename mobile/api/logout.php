<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

$payload = json_decode(file_get_contents('php://input'), true);

$refreshToken = trim(
    $payload['refreshToken']
    ?? $payload['refresh_token']
    ?? ''
);

if (!$refreshToken) {
    http_response_code(400);

    echo json_encode([
        'error' => 'Refresh token is required.'
    ]);

    exit;
}

$db = getDb();

$stmt = $db->prepare('SELECT user_id FROM refresh_tokens WHERE refresh_token = :refresh_token');
$stmt->execute(['refresh_token' => $refreshToken]);
$rt = $stmt->fetch(PDO::FETCH_ASSOC);

if ($rt) {
    // Update login history logout time
    $db->prepare('UPDATE login_history SET logout_time = CURRENT_TIMESTAMP WHERE user_id = ? AND logout_time IS NULL AND status = \'success\'')->execute([$rt['user_id']]);
    
    // Remove the device session for this token
    $db->prepare('DELETE FROM device_sessions WHERE session_token = ?')->execute([$refreshToken]);
}

$stmt = $db->prepare(
    'DELETE FROM refresh_tokens
     WHERE refresh_token = :refresh_token'
);

$stmt->execute([
    'refresh_token' => $refreshToken
]);

echo json_encode([
    'success' => true
]);