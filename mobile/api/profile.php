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

require_once __DIR__ . '/rank_service.php';

ensureLeaderboardEntry($db, $userId, $user['full_name']);

$stmtStats = $db->prepare('SELECT * FROM leaderboard_stats WHERE user_id = :user_id');
$stmtStats->execute(['user_id' => $userId]);
$stats = $stmtStats->fetch(PDO::FETCH_ASSOC);

$totalXp = (int)($stats['total_xp'] ?? 0);
$level = getLevelForXp($totalXp);
$nextLevelXp = $level * 500;

$rankTitle = 'Trainee';
if ($level >= 5) $rankTitle = 'Senior Analyst';
elseif ($level == 4) $rankTitle = 'Specialist';
elseif ($level == 3) $rankTitle = 'Investigator';
elseif ($level == 2) $rankTitle = 'Analyst';

// Fetch XP history
$stmtXp = $db->prepare('SELECT id, action as title, source_module as source, xp_earned as xp_amount, created_at as timestamp FROM xp_transactions WHERE user_id = :user_id ORDER BY created_at DESC LIMIT 5');
$stmtXp->execute(['user_id' => $userId]);
$xpHistory = $stmtXp->fetchAll(PDO::FETCH_ASSOC) ?: [];

// Fetch achievements
$stmtAch = $db->prepare('SELECT a.code as id, a.title, a.description, a.icon as icon_name, a.xp_reward, ua.unlocked_at as unlocked_date FROM user_achievements ua JOIN achievements a ON ua.achievement_id = a.id WHERE ua.user_id = :user_id');
$stmtAch->execute(['user_id' => $userId]);
$badgesRaw = $stmtAch->fetchAll(PDO::FETCH_ASSOC) ?: [];
$badges = array_map(function($b) {
    $b['is_unlocked'] = true;
    return $b;
}, $badgesRaw);

$response = [
    'id' => (string)$user['id'],
    'full_name' => $user['full_name'],
    'email' => $user['email'],
    'phone' => $user['phone'] ?? '',
    'role' => 'Forensic Specialist',
    'avatar_url' => $user['avatar_url'] ?? '',
    'xp_points' => $totalXp,
    'rank_title' => $rankTitle,
    'member_since' => date('M Y', strtotime($user['created_at'])),
    'account_status' => 'Active / Verified',
    'level' => $level,
    'next_level_xp' => $nextLevelXp,
    'stats' => [
        'total_learning_hours' => 0.0, // Replace with actual if tracked
        'cases_solved' => (int)($stats['investigations_completed'] ?? 0),
        'courses_completed' => (int)($stats['courses_completed'] ?? 0),
        'current_streak_days' => (int)($stats['current_streak'] ?? 0),
        'security_score' => 100 // Default or calculate
    ],
    'badges' => $badges,
    'xp_history' => $xpHistory
];

echo json_encode($response);
