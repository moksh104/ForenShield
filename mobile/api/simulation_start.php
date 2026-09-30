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
$forceNew = !empty($data['force_new']);

if (!$scenarioId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing scenario_id']);
    exit;
}

$db = getDb();

// 1. Fetch scenario
$sStmt = $db->prepare("
    SELECT id, title, description, category, difficulty, duration_minutes,
           xp_reward, passing_score, entry_node_id, investigation_case_id,
           objectives, initial_state, nodes
    FROM scenarios
    WHERE id = :id
");
$sStmt->execute(['id' => $scenarioId]);
$scenario = $sStmt->fetch(PDO::FETCH_ASSOC);

if (!$scenario) {
    http_response_code(404);
    echo json_encode(['error' => 'Scenario not found']);
    exit;
}

$nodes = $scenario['nodes'] ? json_decode($scenario['nodes'], true) : [];
$entryNodeId = $scenario['entry_node_id'] ?: 'node_start';

// If forceNew requested, abandon any existing in-progress attempts
if ($forceNew) {
    $db->prepare("
        UPDATE scenario_attempts
        SET status = 'abandoned', last_activity_at = CURRENT_TIMESTAMP
        WHERE user_id = :uid AND scenario_id = :sid AND status = 'in_progress'
    ")->execute(['uid' => $userId, 'sid' => $scenarioId]);
}

// 2. Check for existing in-progress attempt to resume
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
$attempt = $attStmt->fetch(PDO::FETCH_ASSOC);

$isResumed = false;

if ($attempt) {
    $isResumed = true;
    $currentNodeId = $attempt['current_node_id'];
} else {
    // 3. Create new attempt
    $attemptId = 'att_' . bin2hex(random_bytes(12));
    $currentNodeId = $entryNodeId;
    
    // Check if initial entry node unlocks any evidence automatically
    $initialEvidence = [];
    if (isset($nodes[$currentNodeId]['evidence_unlocked_on_enter'])) {
        $initialEvidence = $nodes[$currentNodeId]['evidence_unlocked_on_enter'];
    }

    $insStmt = $db->prepare("
        INSERT INTO scenario_attempts (
            id, user_id, scenario_id, current_node_id, status, score, xp_earned,
            selected_actions, discovered_evidence_ids, state_flags, started_at, last_activity_at
        ) VALUES (
            :id, :uid, :sid, :node_id, 'in_progress', 100, 0,
            '[]'::jsonb, :ev_ids::jsonb, '{}'::jsonb, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        )
        RETURNING *
    ");
    $insStmt->execute([
        'id' => $attemptId,
        'uid' => $userId,
        'sid' => $scenarioId,
        'node_id' => $currentNodeId,
        'ev_ids' => json_encode($initialEvidence)
    ]);
    $attempt = $insStmt->fetch(PDO::FETCH_ASSOC);
}

// Resolve current node data
$currentNode = $nodes[$currentNodeId] ?? null;
if (!$currentNode && !empty($nodes)) {
    // Fallback to first available node if entryNodeId was misnamed
    $firstKey = array_key_first($nodes);
    $currentNode = $nodes[$firstKey];
    $currentNodeId = $firstKey;
}

// Resolve discovered evidence details from evidence table
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

// Decode JSON fields in attempt for response
$attempt['selected_actions'] = is_string($attempt['selected_actions']) 
    ? json_decode($attempt['selected_actions'], true) 
    : ($attempt['selected_actions'] ?? []);
$attempt['discovered_evidence_ids'] = $discoveredIds;
$attempt['state_flags'] = is_string($attempt['state_flags']) 
    ? json_decode($attempt['state_flags'], true) 
    : ($attempt['state_flags'] ?? (object)[]);

echo json_encode([
    'success' => true,
    'resumed' => $isResumed,
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
