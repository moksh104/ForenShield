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

$userId = null;
if ($authorization && preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    try {
        $decoded = JWT::decode($matches[1], new Key(JWT_SECRET, 'HS256'));
        $userId = $decoded->sub ?? null;
    } catch (Exception $e) {}
}

$db = getDb();

if ($userId) {
    try {
        $check = $db->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND type = 'investigation'");
        $check->execute(['user_id' => $userId]);
        if ((int)$check->fetchColumn() === 0) {
            $stmt = $db->prepare("INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:user_id, '🕵 New Case Assigned', 'USB Forensics Investigation case #101 assigned to your queue.', 'investigation', FALSE)");
            $stmt->execute(['user_id' => $userId]);
        }
    } catch (Exception $e) {}
}

$sql = "
SELECT 
    c.id, 
    c.case_code, 
    c.title, 
    c.description, 
    c.priority, 
    c.difficulty, 
    c.status as case_status, 
    c.assigned_date, 
    c.notes, 
    c.objectives, 
    ucp.progress,
    ucp.is_solved,
    ucp.status as user_status
FROM cases c
LEFT JOIN user_case_progress ucp ON c.id = ucp.case_id AND ucp.user_id = :user_id
";

$stmt = $db->prepare($sql);
$stmt->execute(['user_id' => $userId ?? 0]);
$casesRaw = $stmt->fetchAll(PDO::FETCH_ASSOC);

$cases = [];
foreach ($casesRaw as $row) {
    // Preserve DB objectives array exactly.
    $objectives = $row['objectives'] ? json_decode($row['objectives'], true) : [];

    // 'status' goes to Case status (Global case state)
    // 'progress' goes to user_case_progress.progress (User specific)
    $progress = isset($row['progress']) ? (float)$row['progress'] : 0.0;
    
    // We return empty arrays for evidenceList, timeline, suspects, and null for verdict 
    // to save bandwidth on list endpoints as requested.
    $cases[] = [
        'id' => $row['id'],
        'case_code' => $row['case_code'],
        'title' => $row['title'],
        'description' => $row['description'],
        'priority' => $row['priority'],
        'difficulty' => $row['difficulty'],
        'status' => $row['case_status'] ?? 'Open',
        'assigned_date' => $row['assigned_date'] ?? '',
        'progress' => $progress,
        'evidence_list' => [],
        'timeline' => [],
        'suspects' => [],
        'notes' => $row['notes'] ?? '',
        'objectives' => $objectives,
        'verdict' => null
    ];
}

echo json_encode($cases);
