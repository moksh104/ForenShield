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
$stmt = $db->prepare('SELECT id, full_name, email, phone, avatar_url, created_at FROM users WHERE id = :id');
$stmt->execute(['id' => $userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(404);
    echo json_encode(['error' => 'User not found.']);
    exit;
}

try {
    $check = $db->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND type = 'achievement'");
    $check->execute(['user_id' => $userId]);
    if ((int)$check->fetchColumn() === 0) {
        $stmt = $db->prepare("INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:user_id, '🏆 Achievement Unlocked', 'First Responder badge unlocked! +100 XP awarded.', 'achievement', FALSE)");
        $stmt->execute(['user_id' => $userId]);
    }
} catch (Exception $e) {
    // Ignore trigger check failure
}

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
    'next_level_xp' => 2000,
    'stats' => [
        'total_learning_hours' => 24.5,
        'cases_solved' => 12,
        'courses_completed' => 4,
        'current_streak_days' => 7,
        'security_score' => 88
    ],
    'badges' => [
        [
            'id' => 'b1',
            'title' => 'First Responder',
            'description' => 'Completed your first live simulation drill',
            'icon_name' => 'shield',
            'unlocked_date' => '2026-06-10',
            'xp_reward' => 100,
            'is_unlocked' => true
        ],
        [
            'id' => 'b2',
            'title' => 'Memory Master',
            'description' => 'Solved 10 RAM memory forensics cases',
            'icon_name' => 'psychology',
            'unlocked_date' => '2026-07-02',
            'xp_reward' => 300,
            'is_unlocked' => true
        ]
    ],
    'xp_history' => [
        [
            'id' => 'xp1',
            'title' => 'Completed Lesson: Volatility 3 Analysis',
            'source' => 'Cyber Academy',
            'xp_amount' => 50,
            'timestamp' => '2h ago'
        ]
    ]
];

echo json_encode($response);
