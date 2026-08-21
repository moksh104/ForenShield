<?php
require_once __DIR__ . '/../cors.php';
require_once __DIR__ . '/../config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';

if (!preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$token = $matches[1];

try {
    $decoded = JWT::decode($token, new Key(JWT_SECRET, 'HS256'));
    $userId = $decoded->sub;
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid token']);
    exit;
}

$db = getDb();

// Fetch Profile
$stmt = $db->prepare('SELECT id, full_name, email, role, avatar_url, created_at FROM users WHERE id = ?');
$stmt->execute([$userId]);
$profile = $stmt->fetch(PDO::FETCH_ASSOC);

// Fetch Achievements
$stmt = $db->prepare('SELECT * FROM achievements WHERE user_id = ?');
$stmt->execute([$userId]);
$achievements = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Fetch Leaderboard/XP
$stmt = $db->prepare('SELECT * FROM leaderboard WHERE user_id = ?');
$stmt->execute([$userId]);
$leaderboard = $stmt->fetch(PDO::FETCH_ASSOC);

// Fetch Login History
$stmt = $db->prepare('SELECT * FROM login_history WHERE user_id = ? ORDER BY login_time DESC');
$stmt->execute([$userId]);
$loginHistory = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Fetch Device Sessions
$stmt = $db->prepare('SELECT * FROM device_sessions WHERE user_id = ?');
$stmt->execute([$userId]);
$deviceSessions = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Fetch Notifications
$stmt = $db->prepare('SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC');
$stmt->execute([$userId]);
$notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);

$exportData = [
    'generated_at' => date('c'),
    'user' => $profile,
    'leaderboard' => $leaderboard,
    'achievements' => $achievements,
    'notifications' => $notifications,
    'login_history' => $loginHistory,
    'device_sessions' => $deviceSessions,
    // Add settings from Flutter side later or omit here since Flutter holds local preferences. 
    // We will merge this in Flutter.
];

echo json_encode($exportData);
