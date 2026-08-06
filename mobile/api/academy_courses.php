<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// Extract & Validate JWT if header present
$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $authorization = $headers['Authorization'];
} elseif (isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}

if ($authorization && preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    try {
        $decoded = JWT::decode($matches[1], new Key(JWT_SECRET, 'HS256'));
        $userId = $decoded->sub ?? null;
        if ($userId) {
            $db = getDb();
            $check = $db->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND type = 'academy'");
            $check->execute(['user_id' => $userId]);
            if ((int)$check->fetchColumn() === 0) {
                $stmt = $db->prepare("INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:user_id, '📚 New Course Available', 'Digital Forensics Fundamentals course is now unlocked! +500 XP available.', 'academy', FALSE)");
                $stmt->execute(['user_id' => $userId]);
            }
        }
    } catch (Exception $e) {
        // Ignore JWT exception on optional check
    }
}

$courses = [
    [
        'id' => 'crs_1',
        'title' => 'Digital Forensics Fundamentals',
        'description' => 'Learn the basics of digital evidence, acquisition, and analysis techniques.',
        'category' => 'Digital Forensics',
        'difficulty' => 'Beginner',
        'duration_minutes' => 150,
        'instructor_name' => 'Dr. Alex Vance',
        'thumbnail_url' => '',
        'prerequisites' => ['Basic OS Concepts', 'Command Line Proficiency'],
        'learning_outcomes' => [
            'Acquire disk and memory evidence safely',
            'Identify file system artifacts',
            'Analyze browser & system logs'
        ],
        'modules' => [],
        'is_enrolled' => true,
        'completion_percentage' => 0.75,
        'total_xp' => 500
    ],
    [
        'id' => 'crs_2',
        'title' => 'Malware Analysis Essentials',
        'description' => 'Understand malware behavior, static & dynamic analysis and reverse engineering.',
        'category' => 'Malware Analysis',
        'difficulty' => 'Intermediate',
        'duration_minutes' => 190,
        'instructor_name' => 'Elena Rostova',
        'thumbnail_url' => '',
        'prerequisites' => ['Assembly Basics', 'C Programming'],
        'learning_outcomes' => [
            'Static PE header analysis',
            'Dynamic sandbox behavior tracking',
            'Decompiling binaries with Ghidra'
        ],
        'modules' => [],
        'is_enrolled' => true,
        'completion_percentage' => 0.45,
        'total_xp' => 650
    ]
];

echo json_encode($courses);
