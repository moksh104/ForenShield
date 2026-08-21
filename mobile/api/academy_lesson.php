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

$lessonId = $_GET['id'] ?? null;
if (!$lessonId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing lesson ID']);
    exit;
}

$db = getDb();
$stmt = $db->prepare("
SELECT 
    l.id, 
    l.title, 
    l.duration_minutes, 
    l.content_type, 
    l.content_text, 
    l.image_url, 
    l.code_snippet, 
    l.code_language, 
    l.checklist, 
    l.lesson_order, 
    l.quiz_id,
    ulp.is_completed
FROM lessons l
LEFT JOIN user_lesson_progress ulp ON l.id = ulp.lesson_id AND ulp.user_id = :user_id
WHERE l.id = :lesson_id
");
$stmt->execute(['user_id' => $userId ?? 0, 'lesson_id' => $lessonId]);
$lRow = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$lRow) {
    http_response_code(404);
    echo json_encode(['error' => 'Lesson not found']);
    exit;
}

$lesson = [
    'id' => $lRow['id'],
    'title' => $lRow['title'],
    'duration_minutes' => (int)$lRow['duration_minutes'],
    'content_type' => $lRow['content_type'],
    'content_text' => $lRow['content_text'],
    'image_url' => $lRow['image_url'] ?? '',
    'code_snippet' => $lRow['code_snippet'] ?? '',
    'code_language' => $lRow['code_language'] ?? '',
    'checklist' => $lRow['checklist'] ? json_decode($lRow['checklist'], true) : [],
    'is_completed' => isset($lRow['is_completed']) && $lRow['is_completed'] ? true : false,
    'order' => (int)$lRow['lesson_order'],
    'quiz_id' => $lRow['quiz_id']
];

echo json_encode($lesson);
