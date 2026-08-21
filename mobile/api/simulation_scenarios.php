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
    usp.is_completed
FROM scenarios s
LEFT JOIN user_scenario_progress usp ON s.id = usp.scenario_id AND usp.user_id = :user_id
";

$stmt = $db->prepare($sql);
$stmt->execute(['user_id' => $userId ?? 0]);
$scenariosRaw = $stmt->fetchAll(PDO::FETCH_ASSOC);

$scenarios = [];
foreach ($scenariosRaw as $row) {
    $scenarios[] = [
        'id' => $row['id'],
        'title' => $row['title'],
        'description' => $row['description'],
        'category' => $row['category'],
        'difficulty' => $row['difficulty'],
        'estimatedMinutes' => (int)$row['duration_minutes'],
        'xpReward' => (int)$row['xp_reward'],
        'initialTerminalHistory' => $row['initial_state'] ? json_decode($row['initial_state'], true) : [],
        'objectives' => $row['objectives'] ? json_decode($row['objectives'], true) : [],
        'isCompleted' => isset($row['is_completed']) ? (bool)$row['is_completed'] : false
    ];
}

echo json_encode($scenarios);
