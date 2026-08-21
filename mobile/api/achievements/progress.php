<?php
/**
 * ForenShield — Achievements Progress API
 *
 * POST /achievements/progress.php
 * Increments an authoritative metric and evaluates achievements.
 */
require_once __DIR__ . '/../cors.php';
require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../achievement_engine.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) $authorization = $headers['Authorization'];
elseif (isset($headers['authorization'])) $authorization = $headers['authorization'];

if (!$authorization || !preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    http_response_code(401);
    echo json_encode(['error' => 'Missing or invalid Authorization header.']);
    exit;
}
try {
    $decoded = JWT::decode($matches[1], new Key(JWT_SECRET, 'HS256'));
    $authUserId = (int)($decoded->sub ?? 0);
    if (!$authUserId) throw new Exception('Invalid token payload.');
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$metric = $input['metric'] ?? '';
$amount = (int)($input['amount'] ?? 1);

$allowedMetrics = ['total_xp', 'current_streak', 'investigations_completed', 'courses_completed', 'reports_completed', 'threats_resolved', 'missions_completed'];
if (!in_array($metric, $allowedMetrics) || $amount <= 0) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid metric or amount.']);
    exit;
}

$pdo = getDb();
try {
    $pdo->beginTransaction();
    
    // Update metric
    $sql = "UPDATE leaderboard_stats SET $metric = $metric + :amt WHERE user_id = :uid";
    $pdo->prepare($sql)->execute(['amt' => $amount, 'uid' => $authUserId]);

    // Check achievements
    $updStmt = $pdo->prepare("SELECT * FROM leaderboard_stats WHERE user_id = :uid");
    $updStmt->execute(['uid' => $authUserId]);
    $stats = $updStmt->fetch(PDO::FETCH_ASSOC);

    $newAchievements = evaluateAchievements($pdo, $authUserId, $stats);
    $pdo->commit();
    echo json_encode(['success' => true, 'unlocked' => array_column($newAchievements, 'title')]);
} catch (Exception $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
