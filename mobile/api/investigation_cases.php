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

// ── Fast Cache (30s TTL) ──
$cacheFile = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'foren_cases_' . ($userId ?? 0) . '.json';
$isRefresh = isset($_GET['refresh']) || (isset($_SERVER['HTTP_CACHE_CONTROL']) && strpos($_SERVER['HTTP_CACHE_CONTROL'], 'no-cache') !== false);

if (!$isRefresh && file_exists($cacheFile) && (time() - filemtime($cacheFile) < 30)) {
    header('X-Cache: HIT');
    echo file_get_contents($cacheFile);
    exit;
}

$db = getDb();

$sql = "
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
ORDER BY c.id ASC
";

$stmt = $db->prepare($sql);
$stmt->execute(['user_id' => $userId ?? 0]);
$casesRaw = $stmt->fetchAll(PDO::FETCH_ASSOC);

$cases = [];
foreach ($casesRaw as $row) {
    $objectives = $row['objectives'] ? json_decode($row['objectives'], true) : [];
    $progress = isset($row['progress']) ? (float)$row['progress'] : 0.0;
    
    $cases[] = [
        'id' => $row['id'],
        'case_code' => $row['case_code'],
        'title' => $row['title'],
        'description' => $row['description'],
        'priority' => $row['priority'],
        'difficulty' => $row['difficulty'],
        'status' => $row['case_status'] ?? 'Open',
        'assigned_date' => $row['assigned_date'] ?? '',
        'progress' => $progress,
        'evidence_list' => [],
        'timeline' => [],
        'suspects' => [],
        'notes' => $row['notes'] ?? '',
        'objectives' => $objectives,
        'verdict' => null
    ];
}

$jsonOutput = json_encode($cases);
@file_put_contents($cacheFile, $jsonOutput);

header('X-Cache: MISS');
echo $jsonOutput;
