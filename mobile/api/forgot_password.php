<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

$payload = json_decode(file_get_contents('php://input'), true);
$email = trim($payload['email'] ?? '');

if (!$email) {
    http_response_code(400);
    echo json_encode(['error' => 'Email is required.']);
    exit;
}

$db = getDb();
$stmt = $db->prepare('SELECT id, full_name FROM users WHERE email = :email');
$stmt->execute(['email' => $email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(404);
    echo json_encode(['error' => 'User not found.']);
    exit;
}

$otpCode = str_pad((string)random_int(0, 999999), 6, '0', STR_PAD_LEFT);
$stmt = $db->prepare('INSERT INTO otp_codes (user_id, otp_code, expires_at) VALUES (:user_id, :otp_code, NOW() + INTERVAL ' . "'10 minutes'" . ')');
$stmt->execute(['user_id' => $user['id'], 'otp_code' => $otpCode]);

// TODO: send OTP via email or SMS

echo json_encode([
    'success' => true,
    'message' => 'OTP code generated. Please check your email.',
]);
