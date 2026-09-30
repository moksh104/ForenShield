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

// Order: 4 production scenarios first, then any legacy ones
$sql = "
SELECT 
    s.id, 
    s.title, 
    s.description, 
    s.category, 
    s.difficulty, 
    s.duration_minutes, 
    s.objectives, 
    s.initial_state, 
    s.xp_reward,
    s.entry_node_id,
    s.passing_score,
    s.investigation_case_id,
    usp.is_completed,
    sa.id AS active_attempt_id,
    sa.current_node_id AS active_node_id,
    sa.score AS active_score,
    sa.status AS active_status
FROM scenarios s
LEFT JOIN user_scenario_progress usp ON s.id = usp.scenario_id AND usp.user_id = :user_id
LEFT JOIN scenario_attempts sa ON s.id = sa.scenario_id AND sa.user_id = :user_id AND sa.status = 'in_progress'
ORDER BY 
    CASE s.id
        WHEN 'phishing-incident' THEN 1
        WHEN 'qr-payment-scam' THEN 2
        WHEN 'account-takeover' THEN 3
        WHEN 'fake-online-store' THEN 4
        ELSE 5
    END,
    s.id
";

$stmt = $db->prepare($sql);
$stmt->execute(['user_id' => $userId ?? 0]);
$scenariosRaw = $stmt->fetchAll(PDO::FETCH_ASSOC);

$scenarios = [];
foreach ($scenariosRaw as $row) {
    $activeAttempt = null;
    if (!empty($row['active_attempt_id'])) {
        $activeAttempt = [
            'attemptId' => $row['active_attempt_id'],
            'currentNodeId' => $row['active_node_id'],
            'score' => (int)$row['active_score'],
            'status' => $row['active_status']
        ];
    }

    $scenarios[] = [
        'id' => $row['id'],
        'title' => $row['title'],
        'description' => $row['description'],
        'category' => $row['category'],
        'difficulty' => $row['difficulty'],
        'estimatedMinutes' => (int)($row['duration_minutes'] ?? 10),
        'xpReward' => (int)($row['xp_reward'] ?? 100),
        'passingScore' => (int)($row['passing_score'] ?? 70),
        'entryNodeId' => $row['entry_node_id'] ?? 'node_start',
        'investigationCaseId' => $row['investigation_case_id'],
        'initialTerminalHistory' => $row['initial_state'] ? json_decode($row['initial_state'], true) : [],
        'objectives' => $row['objectives'] ? json_decode($row['objectives'], true) : [],
        'isCompleted' => isset($row['is_completed']) ? (bool)$row['is_completed'] : false,
        'activeAttempt' => $activeAttempt
    ];
}

header('Content-Type: application/json');
echo json_encode($scenarios);
