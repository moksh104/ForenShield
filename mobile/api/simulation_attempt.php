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

$scenarioId = $_GET['scenario_id'] ?? null;
$attemptId = $_GET['attempt_id'] ?? null;

if (!$scenarioId && !$attemptId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing scenario_id or attempt_id parameter']);
    exit;
}

$db = getDb();

if ($attemptId) {
    $attStmt = $db->prepare("
        SELECT id, user_id, scenario_id, current_node_id, status, score, xp_earned,
               selected_actions, discovered_evidence_ids, state_flags,
               started_at, last_activity_at, completed_at
        FROM scenario_attempts
        WHERE id = :id AND user_id = :uid
    ");
    $attStmt->execute(['id' => $attemptId, 'uid' => $userId]);
} else {
    $attStmt = $db->prepare("
        SELECT id, user_id, scenario_id, current_node_id, status, score, xp_earned,
               selected_actions, discovered_evidence_ids, state_flags,
               started_at, last_activity_at, completed_at
        FROM scenario_attempts
        WHERE user_id = :uid AND scenario_id = :sid AND status = 'in_progress'
        ORDER BY started_at DESC
        LIMIT 1
    ");
    $attStmt->execute(['uid' => $userId, 'sid' => $scenarioId]);
}

$attempt = $attStmt->fetch(PDO::FETCH_ASSOC);

if (!$attempt) {
    echo json_encode([
        'success' => true,
        'has_active_attempt' => false,
        'attempt' => null
    ]);
    exit;
}

// Fetch scenario
$sStmt = $db->prepare("
    SELECT id, title, description, category, difficulty, duration_minutes,
           xp_reward, passing_score, entry_node_id, investigation_case_id,
           nodes
    FROM scenarios
    WHERE id = :id
");
$sStmt->execute(['id' => $attempt['scenario_id']]);
$scenario = $sStmt->fetch(PDO::FETCH_ASSOC);

$nodes = $scenario['nodes'] ? json_decode($scenario['nodes'], true) : [];
$currentNode = $nodes[$attempt['current_node_id']] ?? null;

// Resolve discovered evidence
$discoveredIds = is_string($attempt['discovered_evidence_ids']) 
    ? json_decode($attempt['discovered_evidence_ids'], true) 
    : ($attempt['discovered_evidence_ids'] ?? []);

$evidenceDetails = [];
if (!empty($discoveredIds)) {
    $inClause = implode(',', array_fill(0, count($discoveredIds), '?'));
    $evStmt = $db->prepare("SELECT id, case_id, title, evidence_type, content_text, metadata_map FROM evidence WHERE id IN ($inClause)");
    $evStmt->execute($discoveredIds);
    $evidenceDetails = $evStmt->fetchAll(PDO::FETCH_ASSOC);
}

$attempt['selected_actions'] = is_string($attempt['selected_actions']) 
    ? json_decode($attempt['selected_actions'], true) 
    : ($attempt['selected_actions'] ?? []);
$attempt['discovered_evidence_ids'] = $discoveredIds;
$attempt['state_flags'] = is_string($attempt['state_flags']) 
    ? json_decode($attempt['state_flags'], true) 
    : ($attempt['state_flags'] ?? (object)[]);

echo json_encode([
    'success' => true,
    'has_active_attempt' => true,
    'attempt' => $attempt,
    'currentNode' => $currentNode,
    'discoveredEvidence' => $evidenceDetails,
    'scenario' => [
        'id' => $scenario['id'],
        'title' => $scenario['title'],
        'category' => $scenario['category'],
        'difficulty' => $scenario['difficulty'],
        'estimatedMinutes' => (int)$scenario['duration_minutes'],
        'xpReward' => (int)$scenario['xp_reward'],
        'passingScore' => (int)$scenario['passing_score'],
        'investigationCaseId' => $scenario['investigation_case_id']
    ]
]);
