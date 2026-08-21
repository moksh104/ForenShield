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

$courseId = $_GET['id'] ?? null;
if (!$courseId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing course ID']);
    exit;
}

$db = getDb();
$stmt = $db->prepare("
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
WHERE c.id = :course_id
");
$stmt->execute(['user_id' => $userId ?? 0, 'course_id' => $courseId]);
$course = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$course) {
    http_response_code(404);
    echo json_encode(['error' => 'Course not found']);
    exit;
}

// Fetch Modules
$stmtModules = $db->prepare("SELECT id, title, description, module_order FROM course_modules WHERE course_id = :course_id ORDER BY module_order ASC");
$stmtModules->execute(['course_id' => $courseId]);
$modulesRaw = $stmtModules->fetchAll(PDO::FETCH_ASSOC);

$modules = [];
foreach ($modulesRaw as $mRow) {
    // Fetch Lessons for Module
    $stmtLessons = $db->prepare("
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
    WHERE l.module_id = :module_id
    ORDER BY l.lesson_order ASC
    ");
    $stmtLessons->execute(['user_id' => $userId ?? 0, 'module_id' => $mRow['id']]);
    $lessonsRaw = $stmtLessons->fetchAll(PDO::FETCH_ASSOC);
    
    $lessons = [];
    foreach ($lessonsRaw as $lRow) {
        $lessons[] = [
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
    }
    
    $modules[] = [
        'id' => $mRow['id'],
        'title' => $mRow['title'],
        'description' => $mRow['description'],
        'order' => (int)$mRow['module_order'],
        'lessons' => $lessons
    ];
}

$isEnrolled = isset($course['is_enrolled']) ? (bool)$course['is_enrolled'] : false;
$completionPercentage = isset($course['completion_percentage']) ? (float)$course['completion_percentage'] : 0.0;

$response = [
    'id' => $course['id'],
    'title' => $course['title'],
    'description' => $course['description'],
    'category' => $course['category'],
    'difficulty' => $course['difficulty'],
    'duration_minutes' => (int)$course['duration_minutes'],
    'instructor_name' => $course['instructor_name'],
    'thumbnail_url' => $course['thumbnail_url'] ?? '',
    'prerequisites' => $course['prerequisites'] ? json_decode($course['prerequisites'], true) : [],
    'learning_outcomes' => $course['learning_outcomes'] ? json_decode($course['learning_outcomes'], true) : [],
    'modules' => $modules,
    'is_enrolled' => $isEnrolled,
    'completion_percentage' => $completionPercentage,
    'total_xp' => (int)$course['total_xp']
];

echo json_encode($response);
