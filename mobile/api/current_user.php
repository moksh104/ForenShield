<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

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

$userId = $decoded->sub ?? null;
if (!$userId) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid token payload.']);
    exit;
}

$db = getDb();
$stmt = $db->prepare('SELECT id, full_name, email, created_at FROM users WHERE id = :id');
$stmt->execute(['id' => $userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(404);
    echo json_encode(['error' => 'User not found.']);
    exit;
}

$response = [
    'id' => (string)$user['id'],
    'email' => $user['email'],
    'displayName' => $user['full_name'],
    'avatarUrl' => null,
    'totalXp' => 0,
    'rank' => 'Trainee',
    'currentStreak' => 0,
    'createdAt' => date(DATE_ATOM, strtotime($user['created_at'])),
];

echo json_encode($response);
