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

$evidenceId = $_GET['id'] ?? null;
if (!$evidenceId) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing evidence ID']);
    exit;
}

$db = getDb();
$stmt = $db->prepare("
SELECT 
    id, 
    title, 
    evidence_type, 
    content_text, 
    metadata_map, 
    evidence_timestamp
FROM evidence
WHERE id = :id
");
$stmt->execute(['id' => $evidenceId]);
$eRow = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$eRow) {
    http_response_code(404);
    echo json_encode(['error' => 'Evidence not found']);
    exit;
}

$evidence = [
    'id' => $eRow['id'],
    'title' => $eRow['title'],
    'type' => $eRow['evidence_type'],
    'content_text' => $eRow['content_text'],
    'metadata_map' => $eRow['metadata_map'] ? json_decode($eRow['metadata_map'], true) : [],
    'is_reviewed' => true,
    'timestamp' => $eRow['evidence_timestamp']
];

echo json_encode($evidence);
