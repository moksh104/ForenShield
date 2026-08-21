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

$caseId = $_GET['id'] ?? null;
if (!$caseId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing case ID']);
    exit;
}

$db = getDb();

// 1. Fetch Case
$stmt = $db->prepare("
SELECT 
    c.id, 
    c.case_code, 
    c.title, 
    c.description, 
    c.priority, 
    c.difficulty, 
    c.status as case_status, 
    c.assigned_date, 
    c.notes, 
    c.objectives, 
    ucp.progress,
    ucp.is_solved,
    ucp.status as user_status
FROM cases c
LEFT JOIN user_case_progress ucp ON c.id = ucp.case_id AND ucp.user_id = :user_id
WHERE c.id = :case_id
");
$stmt->execute(['user_id' => $userId ?? 0, 'case_id' => $caseId]);
$case = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$case) {
    http_response_code(404);
    echo json_encode(['error' => 'Case not found']);
    exit;
}

// 2. Fetch Evidence
$stmtEv = $db->prepare("
SELECT 
    id, 
    title, 
    evidence_type, 
    content_text, 
    metadata_map, 
    evidence_timestamp
FROM evidence
WHERE case_id = :case_id
ORDER BY created_at ASC
");
$stmtEv->execute(['case_id' => $caseId]);
$evidenceRaw = $stmtEv->fetchAll(PDO::FETCH_ASSOC);

$evidenceList = [];
foreach ($evidenceRaw as $eRow) {
    $evidenceList[] = [
        'id' => $eRow['id'],
        'title' => $eRow['title'],
        'type' => $eRow['evidence_type'],
        'content_text' => $eRow['content_text'],
        'metadata_map' => $eRow['metadata_map'] ? json_decode($eRow['metadata_map'], true) : [],
        'is_reviewed' => true, // Simplification for now, we don't track per-evidence review in user progress currently
        'timestamp' => $eRow['evidence_timestamp']
    ];
}

// 3. Fetch Timeline
$stmtTl = $db->prepare("
SELECT 
    id, 
    title, 
    description, 
    timeline_timestamp, 
    category, 
    severity
FROM case_timeline
WHERE case_id = :case_id
ORDER BY created_at ASC
");
$stmtTl->execute(['case_id' => $caseId]);
$timelineRaw = $stmtTl->fetchAll(PDO::FETCH_ASSOC);

$timelineList = [];
foreach ($timelineRaw as $tRow) {
    $timelineList[] = [
        'id' => $tRow['id'],
        'title' => $tRow['title'],
        'description' => $tRow['description'],
        'timestamp' => $tRow['timeline_timestamp'],
        'category' => $tRow['category'],
        'severity' => $tRow['severity'],
        'is_expanded' => true
    ];
}

// 4. Fetch Verdict
$stmtVd = $db->prepare("
SELECT 
    id, 
    summary_text, 
    options, 
    correct_option_index, 
    explanation_text, 
    xp_reward
FROM verdicts
WHERE case_id = :case_id
LIMIT 1
");
$stmtVd->execute(['case_id' => $caseId]);
$verdictRaw = $stmtVd->fetch(PDO::FETCH_ASSOC);

$verdict = null;
if ($verdictRaw) {
    $verdict = [
        'id' => $verdictRaw['id'],
        'case_id' => $caseId,
        'summary_text' => $verdictRaw['summary_text'],
        'options' => $verdictRaw['options'] ? json_decode($verdictRaw['options'], true) : [],
        'correct_option_index' => (int)$verdictRaw['correct_option_index'],
        'explanation_text' => $verdictRaw['explanation_text'],
        'xp_reward' => (int)$verdictRaw['xp_reward']
    ];
}

// Assemble JSON
$objectives = $case['objectives'] ? json_decode($case['objectives'], true) : [];
$progress = isset($case['progress']) ? (float)$case['progress'] : 0.0;

$response = [
    'id' => $case['id'],
    'case_code' => $case['case_code'],
    'title' => $case['title'],
    'description' => $case['description'],
    'priority' => $case['priority'],
    'difficulty' => $case['difficulty'],
    'status' => $case['case_status'] ?? 'Open',
    'assigned_date' => $case['assigned_date'] ?? '',
    'progress' => $progress,
    'evidence_list' => $evidenceList,
    'timeline' => $timelineList,
    'suspects' => [],
    'notes' => $case['notes'] ?? '',
    'objectives' => $objectives,
    'verdict' => $verdict
];

echo json_encode($response);
