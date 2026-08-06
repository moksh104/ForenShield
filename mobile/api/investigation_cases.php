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
            $check = $db->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND type = 'investigation'");
            $check->execute(['user_id' => $userId]);
            if ((int)$check->fetchColumn() === 0) {
                $stmt = $db->prepare("INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:user_id, '🕵 New Case Assigned', 'USB Forensics Investigation case #101 assigned to your queue.', 'investigation', FALSE)");
                $stmt->execute(['user_id' => $userId]);
            }
        }
    } catch (Exception $e) {
        // Ignore JWT exception on optional check
    }
}

$cases = [
    [
        'id' => 'case_101',
        'case_code' => 'Case #01',
        'title' => 'USB Forensics Investigation',
        'description' => 'A suspicious USB drive was found. Analyze the data and find the evidence.',
        'priority' => 'Medium',
        'difficulty' => 'Beginner',
        'status' => 'In Progress',
        'assigned_date' => '2026-04-24',
        'progress' => 0.60,
        'evidence_list' => [
            [
                'id' => 'ev_001',
                'title' => 'Suspicious USB Dump Log',
                'type' => 'log',
                'content_text' => '2026-04-24 14:02:11 UTC - USB Mass Storage Device Attached: SanDisk Ultra 3.0 (SN: 99482012)',
                'metadata_map' => [
                    'Source' => 'Windows Event Log (System)',
                    'Event ID' => '20001',
                    'User' => 'SYSTEM / Administrator',
                    'Computer' => 'FINANCE-PC01'
                ],
                'is_reviewed' => true,
                'timestamp' => '2026-04-24 14:02 UTC'
            ]
        ],
        'timeline' => [
            [
                'id' => 'tl_1',
                'title' => 'USB Drive Attached',
                'description' => 'Unidentified USB device inserted into workstation.',
                'timestamp' => '14:00 UTC',
                'category' => 'Physical Access',
                'severity' => 'Medium',
                'is_expanded' => true
            ]
        ],
        'suspects' => [],
        'notes' => 'USB drive contains hidden partition with payload.',
        'objectives' => [
            'Examine USB disk image partitions',
            'Extract deleted files from FAT32 volume',
            'Identify malicious executable'
        ],
        'verdict' => [
            'id' => 'v_101',
            'case_id' => 'case_101',
            'summary_text' => 'Identify the primary malware vector found on the USB drive.',
            'options' => [
                'Autorun.inf launching hidden binary',
                'Corrupted partition table',
                'Normal documents only'
            ],
            'correct_option_index' => 0,
            'explanation' => 'The USB drive contained an Autorun.inf file configured to silently execute a hidden PE binary.'
        ]
    ]
];

echo json_encode($cases);
