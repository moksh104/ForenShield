<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
use Firebase\JWT\JWT;

$rawInput = file_get_contents('php://input');

$payload = json_decode($rawInput, true);

$refreshToken = trim(
    $payload['refreshToken']
    ?? $payload['refresh_token']
    ?? ''
);

if (!$refreshToken) {
    echo json_encode([
        'rawInput' => $rawInput,
        'payload' => $payload,
        'error' => 'Refresh token is required.'
    ]);
    exit;
}

if (!$refreshToken) {
    http_response_code(400);
    echo json_encode(['error' => 'Refresh token is required.']);
    exit;
}

$db = getDb();
$stmt = $db->prepare(
    'SELECT r.user_id, u.email, u.full_name
     FROM refresh_tokens r
     JOIN users u ON u.id = r.user_id
     WHERE r.refresh_token = :refresh_token'
);
$stmt->execute(['refresh_token' => $refreshToken]);
$record = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$record) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid refresh token.']);
    exit;
}

$newAccessToken = JWT::encode(
    [
        'sub' => $record['user_id'],
        'email' => $record['email'],
        'name' => $record['full_name'],
        'iat' => time(),
        'exp' => time() + 3600,
    ],
    JWT_SECRET,
    'HS256'
);

echo json_encode([
    'accessToken' => $newAccessToken,
]);
