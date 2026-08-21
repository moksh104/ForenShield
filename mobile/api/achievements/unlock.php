<?php
/**
 * ForenShield — Achievements Unlock API
 *
 * POST /achievements/unlock.php
 * Force-unlocks a specific achievement by code.
 */
require_once __DIR__ . '/../cors.php';
require_once __DIR__ . '/../config.php';
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
$code = $input['code'] ?? '';
if (!$code) {
    http_response_code(400);
    echo json_encode(['error' => 'Achievement code is required.']);
    exit;
}

$pdo = getDb();
try {
    $pdo->beginTransaction();
    $stmt = $pdo->prepare("SELECT * FROM achievements WHERE code = :code");
    $stmt->execute(['code' => $code]);
    $ach = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$ach) {
        throw new Exception("Achievement not found.");
    }

    $ins = $pdo->prepare("
        INSERT INTO user_achievements (user_id, achievement_id, unlocked_at)
        VALUES (:uid, :ach_id, NOW())
        ON CONFLICT DO NOTHING
    ");
    $ins->execute(['uid' => $authUserId, 'ach_id' => $ach['id']]);

    if ($ins->rowCount() > 0) {
        $xpStr = $ach['xp_reward'] > 0 ? " +{$ach['xp_reward']} XP" : "";
        $pdo->prepare("
            INSERT INTO notifications (user_id, title, message, type)
            VALUES (:uid, :title, :message, 'achievement')
        ")->execute([
            'uid' => $authUserId,
            'title' => '🏆 Achievement Unlocked',
            'message' => "{$ach['title']}{$xpStr}",
        ]);
        
        if ($ach['xp_reward'] > 0) {
            $pdo->prepare("UPDATE leaderboard_stats SET total_xp = total_xp + :xp WHERE user_id = :uid")->execute(['xp' => $ach['xp_reward'], 'uid' => $authUserId]);
        }
    }

    $pdo->commit();
    echo json_encode(['success' => true]);
} catch (Exception $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
