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

$scenarioId = $data['scenario_id'] ?? null;

if (!$scenarioId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing scenario_id']);
    exit;
}

$db = getDb();

// Verify scenario exists and get XP reward
$stmt = $db->prepare("SELECT xp_reward FROM scenarios WHERE id = :id");
$stmt->execute(['id' => $scenarioId]);
$scenario = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$scenario) {
    http_response_code(404);
    echo json_encode(['error' => 'Scenario not found']);
    exit;
}

// Check if user already completed it
$checkStmt = $db->prepare("SELECT is_completed FROM user_scenario_progress WHERE user_id = :user_id AND scenario_id = :scenario_id");
$checkStmt->execute(['user_id' => $userId, 'scenario_id' => $scenarioId]);
$progress = $checkStmt->fetch(PDO::FETCH_ASSOC);

if ($progress && $progress['is_completed']) {
    // Already completed, don't award XP again
    echo json_encode(['success' => true, 'message' => 'Scenario already completed. No additional XP awarded.', 'xp_awarded' => 0]);
    exit;
}

// Mark as completed
$db->prepare("
    INSERT INTO user_scenario_progress (user_id, scenario_id, is_completed, completed_at)
    VALUES (:user_id, :scenario_id, TRUE, CURRENT_TIMESTAMP)
    ON CONFLICT (user_id, scenario_id) DO UPDATE SET
    is_completed = TRUE,
    completed_at = CURRENT_TIMESTAMP
")->execute([
    'user_id' => $userId,
    'scenario_id' => $scenarioId
]);

$xpReward = (int)$scenario['xp_reward'];

if ($xpReward > 0) {
    // Award XP
    $db->prepare("
        INSERT INTO xp_transactions (user_id, action, xp_earned, reason, reference_id, event_type, source_module)
        VALUES (:user_id, 'complete_simulation', :xp, 'Completed simulation scenario', :ref, 'simulation', 'Simulation Lab')
    ")->execute([
        'user_id' => $userId,
        'xp' => $xpReward,
        'ref' => $scenarioId
    ]);
    
    $db->prepare("
        INSERT INTO leaderboard_stats (user_id, total_xp)
        VALUES (:user_id, :xp)
        ON CONFLICT (user_id) DO UPDATE SET
        total_xp = leaderboard_stats.total_xp + :xp,
        last_updated = CURRENT_TIMESTAMP
    ")->execute([
        'user_id' => $userId,
        'xp' => $xpReward
    ]);
}

echo json_encode(['success' => true, 'message' => 'Scenario completed successfully.', 'xp_awarded' => $xpReward]);
