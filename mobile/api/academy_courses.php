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
    } catch (Exception $e) {
    }
}

$db = getDb();

if ($userId) {
    try {
        $check = $db->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND type = 'academy'");
        $check->execute(['user_id' => $userId]);
        if ((int)$check->fetchColumn() === 0) {
            $stmt = $db->prepare("INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:user_id, '📚 New Course Available', 'Digital Forensics Fundamentals course is now unlocked! +500 XP available.', 'academy', FALSE)");
            $stmt->execute(['user_id' => $userId]);
        }
    } catch (Exception $e) {}
}

$sql = "
SELECT 
    c.id, 
    c.title, 
    c.description, 
    c.category, 
    c.difficulty, 
    c.duration_minutes, 
    c.instructor_name, 
    c.thumbnail_url, 
    c.prerequisites, 
    c.learning_outcomes, 
    c.total_xp,
    ucp.is_enrolled,
    ucp.completion_percentage
FROM courses c
LEFT JOIN user_course_progress ucp ON c.id = ucp.course_id AND ucp.user_id = :user_id
";

$stmt = $db->prepare($sql);
$stmt->execute(['user_id' => $userId ?? 0]);
$coursesRaw = $stmt->fetchAll(PDO::FETCH_ASSOC);

$courses = [];
foreach ($coursesRaw as $row) {
    // Determine is_enrolled and completion_percentage explicitly 
    // to distinguish "not enrolled" from "enrolled at 0%"
    // If ucp.is_enrolled is null, there is no progress record => not enrolled
    $isEnrolled = isset($row['is_enrolled']) ? (bool)$row['is_enrolled'] : false;
    $completionPercentage = isset($row['completion_percentage']) ? (float)$row['completion_percentage'] : 0.0;

    $courses[] = [
        'id' => $row['id'],
        'title' => $row['title'],
        'description' => $row['description'],
        'category' => $row['category'],
        'difficulty' => $row['difficulty'],
        'duration_minutes' => (int)$row['duration_minutes'],
        'instructor_name' => $row['instructor_name'],
        'thumbnail_url' => $row['thumbnail_url'] ?? '',
        'prerequisites' => $row['prerequisites'] ? json_decode($row['prerequisites'], true) : [],
        'learning_outcomes' => $row['learning_outcomes'] ? json_decode($row['learning_outcomes'], true) : [],
        'modules' => [],
        'is_enrolled' => $isEnrolled,
        'completion_percentage' => $completionPercentage,
        'total_xp' => (int)$row['total_xp']
    ];
}

echo json_encode($courses);
