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

$response = [
    'user_name' => $userName,
    'user_avatar_url' => $avatarUrl,
    'rank_title' => 'Analyst II',
    'xp_points' => 1450,
    'user_level' => 5,
    'next_level_xp' => 2000,
    'overall_threat_level' => 'LOW',
    'security_score' => 88,
    'today_risk_message' => 'Minimal Anomalies Detected',
    'current_mission_title' => 'Identify Phishing Vector #204',
    'mission_estimated_minutes' => 15,
    'mission_difficulty' => 'Medium',
    'mission_progress' => 0.45,
    'is_mission_completed' => false,
    'current_course_title' => 'Digital Forensics & Incident Response',
    'current_module_title' => 'Module 3 · Memory Artifact Analysis',
    'course_completion_percentage' => 0.68,
    'course_time_remaining' => '25 min left',
    'active_case_id' => 'case_101',
    'active_case_title' => 'USB Forensics Investigation',
    'active_case_type' => 'Memory & Disk Forensics',
    'evidence_count' => 12,
    'case_status' => 'IN PROGRESS',
    'completed_objectives' => 4,
    'total_objectives' => 7,
    'weekly_courses_completed' => 3,
    'weekly_cases_solved' => 8,
    'weekly_hours_practiced' => 14.5,
    'weekly_xp_earned' => 1250,
    'daily_xp_data' => [120, 240, 180, 310, 290, 420, 350],
    'achievements' => [
        [
            'id' => 'ach_1',
            'title' => 'First Responder',
            'description' => 'Completed your first live simulation drill',
            'icon_name' => 'shield',
            'xp_reward' => 100,
            'is_unlocked' => true,
            'progress' => 1.0
        ]
    ],
    'notifications' => [
        [
            'id' => 'notif_1',
            'title' => 'System Security Update',
            'message' => 'Threat database signatures updated v4.12',
            'timestamp' => '10m ago',
            'is_unread' => true,
            'type' => 'info'
        ]
    ],
    'recent_activities' => [
        [
            'id' => 'act_1',
            'title' => 'Analyzed USB Forensics Lab',
            'subtitle' => 'Investigation · #case_101',
            'timestamp' => '2h ago',
            'type' => 'investigation',
            'icon_name' => 'folder_open'
        ]
    ]
];

echo json_encode($response);
