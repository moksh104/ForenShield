<?php

/**
 * ForenShield — Leaderboard API
 *
 * GET /leaderboard.php?period=all|weekly|monthly
 *
 * Returns the ranked leaderboard with the authenticated user's position.
 */

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/rank_service.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// ── JWT Authentication ─────────────────────────────────────────────

$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $authorization = $headers['Authorization'];
} elseif (isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}

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

// ── Fetch Leaderboard ──────────────────────────────────────────────

$pdo = getDb();
$period = $_GET['period'] ?? 'all';
$limit = min(100, max(1, (int)($_GET['limit'] ?? 50)));

// Ensure authenticated user has a leaderboard row
ensureLeaderboardEntry($pdo, $authUserId);

// Build date filter
$dateFilter = '';
switch ($period) {
    case 'weekly':
        $dateFilter = "AND last_activity >= NOW() - INTERVAL '7 days'";
        break;
    case 'monthly':
        $dateFilter = "AND last_activity >= NOW() - INTERVAL '30 days'";
        break;
    default:
        $dateFilter = '';
        break;
}

try {
    // Recalculate ranks before serving
    recalculateRanks($pdo);

    // Fetch ranked list
    $sql = "
        SELECT l.user_id, l.username, l.xp, l.rank, l.completed_courses,
               l.completed_cases, l.streak, l.last_activity,
               u.avatar_url
        FROM leaderboard l
        LEFT JOIN users u ON u.id = l.user_id
        WHERE 1=1 $dateFilter
        ORDER BY l.xp DESC
        LIMIT :lim
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->bindValue(':lim', $limit, PDO::PARAM_INT);
    $stmt->execute();
    $entries = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Get current user's position
    $myRank = getUserRank($pdo, $authUserId);

    // Get current user's entry
    $meStmt = $pdo->prepare("
        SELECT l.user_id, l.username, l.xp, l.rank, l.completed_courses,
               l.completed_cases, l.streak, l.last_activity,
               u.avatar_url
        FROM leaderboard l
        LEFT JOIN users u ON u.id = l.user_id
        WHERE l.user_id = :user_id
    ");
    $meStmt->execute(['user_id' => $authUserId]);
    $myEntry = $meStmt->fetch(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'period' => $period,
        'leaderboard' => $entries,
        'current_user' => $myEntry,
        'my_rank' => $myRank,
        'total_players' => count($entries),
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to fetch leaderboard: ' . $e->getMessage()]);
}
