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
$stmt = $db->prepare('SELECT full_name, avatar_url FROM users WHERE id = :id');
$stmt->execute(['id' => $userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

$userName = $user ? $user['full_name'] : 'Agent Specialist';
$avatarUrl = $user['avatar_url'] ?? '';

// Auto-seed initial module notifications if user has 0 records
try {
    $checkStmt = $db->prepare('SELECT COUNT(*) FROM notifications WHERE user_id = :user_id');
    $checkStmt->execute(['user_id' => $userId]);
    $count = (int)$checkStmt->fetchColumn();

    if ($count === 0) {
        $insertStmt = $db->prepare('INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:user_id, :title, :message, :type, FALSE)');
        $initialNotifications = [
            ['title' => '🚨 Threat Detected', 'message' => 'Anomalous network traffic detected on Gateway Node #4.', 'type' => 'alert'],
            ['title' => '📚 New Course Available', 'message' => 'Digital Forensics & Incident Response course is now unlocked.', 'type' => 'academy'],
            ['title' => '🕵 New Case Assigned', 'message' => 'USB Forensics Investigation case #101 assigned to your queue.', 'type' => 'investigation'],
            ['title' => '📄 Weekly Report Generated', 'message' => 'Your weekly security posture report is ready for review.', 'type' => 'report'],
            ['title' => '🏆 Achievement Unlocked', 'message' => 'First Responder badge unlocked! +100 XP awarded.', 'type' => 'achievement'],
        ];
        foreach ($initialNotifications as $notif) {
            $insertStmt->execute([
                'user_id' => $userId,
                'title' => $notif['title'],
                'message' => $notif['message'],
                'type' => $notif['type'],
            ]);
        }
    }
} catch (Exception $e) {
    // Ignore trigger insertion failure
}

require_once __DIR__ . '/rank_service.php';

ensureLeaderboardEntry($db, $userId, $user['full_name'] ?? '');

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

// Fetch achievements for recent
$stmtAch = $db->prepare('SELECT a.code as id, a.title, a.description, a.icon as icon_name, a.xp_reward, ua.unlocked_at as unlocked_date FROM user_achievements ua JOIN achievements a ON ua.achievement_id = a.id WHERE ua.user_id = :user_id LIMIT 3');
$stmtAch->execute(['user_id' => $userId]);
$badgesRaw = $stmtAch->fetchAll(PDO::FETCH_ASSOC) ?: [];
$badges = array_map(function($b) {
    $b['is_unlocked'] = true;
    $b['progress'] = 1.0;
    return $b;
}, $badgesRaw);

// Fetch recent notifications
$stmtNotif = $db->prepare('SELECT id, title, message, created_at as timestamp, NOT is_read as is_unread, type FROM notifications WHERE user_id = :user_id ORDER BY created_at DESC LIMIT 3');
$stmtNotif->execute(['user_id' => $userId]);
$notifs = $stmtNotif->fetchAll(PDO::FETCH_ASSOC) ?: [];

// Fetch recent activity
$stmtAct = $db->prepare('SELECT id, action as title, source_module as subtitle, created_at as timestamp, event_type as type, \'star\' as icon_name FROM xp_transactions WHERE user_id = :user_id ORDER BY created_at DESC LIMIT 3');
$stmtAct->execute(['user_id' => $userId]);
$activities = $stmtAct->fetchAll(PDO::FETCH_ASSOC) ?: [];

// Aggregations
// 1. Weekly XP Earned
$stmtWxp = $db->prepare('SELECT SUM(xp_earned) FROM xp_transactions WHERE user_id = :user_id AND created_at >= NOW() - INTERVAL \'7 days\'');
$stmtWxp->execute(['user_id' => $userId]);
$weeklyXpEarned = (int)$stmtWxp->fetchColumn();

// 2. Daily XP Data (7 elements)
$dailyXpData = [];
for ($i = 6; $i >= 0; $i--) {
    $date = date('Y-m-d', strtotime("-$i days"));
    $dailyXpData[$date] = 0.0;
}
$stmtDx = $db->prepare('SELECT DATE(created_at) as dt, SUM(xp_earned) as total FROM xp_transactions WHERE user_id = :user_id AND created_at >= NOW() - INTERVAL \'7 days\' GROUP BY DATE(created_at)');
$stmtDx->execute(['user_id' => $userId]);
while ($row = $stmtDx->fetch(PDO::FETCH_ASSOC)) {
    $dt = $row['dt'];
    if (isset($dailyXpData[$dt])) {
        $dailyXpData[$dt] = (double)$row['total'];
    }
}
$dailyXpArray = array_values($dailyXpData);

// 3. Weekly Courses Completed
$stmtWc = $db->prepare('SELECT COUNT(*) FROM user_course_progress WHERE user_id = :user_id AND completion_percentage = 100 AND completed_at >= NOW() - INTERVAL \'7 days\'');
$stmtWc->execute(['user_id' => $userId]);
$weeklyCoursesCompleted = (int)$stmtWc->fetchColumn();

// 4. Weekly Cases Solved
$stmtWcs = $db->prepare('SELECT COUNT(*) FROM user_case_progress WHERE user_id = :user_id AND is_solved = TRUE AND completed_at >= NOW() - INTERVAL \'7 days\'');
$stmtWcs->execute(['user_id' => $userId]);
$weeklyCasesSolved = (int)$stmtWcs->fetchColumn();

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
    'today_risk_message' => 'Pending backend integration',
    
    // Missions not currently supported
    'current_mission_title' => '',
    'mission_estimated_minutes' => 0,
    'mission_difficulty' => '',
    'mission_progress' => 0.0,
    'is_mission_completed' => false,
    
    // Explicitly neutral since we cannot securely track 'last_accessed'
    'current_course_title' => 'Ready to start',
    'current_module_title' => '',
    'course_completion_percentage' => 0.0,
    'course_time_remaining' => '',
    
    'active_case_id' => '',
    'active_case_title' => 'No Active Cases',
    'active_case_type' => '',
    'evidence_count' => 0,
    'case_status' => 'PENDING',
    
    'completed_objectives' => 0,
    'total_objectives' => 0,
    
    // Real aggregated stats
    'weekly_courses_completed' => $weeklyCoursesCompleted,
    'weekly_cases_solved' => $weeklyCasesSolved,
    'weekly_hours_practiced' => 0.0,
    'weekly_xp_earned' => $weeklyXpEarned,
    'daily_xp_data' => $dailyXpArray,
    
    'achievements' => $badges,
    'notifications' => $notifs,
    'recent_activities' => $activities
];

echo json_encode($response);
