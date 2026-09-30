<?php
/**
 * ForenShield — Investigation Progress Endpoint
 *
 * Tracks user progress on investigation cases.
 * - action=start: Creates an in-progress record (idempotent — won't overwrite completed cases).
 */
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

if (!$userId) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$data   = json_decode(file_get_contents('php://input'), true);
$caseId = $data['case_id'] ?? null;
$action = $data['action'] ?? 'start';

if (!$caseId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing case_id']);
    exit;
}

try {
    $db = getDb();

    if ($action === 'start') {
        // Insert only if no existing record — DO NOT overwrite completed/solved progress.
        $db->prepare("
            INSERT INTO user_case_progress (user_id, case_id, progress, status, is_solved)
            VALUES (:user_id, :case_id, 0.1, 'In Progress', false)
            ON CONFLICT (user_id, case_id) DO NOTHING
        ")->execute([
            'user_id' => $userId,
            'case_id' => $caseId,
        ]);

        echo json_encode(['status' => 'ok', 'action' => 'started']);
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Unknown action']);
    }

} catch (Exception $e) {
    error_log('[investigation_progress] Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Internal server error']);
}
