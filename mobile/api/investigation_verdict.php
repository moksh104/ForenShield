<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
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
$index = $data['selected_verdict_index'] ?? 0;

if (!$caseId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing case_id']);
    exit;
}

$db = getDb();
$stmt = $db->prepare("SELECT id, correct_option_index, xp_reward FROM verdicts WHERE case_id = :case_id LIMIT 1");
$stmt->execute(['case_id' => $caseId]);
$verdict = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$verdict) {
    http_response_code(404);
    echo json_encode(['error' => 'Verdict not found']);
    exit;
}

$score = 0;
$correct = false;
if ((int)$verdict['correct_option_index'] === (int)$index) {
    $score = 100;
    $correct = true;
} else {
    $score = 40;
}

// Update user_case_progress
$progress = $correct ? 1.0 : 0.8;
$status = $correct ? 'Completed' : 'Failed';
$isSolved = $correct;

$db->prepare("
    INSERT INTO user_case_progress (user_id, case_id, progress, status, is_solved, completed_at)
    VALUES (:user_id, :case_id, :progress, :status, :is_solved, CURRENT_TIMESTAMP)
    ON CONFLICT (user_id, case_id) DO UPDATE SET
    progress = :progress,
    status = :status,
    is_solved = :is_solved,
    completed_at = CURRENT_TIMESTAMP
")->execute([
    'user_id' => $userId,
    'case_id' => $caseId,
    'progress' => $progress,
    'status' => $status,
    'is_solved' => $isSolved ? 'true' : 'false'
]);

// Give XP if correct
if ($correct && (int)$verdict['xp_reward'] > 0) {
    // Only give XP if they haven't solved it before (to prevent infinite XP loop)
    // Actually, ON CONFLICT update might overwrite, but we should ensure XP transactions only happen once.
    // For now, we will insert a record into xp_transactions if it doesn't already exist for this verdict.
    
    $check = $db->prepare("SELECT COUNT(*) FROM xp_transactions WHERE user_id = :user_id AND reference_id = :reference_id AND action = 'solve_case'");
    $check->execute(['user_id' => $userId, 'reference_id' => $caseId]);
    if ((int)$check->fetchColumn() === 0) {
        $db->prepare("
            INSERT INTO xp_transactions (user_id, action, xp_earned, reason, reference_id, event_type, source_module)
            VALUES (:user_id, 'solve_case', :xp, 'Solved case verdict', :ref, 'investigation', 'Investigation Lab')
        ")->execute([
            'user_id' => $userId,
            'xp' => (int)$verdict['xp_reward'],
            'ref' => $caseId
        ]);
        
        $db->prepare("
            INSERT INTO leaderboard_stats (user_id, investigations_completed, total_xp)
            VALUES (:user_id, 1, :xp)
            ON CONFLICT (user_id) DO UPDATE SET
            investigations_completed = leaderboard_stats.investigations_completed + 1,
            total_xp = leaderboard_stats.total_xp + :xp,
            last_updated = CURRENT_TIMESTAMP
        ")->execute([
            'user_id' => $userId,
            'xp' => (int)$verdict['xp_reward']
        ]);
    }
}

echo json_encode(['score' => $score]);
