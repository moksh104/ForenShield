<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/rank_service.php';

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

// ── Fast Cache (30s TTL) ──
$cacheFile = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'foren_prof_' . $userId . '.json';
$isRefresh = isset($_GET['refresh']) || (isset($_SERVER['HTTP_CACHE_CONTROL']) && strpos($_SERVER['HTTP_CACHE_CONTROL'], 'no-cache') !== false);

if (!$isRefresh && file_exists($cacheFile) && (time() - filemtime($cacheFile) < 30)) {
    header('X-Cache: HIT');
    echo file_get_contents($cacheFile);
    exit;
}

$db = getDb();

// ── Unified Profile Query ──
$sql = "
WITH 
  u AS (
    SELECT id, full_name, email, phone, avatar_url, created_at FROM users WHERE id = :user_id
  ),
  ls AS (
    SELECT total_xp, investigations_completed, courses_completed, current_streak
    FROM leaderboard_stats WHERE user_id = :user_id
  ),
  ach AS (
    SELECT COALESCE(json_agg(json_build_object(
      'id', a.code,
      'title', a.title,
      'description', a.description,
      'icon_name', a.icon,
      'xp_reward', a.xp_reward,
      'unlocked_date', ua.unlocked_at,
      'is_unlocked', true
    )), '[]'::json) AS badges
    FROM user_achievements ua
    JOIN achievements a ON ua.achievement_id = a.id
    WHERE ua.user_id = :user_id
  ),
  xph AS (
    SELECT COALESCE(json_agg(json_build_object(
      'id', x.id,
      'title', x.action,
      'source', x.source_module,
      'xp_amount', x.xp_earned,
      'timestamp', x.created_at
    )), '[]'::json) AS history
    FROM (
      SELECT id, action, source_module, xp_earned, created_at
      FROM xp_transactions
      WHERE user_id = :user_id
      ORDER BY created_at DESC
      LIMIT 5
    ) x
  )
SELECT 
  u.*,
  ls.total_xp,
  ls.investigations_completed,
  ls.courses_completed,
  ls.current_streak,
  (SELECT badges FROM ach) AS badges,
  (SELECT history FROM xph) AS xp_history
FROM u
LEFT JOIN ls ON TRUE;
";

$stmt = $db->prepare($sql);
$stmt->execute(['user_id' => $userId]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row) {
    http_response_code(404);
    echo json_encode(['error' => 'User not found.']);
    exit;
}

$totalXp = (int)($row['total_xp'] ?? 0);
$level = getLevelForXp($totalXp);
$nextLevelXp = $level * 500;

$rankTitle = 'Trainee';
if ($level >= 5) $rankTitle = 'Senior Analyst';
elseif ($level == 4) $rankTitle = 'Specialist';
elseif ($level == 3) $rankTitle = 'Investigator';
elseif ($level == 2) $rankTitle = 'Analyst';

$badges = json_decode($row['badges'] ?? '[]', true) ?: [];
$xpHistory = json_decode($row['xp_history'] ?? '[]', true) ?: [];

$response = [
    'id' => (string)$row['id'],
    'full_name' => $row['full_name'],
    'email' => $row['email'],
    'phone' => $row['phone'] ?? '',
    'role' => 'Forensic Specialist',
    'avatar_url' => $row['avatar_url'] ?? '',
    'xp_points' => $totalXp,
    'rank_title' => $rankTitle,
    'member_since' => date('M Y', strtotime($row['created_at'])),
    'account_status' => 'Active / Verified',
    'level' => $level,
    'next_level_xp' => $nextLevelXp,
    'stats' => [
        'total_learning_hours' => 0.0,
        'cases_solved' => (int)($row['investigations_completed'] ?? 0),
        'courses_completed' => (int)($row['courses_completed'] ?? 0),
        'current_streak_days' => (int)($row['current_streak'] ?? 0),
        'security_score' => 100
    ],
    'badges' => $badges,
    'xp_history' => $xpHistory
];

$jsonOutput = json_encode($response);
@file_put_contents($cacheFile, $jsonOutput);

header('X-Cache: MISS');
echo $jsonOutput;
