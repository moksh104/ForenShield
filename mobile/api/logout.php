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