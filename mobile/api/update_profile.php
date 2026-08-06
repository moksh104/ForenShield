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

$data = json_decode(file_get_contents('php://input'), true);

$fullName = $data['full_name'] ?? null;
$email = $data['email'] ?? null;
$phone = $data['phone'] ?? null;
$avatarUrl = $data['avatar_url'] ?? null;

$db = getDb();
$updates = [];
$params = ['id' => $userId];

if ($fullName !== null) {
    $updates[] = 'full_name = :full_name';
    $params['full_name'] = $fullName;
}
if ($email !== null) {
    $updates[] = 'email = :email';
    $params['email'] = $email;
}
if ($phone !== null) {
    $updates[] = 'phone = :phone';
    $params['phone'] = $phone;
}
if ($avatarUrl !== null) {
    $updates[] = 'avatar_url = :avatar_url';
    $params['avatar_url'] = $avatarUrl;
}

if (!empty($updates)) {
    $sql = 'UPDATE users SET ' . implode(', ', $updates) . ', updated_at = CURRENT_TIMESTAMP WHERE id = :id';
    $stmt = $db->prepare($sql);
    $stmt->execute($params);
}

// Return updated profile
$stmt = $db->prepare('SELECT id, full_name, email, phone, avatar_url, created_at FROM users WHERE id = :id');
$stmt->execute(['id' => $userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

$response = [
    'id' => (string)$user['id'],
    'full_name' => $user['full_name'],
    'email' => $user['email'],
    'phone' => $user['phone'] ?? '',
    'role' => 'Forensic Specialist',
    'avatar_url' => $user['avatar_url'] ?? '',
    'xp_points' => 1450,
    'rank_title' => 'Analyst II',
    'member_since' => date('M Y', strtotime($user['created_at'])),
    'account_status' => 'Active / Verified',
    'level' => 5,
    'next_level_xp' => 2000
];

echo json_encode($response);
