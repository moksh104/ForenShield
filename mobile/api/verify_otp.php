<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;

$payload = json_decode(file_get_contents('php://input'), true);

$email = trim($payload['email'] ?? '');
$otpCode = trim($payload['otp_code'] ?? '');

if (!$email || !$otpCode) {
    http_response_code(400);

    echo json_encode([
        'error' => 'Email and OTP code are required.'
    ]);

    exit;
}

$db = getDb();

$stmt = $db->prepare(
    'SELECT
        o.id,
        o.user_id,
        o.otp_code,
        o.expires_at,
        u.email,
        u.full_name
     FROM otp_codes o
     JOIN users u
     ON u.id = o.user_id
     WHERE u.email = :email
     AND o.otp_code = :otp_code'
);

$stmt->execute([
    ':email' => $email,
    ':otp_code' => (string)$otpCode
]);

$record = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$record) {
    http_response_code(401);

    echo json_encode([
        'error' => 'Invalid OTP code.'
    ]);

    exit;
}

if (strtotime($record['expires_at']) < time()) {
    http_response_code(401);

    echo json_encode([
        'error' => 'OTP code has expired.'
    ]);

    exit;
}

$stmt = $db->prepare(
    'DELETE FROM otp_codes WHERE id = :id'
);

$stmt->execute([
    ':id' => $record['id']
]);

$accessToken = JWT::encode(
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

$refreshToken = bin2hex(random_bytes(32));

echo json_encode([
    'success' => true,
    'accessToken' => $accessToken,
    'refreshToken' => $refreshToken
]);