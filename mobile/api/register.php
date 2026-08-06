<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;

$payload = json_decode(file_get_contents('php://input'), true);

$fullName = trim($payload['full_name'] ?? '');
$email = trim($payload['email'] ?? '');
$phone = trim($payload['phone'] ?? '');
$password = $payload['password'] ?? '';

if (!$fullName || !$email || !$password) {
    http_response_code(400);

    echo json_encode([
        'error' => 'Full name, email, and password are required.'
    ]);

    exit;
}

try {
    $db = getDb();

    $stmt = $db->prepare(
        'SELECT id FROM users WHERE email = :email'
    );

    $stmt->execute([
        'email' => $email
    ]);

    if ($stmt->fetch()) {
        http_response_code(409);

        echo json_encode([
            'error' => 'Email already registered.'
        ]);

        exit;
    }

    $passwordHash = password_hash(
        $password,
        PASSWORD_BCRYPT
    );

    $stmt = $db->prepare(
        'INSERT INTO users
        (full_name, email, password_hash, created_at)
        VALUES
        (:full_name, :email, :password_hash, NOW())
        RETURNING id'
    );

    $stmt->execute([
        'full_name' => $fullName,
        'email' => $email,
        'password_hash' => $passwordHash
    ]);

    $userId = $stmt->fetchColumn();

    $accessToken = JWT::encode(
        [
            'sub' => $userId,
            'email' => $email,
            'name' => $fullName,
            'iat' => time(),
            'exp' => time() + 3600
        ],
        JWT_SECRET,
        'HS256'
    );

    $refreshToken = bin2hex(random_bytes(32));

    $stmt = $db->prepare(
        'INSERT INTO refresh_tokens
        (user_id, refresh_token, created_at)
        VALUES
        (:user_id, :refresh_token, NOW())'
    );

    $stmt->execute([
        'user_id' => $userId,
        'refresh_token' => $refreshToken
    ]);

    echo json_encode([
        'success' => true,
        'accessToken' => $accessToken,
        'refreshToken' => $refreshToken,
        'user' => [
            'id' => $userId,
            'email' => $email,
            'displayName' => $fullName,
            'phone' => $phone
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);

    echo json_encode([
        'error' => $e->getMessage()
    ]);
}