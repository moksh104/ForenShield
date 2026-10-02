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

// ── High Performance Fast Cache (20s TTL) ──
$cacheFile = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'foren_mc_' . $userId . '.json';
$isRefresh = isset($_GET['refresh']) || (isset($_SERVER['HTTP_CACHE_CONTROL']) && strpos($_SERVER['HTTP_CACHE_CONTROL'], 'no-cache') !== false);

if (!$isRefresh && file_exists($cacheFile) && (time() - filemtime($cacheFile) < 20)) {
    header('X-Cache: HIT');
    echo file_get_contents($cacheFile);
    exit;
}

$db = getDb();

// ── Unified CTE High-Performance Aggregation Query ──
// Consolidates 10 round trips across the network into 1 single round trip!
$sql = "
WITH 
  u AS (
    SELECT full_name, avatar_url FROM users WHERE id = :user_id
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
      'unlocked_date', a.unlocked_at,
      'is_unlocked', true,
      'progress', 1.0
    )), '[]'::json) AS badges
    FROM (
      SELECT a.code, a.title, a.description, a.icon, a.xp_reward, ua.unlocked_at
      FROM user_achievements ua
      JOIN achievements a ON ua.achievement_id = a.id
      WHERE ua.user_id = :user_id
      LIMIT 3
    ) a
  ),
  notifs AS (
    SELECT COALESCE(json_agg(json_build_object(
      'id', n.id,
      'title', n.title,
      'message', n.message,
      'timestamp', n.created_at,
      'is_unread', NOT n.is_read,
      'type', n.type
    )), '[]'::json) AS items,
    COUNT(*) AS total_count
    FROM (
      SELECT id, title, message, created_at, is_read, type
      FROM notifications
      WHERE user_id = :user_id
      ORDER BY created_at DESC
      LIMIT 3
    ) n
  ),
  acts AS (
    SELECT COALESCE(json_agg(json_build_object(
      'id', x.id,
      'title', x.action,
      'subtitle', x.source_module,
      'timestamp', x.created_at,
      'type', x.event_type,
      'icon_name', 'star'
    )), '[]'::json) AS items
    FROM (
      SELECT id, action, source_module, created_at, event_type
      FROM xp_transactions
      WHERE user_id = :user_id
      ORDER BY created_at DESC
      LIMIT 3
    ) x
  ),
  weekly_stats AS (
    SELECT 
      COALESCE((SELECT SUM(xp_earned) FROM xp_transactions WHERE user_id = :user_id AND created_at >= NOW() - INTERVAL '7 days'), 0) AS weekly_xp,
      COALESCE((SELECT COUNT(*) FROM user_course_progress WHERE user_id = :user_id AND completion_percentage = 100 AND completed_at >= NOW() - INTERVAL '7 days'), 0) AS weekly_courses,
      COALESCE((SELECT COUNT(*) FROM user_case_progress WHERE user_id = :user_id AND is_solved = TRUE AND completed_at >= NOW() - INTERVAL '7 days'), 0) AS weekly_cases
  ),
  daily_xp AS (
    SELECT COALESCE(json_object_agg(dt, total), '{}'::json) AS data
    FROM (
      SELECT DATE(created_at)::text as dt, SUM(xp_earned) as total
      FROM xp_transactions
      WHERE user_id = :user_id AND created_at >= NOW() - INTERVAL '7 days'
      GROUP BY DATE(created_at)
    ) d
  ),
  active_course AS (
    SELECT c.title as course_title, COALESCE(ucp.completion_percentage, 0.0) as completion_percentage
    FROM user_course_progress ucp
    JOIN courses c ON ucp.course_id = c.id
    WHERE ucp.user_id = :user_id AND ucp.completion_percentage < 100
    ORDER BY ucp.last_accessed_at DESC NULLS LAST
    LIMIT 1
  ),
  active_case AS (
    SELECT ic.id as case_id, ic.title as case_title, ic.category as case_type, COALESCE(ucp.status, 'IN PROGRESS') as case_status
    FROM user_case_progress ucp
    JOIN investigation_cases ic ON ucp.case_id = ic.id
    WHERE ucp.user_id = :user_id AND ucp.is_solved = FALSE
    ORDER BY ucp.last_accessed_at DESC NULLS LAST
    LIMIT 1
  )
SELECT 
  (SELECT full_name FROM u) AS full_name,
  (SELECT avatar_url FROM u) AS avatar_url,
  (SELECT total_xp FROM ls) AS total_xp,
  (SELECT badges FROM ach) AS badges,
  (SELECT items FROM notifs) AS notifs,
  (SELECT total_count FROM notifs) AS notif_count,
  (SELECT items FROM acts) AS activities,
  (SELECT weekly_xp FROM weekly_stats) AS weekly_xp,
  (SELECT weekly_courses FROM weekly_stats) AS weekly_courses,
  (SELECT weekly_cases FROM weekly_stats) AS weekly_cases,
  (SELECT data FROM daily_xp) AS daily_xp,
  (SELECT course_title FROM active_course) AS active_course_title,
  (SELECT completion_percentage FROM active_course) AS active_course_progress,
  (SELECT case_id FROM active_case) AS active_case_id,
  (SELECT case_title FROM active_case) AS active_case_title,
  (SELECT case_type FROM active_case) AS active_case_type,
  (SELECT case_status FROM active_case) AS active_case_status;
";

$stmt = $db->prepare($sql);
$stmt->execute(['user_id' => $userId]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

// If user has no leaderboard_stats record yet, lazily ensure it
if ($row['total_xp'] === null) {
    ensureLeaderboardEntry($db, (int)$userId, $row['full_name'] ?? '');
    $totalXp = 0;
} else {
    $totalXp = (int)$row['total_xp'];
}

$userName = !empty($row['full_name']) ? $row['full_name'] : 'Agent Specialist';
$avatarUrl = $row['avatar_url'] ?? '';

// Level & Rank calculations in memory (0ms)
$level = getLevelForXp($totalXp);
$nextLevelXp = $level * 500;
$rankTitle = 'Trainee';
if ($level >= 5) $rankTitle = 'Senior Analyst';
elseif ($level == 4) $rankTitle = 'Specialist';
elseif ($level == 3) $rankTitle = 'Investigator';
elseif ($level == 2) $rankTitle = 'Analyst';

// Badges, Notifications, Activities from JSON aggregation
$badges = json_decode($row['badges'] ?? '[]', true) ?: [];
$notifs = json_decode($row['notifs'] ?? '[]', true) ?: [];
$activities = json_decode($row['activities'] ?? '[]', true) ?: [];

// Daily XP Array (7-day timeline)
$dailyXpRaw = json_decode($row['daily_xp'] ?? '{}', true) ?: [];
$dailyXpArray = [];
for ($i = 6; $i >= 0; $i--) {
    $dateKey = date('Y-m-d', strtotime("-$i days"));
    $dailyXpArray[] = isset($dailyXpRaw[$dateKey]) ? (double)$dailyXpRaw[$dateKey] : 0.0;
}

$courseCompletionPct = $row['active_course_progress'] !== null ? ((float)$row['active_course_progress'] / 100.0) : 0.0;

$response = [
    'user_name' => $userName,
    'user_avatar_url' => $avatarUrl,
    'rank_title' => $rankTitle,
    'xp_points' => $totalXp,
    'user_level' => $level,
    'next_level_xp' => $nextLevelXp,
    
    // Explicitly un-fabricated properties
    'overall_threat_level' => 'UNKNOWN',
    'security_score' => 0,
    'today_risk_message' => 'Operational Ready',
    
    // Missions
    'current_mission_title' => '',
    'mission_estimated_minutes' => 0,
    'mission_difficulty' => '',
    'mission_progress' => 0.0,
    'is_mission_completed' => false,
    
    // Course progress
    'current_course_title' => $row['active_course_title'] ?? 'Digital Forensics Fundamentals',
    'current_module_title' => 'Core Curriculum',
    'course_completion_percentage' => $courseCompletionPct,
    'course_time_remaining' => '',
    
    // Active Case
    'active_case_id' => (string)($row['active_case_id'] ?? ''),
    'active_case_title' => $row['active_case_title'] ?? '',
    'active_case_type' => $row['active_case_type'] ?? '',
    'evidence_count' => 0,
    'case_status' => $row['active_case_status'] ?? 'PENDING',
    
    'completed_objectives' => 0,
    'total_objectives' => 0,
    
    // Real aggregated stats
    'weekly_courses_completed' => (int)($row['weekly_courses'] ?? 0),
    'weekly_cases_solved' => (int)($row['weekly_cases'] ?? 0),
    'weekly_hours_practiced' => 0.0,
    'weekly_xp_earned' => (int)($row['weekly_xp'] ?? 0),
    'daily_xp_data' => $dailyXpArray,
    
    'achievements' => $badges,
    'notifications' => $notifs,
    'recent_activities' => $activities
];

$jsonOutput = json_encode($response);

// Persist to user cache file
@file_put_contents($cacheFile, $jsonOutput);

header('X-Cache: MISS');
echo $jsonOutput;
