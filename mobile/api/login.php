<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;

$payload = json_decode(file_get_contents('php://input'), true);
$email = trim($payload['email'] ?? '');
$password = $payload['password'] ?? '';

if (!$email || !$password) {
    http_response_code(400);
    echo json_encode(['error' => 'Email and password are required.']);
    exit;
}

$db = getDb();
$stmt = $db->prepare('SELECT id, full_name, email, password_hash FROM users WHERE email = :email');
$stmt->execute(['email' => $email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user || !password_verify($password, $user['password_hash'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid credentials.']);
    exit;
}

$accessToken = JWT::encode(
    [
        'sub' => $user['id'],
        'email' => $user['email'],
        'name' => $user['full_name'],
        'iat' => time(),
        'exp' => time() + 3600,
    ],
    JWT_SECRET,
    'HS256'
);

$refreshToken = bin2hex(random_bytes(32));
$stmt = $db->prepare('INSERT INTO refresh_tokens (user_id, refresh_token, created_at) VALUES (:user_id, :refresh_token, NOW())');
$stmt->execute(['user_id' => $user['id'], 'refresh_token' => $refreshToken]);

$response = [
    'accessToken' => $accessToken,
    'refreshToken' => $refreshToken,
    'user' => [
        'id' => $user['id'],
        'email' => $user['email'],
        'displayName' => $user['full_name'],
    ],
];

echo json_encode($response);
