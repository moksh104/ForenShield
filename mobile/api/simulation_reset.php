<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

header('Content-Type: application/json');

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

if (!$userId) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$scenarioId = $data['scenario_id'] ?? null;
$attemptId = $data['attempt_id'] ?? null;

if (!$scenarioId && !$attemptId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing scenario_id or attempt_id']);
    exit;
}

$db = getDb();

if ($attemptId) {
    $stmt = $db->prepare("
        UPDATE scenario_attempts
        SET status = 'abandoned', last_activity_at = CURRENT_TIMESTAMP
        WHERE id = :id AND user_id = :uid
    ");
    $stmt->execute(['id' => $attemptId, 'uid' => $userId]);
} else {
    $stmt = $db->prepare("
        UPDATE scenario_attempts
        SET status = 'abandoned', last_activity_at = CURRENT_TIMESTAMP
        WHERE user_id = :uid AND scenario_id = :sid AND status = 'in_progress'
    ");
    $stmt->execute(['uid' => $userId, 'sid' => $scenarioId]);
}

echo json_encode([
    'success' => true,
    'message' => 'Previous attempt abandoned. Ready to start fresh.'
]);
