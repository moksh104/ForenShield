<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/xp_service.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$data = json_decode(file_get_contents('php://input'), true);

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

$caseId = $data['case_id'] ?? null;
$index  = isset($data['selected_verdict_index']) ? (int)$data['selected_verdict_index'] : null;

if (!$caseId || $index === null) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing case_id or selected_verdict_index']);
    exit;
}

try {
    $db = getDb();

    // 1. Fetch the verdict answer key from the database
    $stmt = $db->prepare("SELECT id, correct_option_index, xp_reward FROM verdicts WHERE case_id = :case_id LIMIT 1");
    $stmt->execute(['case_id' => $caseId]);
    $verdict = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$verdict) {
        http_response_code(404);
        echo json_encode(['error' => 'No verdict found for this case']);
        exit;
    }

    // 2. Server-side evaluation — NEVER trust client-supplied score
    $isCorrect = ((int)$verdict['correct_option_index'] === $index);
    $score     = $isCorrect ? 100 : 40;
    $progress  = $isCorrect ? 1.0 : 0.8;
    $status    = $isCorrect ? 'Completed' : 'Failed';

    // 3. Persist investigation progress (idempotent upsert)
    $db->prepare("
        INSERT INTO user_case_progress (user_id, case_id, progress, status, is_solved, completed_at)
        VALUES (:user_id, :case_id, :progress, :status, :is_solved, CURRENT_TIMESTAMP)
        ON CONFLICT (user_id, case_id) DO UPDATE SET
            progress     = EXCLUDED.progress,
            status       = EXCLUDED.status,
            is_solved    = EXCLUDED.is_solved,
            completed_at = EXCLUDED.completed_at
    ")->execute([
        'user_id'   => $userId,
        'case_id'   => $caseId,
        'progress'  => $progress,
        'status'    => $status,
        'is_solved' => $isCorrect ? 'true' : 'false',
    ]);

    // 4. Award XP via centralised service (handles idempotency, leaderboard, achievements)
    $xpResult = ['duplicate' => false, 'xp_added' => 0, 'bonus_xp' => 0, 'new_achievements' => []];
    if ($isCorrect && (int)$verdict['xp_reward'] > 0) {
        $xpResult = awardXp(
            $db,
            (int)$userId,
            (int)$verdict['xp_reward'],
            'Solved investigation case: ' . $caseId,
            'investigation_completed',  // event_type — triggers cases_completed increment
            'Investigation Lab',
            $caseId                     // refId — ensures no duplicate XP for the same case
        );
    }

    echo json_encode([
        'score'            => $score,
        'is_correct'       => $isCorrect,
        'xp_earned'        => $xpResult['xp_added'],
        'bonus_xp'         => $xpResult['bonus_xp'],
        'was_duplicate'    => $xpResult['duplicate'],
        'new_achievements' => $xpResult['new_achievements'],
    ]);

} catch (Exception $e) {
    error_log('[investigation_verdict] Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Internal server error while processing verdict']);
}
