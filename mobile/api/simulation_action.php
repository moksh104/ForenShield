<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/xp_service.php';
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
$attemptId = $data['attempt_id'] ?? null;
$actionId = $data['action_id'] ?? null;

if (!$attemptId || !$actionId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing attempt_id or action_id']);
    exit;
}

$db = getDb();

// 1. Fetch and validate attempt ownership and status
$attStmt = $db->prepare("
    SELECT id, user_id, scenario_id, current_node_id, status, score, xp_earned,
           selected_actions, discovered_evidence_ids, state_flags,
           started_at, last_activity_at, completed_at
    FROM scenario_attempts
    WHERE id = :id AND user_id = :uid
");
$attStmt->execute(['id' => $attemptId, 'uid' => $userId]);
$attempt = $attStmt->fetch(PDO::FETCH_ASSOC);

if (!$attempt) {
    http_response_code(404);
    echo json_encode(['error' => 'Simulation attempt not found']);
    exit;
}

if ($attempt['status'] !== 'in_progress') {
    http_response_code(400);
    echo json_encode(['error' => "Attempt is already {$attempt['status']}. Cannot execute further actions."]);
    exit;
}

// 2. Fetch scenario and graph
$sStmt = $db->prepare("
    SELECT id, title, description, category, difficulty, duration_minutes,
           xp_reward, passing_score, entry_node_id, investigation_case_id,
           nodes
    FROM scenarios
    WHERE id = :id
");
$sStmt->execute(['id' => $attempt['scenario_id']]);
$scenario = $sStmt->fetch(PDO::FETCH_ASSOC);

if (!$scenario) {
    http_response_code(404);
    echo json_encode(['error' => 'Scenario not found']);
    exit;
}

$nodes = $scenario['nodes'] ? json_decode($scenario['nodes'], true) : [];
$currentNodeId = $attempt['current_node_id'];
$currentNode = $nodes[$currentNodeId] ?? null;

if (!$currentNode) {
    http_response_code(500);
    echo json_encode(['error' => "Current node '{$currentNodeId}' not found in scenario graph."]);
    exit;
}

// 3. SERVER AUTHORITATIVE ACTION VALIDATION:
// Verify the action submitted by client actually exists in current node's available actions!
$availableActions = $currentNode['available_actions'] ?? [];
$selectedAction = null;
foreach ($availableActions as $act) {
    if ($act['id'] === $actionId) {
        $selectedAction = $act;
        break;
    }
}

if (!$selectedAction) {
    http_response_code(400);
    echo json_encode([
        'error' => "Invalid action '{$actionId}' for the current simulation state."
    ]);
    exit;
}

// 4. Decode attempt state
$selectedActions = is_string($attempt['selected_actions']) 
    ? json_decode($attempt['selected_actions'], true) 
    : ($attempt['selected_actions'] ?? []);

$discoveredEvidence = is_string($attempt['discovered_evidence_ids']) 
    ? json_decode($attempt['discovered_evidence_ids'], true) 
    : ($attempt['discovered_evidence_ids'] ?? []);

$stateFlags = is_string($attempt['state_flags']) 
    ? json_decode($attempt['state_flags'], true) 
    : ($attempt['state_flags'] ?? []);

$currentScore = (int)$attempt['score'];

// 5. Apply Action Effects
$scoreDelta = (int)($selectedAction['score_delta'] ?? 0);
$newScore = max(0, min(100, $currentScore + $scoreDelta));

// Update state flags
if (!empty($selectedAction['state_flags_set'])) {
    foreach ($selectedAction['state_flags_set'] as $k => $v) {
        $stateFlags[$k] = $v;
    }
}

// Unlock evidence
$newlyUnlockedEvidenceIds = [];
if (!empty($selectedAction['unlocks_evidence_ids'])) {
    foreach ($selectedAction['unlocks_evidence_ids'] as $evId) {
        if (!in_array($evId, $discoveredEvidence)) {
            $discoveredEvidence[] = $evId;
            $newlyUnlockedEvidenceIds[] = $evId;
        }
    }
}

// Determine next node (support conditional branching if configured)
$nextNodeId = $selectedAction['next_node_id'];
if (!empty($selectedAction['conditional_next_nodes'])) {
    foreach ($selectedAction['conditional_next_nodes'] as $cond) {
        $flag = $cond['condition_flag'] ?? null;
        if ($flag && !empty($stateFlags[$flag])) {
            $nextNodeId = $cond['next_node_id'];
            break;
        }
    }
}

$nextNode = $nodes[$nextNodeId] ?? null;
if (!$nextNode) {
    http_response_code(500);
    echo json_encode(['error' => "Target node '{$nextNodeId}' does not exist in scenario graph."]);
    exit;
}

// Check if entering next node unlocks any additional evidence
if (!empty($nextNode['evidence_unlocked_on_enter'])) {
    foreach ($nextNode['evidence_unlocked_on_enter'] as $evId) {
        if (!in_array($evId, $discoveredEvidence)) {
            $discoveredEvidence[] = $evId;
            $newlyUnlockedEvidenceIds[] = $evId;
        }
    }
}

// Record action in history
$actionRecord = [
    'node_id' => $currentNodeId,
    'node_title' => $currentNode['title'],
    'action_id' => $selectedAction['id'],
    'action_label' => $selectedAction['label'],
    'action_type' => $selectedAction['action_type'] ?? 'investigate',
    'safety' => $selectedAction['safety'] ?? 'safe',
    'score_delta' => $scoreDelta,
    'consequence' => $selectedAction['consequence_summary'] ?? '',
    'evidence_unlocked' => $newlyUnlockedEvidenceIds,
    'timestamp' => date('c')
];
$selectedActions[] = $actionRecord;

// 6. Check Terminal State (Resolution or Failure)
$isTerminal = !empty($nextNode['is_terminal']);
$status = 'in_progress';
$isSuccess = false;
$xpAwarded = 0;
$passingScore = (int)($scenario['passing_score'] ?? 70);
$completedAt = null;
$investigationHandoff = null;

if ($isTerminal) {
    $completedAt = date('Y-m-d H:i:s');
    if ($nextNode['type'] === 'resolution') {
        if ($newScore >= $passingScore) {
            $status = 'completed';
            $isSuccess = true;

            // Idempotent XP awarding via xp_service.php
            // Check if scenario was already completed previously by this user
            $checkComp = $db->prepare("
                SELECT is_completed FROM user_scenario_progress
                WHERE user_id = :uid AND scenario_id = :sid
            ");
            $checkComp->execute(['uid' => $userId, 'sid' => $scenario['id']]);
            $compRow = $checkComp->fetch(PDO::FETCH_ASSOC);
            $alreadyCompleted = ($compRow && $compRow['is_completed']);

            if (!$alreadyCompleted) {
                $xpReward = (int)($scenario['xp_reward'] ?? 100);
                if ($xpReward > 0) {
                    $xpRes = awardXp(
                        $db,
                        $userId,
                        $xpReward,
                        "Completed simulation: " . $scenario['title'],
                        'simulation',
                        'Simulation Lab',
                        $scenario['id']
                    );
                    $xpAwarded = $xpRes['duplicate'] ? 0 : $xpReward;
                }

                // Mark user_scenario_progress
                $db->prepare("
                    INSERT INTO user_scenario_progress (user_id, scenario_id, is_completed, completed_at)
                    VALUES (:uid, :sid, TRUE, CURRENT_TIMESTAMP)
                    ON CONFLICT (user_id, scenario_id) DO UPDATE SET
                    is_completed = TRUE,
                    completed_at = CURRENT_TIMESTAMP
                ")->execute(['uid' => $userId, 'sid' => $scenario['id']]);
            }
        } else {
            // Reached resolution node but score below passing threshold
            $status = 'failed';
            $isSuccess = false;
        }
    } else {
        // type === 'failure'
        $status = 'failed';
        $isSuccess = false;
    }

    // Build Investigation Handoff (Step 14)
    $caseId = $scenario['investigation_case_id'] ?? null;
    $caseTitle = null;
    if ($caseId) {
        $cStmt = $db->prepare("SELECT title FROM cases WHERE id = :cid");
        $cStmt->execute(['cid' => $caseId]);
        $cRow = $cStmt->fetch(PDO::FETCH_ASSOC);
        if ($cRow) $caseTitle = $cRow['title'];
    }

    $investigationHandoff = [
        'originating_simulation_id' => $scenario['id'],
        'originating_simulation_title' => $scenario['title'],
        'case_id' => $caseId,
        'case_title' => $caseTitle,
        'discovered_evidence_ids' => $discoveredEvidence,
        'final_score' => $newScore,
        'status' => $status,
        'summary' => $nextNode['narrative'],
        'completed_at' => $completedAt
    ];
}

// 7. Persist Attempt Update to Database
$updStmt = $db->prepare("
    UPDATE scenario_attempts
    SET current_node_id = :node_id,
        status = :status,
        score = :score,
        xp_earned = xp_earned + :xp_add,
        selected_actions = :actions::jsonb,
        discovered_evidence_ids = :ev_ids::jsonb,
        state_flags = :flags::jsonb,
        last_activity_at = CURRENT_TIMESTAMP,
        completed_at = :comp_at
    WHERE id = :id AND user_id = :uid
");
$updStmt->execute([
    'node_id' => $nextNodeId,
    'status' => $status,
    'score' => $newScore,
    'xp_add' => $xpAwarded,
    'actions' => json_encode($selectedActions),
    'ev_ids' => json_encode($discoveredEvidence),
    'flags' => json_encode($stateFlags),
    'comp_at' => $completedAt,
    'id' => $attemptId,
    'uid' => $userId
]);

// Fetch details for newly unlocked evidence
$newEvidenceDetails = [];
if (!empty($newlyUnlockedEvidenceIds)) {
    $inClause = implode(',', array_fill(0, count($newlyUnlockedEvidenceIds), '?'));
    $evStmt = $db->prepare("SELECT id, case_id, title, evidence_type, content_text, metadata_map FROM evidence WHERE id IN ($inClause)");
    $evStmt->execute($newlyUnlockedEvidenceIds);
    $newEvidenceDetails = $evStmt->fetchAll(PDO::FETCH_ASSOC);
}

// Return Authoritative Evaluation Response
echo json_encode([
    'success' => true,
    'attempt' => [
        'id' => $attemptId,
        'scenario_id' => $scenario['id'],
        'current_node_id' => $nextNodeId,
        'status' => $status,
        'score' => $newScore,
        'xp_earned' => (int)$attempt['xp_earned'] + $xpAwarded,
        'selected_actions' => $selectedActions,
        'discovered_evidence_ids' => $discoveredEvidence,
        'state_flags' => $stateFlags
    ],
    'action_taken' => $actionRecord,
    'consequence' => $selectedAction['consequence_summary'] ?? '',
    'score_delta' => $scoreDelta,
    'unlocked_evidence' => $newEvidenceDetails,
    'next_node' => $nextNode,
    'is_finished' => $isTerminal,
    'is_success' => $isSuccess,
    'xp_awarded' => $xpAwarded,
    'investigation_handoff' => $investigationHandoff
]);
