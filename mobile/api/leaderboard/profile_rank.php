<?php

require_once __DIR__ . '/../cors.php';
require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../rank_service.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

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
    $username = $decoded->name ?? '';
    if (!$authUserId) throw new Exception('Invalid token payload.');
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

$pdo = getDb();
ensureLeaderboardEntry($pdo, $authUserId, $username);

try {
    // 1. Get Nearby Players and Global Rank in one query
    $sqlNearby = "
        WITH Ranked AS (
            SELECT 
                l.user_id,
                COALESCE(u.full_name, 'Agent') as username,
                u.avatar_url,
                l.total_xp as xp,
                l.current_streak as streak,
                l.courses_completed as completed_courses,
                l.investigations_completed as completed_cases,
                RANK() OVER (ORDER BY l.total_xp DESC) as rank
            FROM leaderboard_stats l
            JOIN users u ON u.id = l.user_id
        ),
        MyRank AS (
            SELECT rank FROM Ranked WHERE user_id = :uid
        )
        SELECT r.* 
        FROM Ranked r
        JOIN MyRank m ON 1=1
        WHERE r.rank BETWEEN m.rank - 2 AND m.rank + 2
        ORDER BY r.rank ASC
    ";
    
    $stmt = $pdo->prepare($sqlNearby);
    $stmt->execute(['uid' => $authUserId]);
    $nearby = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Find my own rank object from nearby
    $myEntry = null;
    foreach ($nearby as $p) {
        if ($p['user_id'] == $authUserId) {
            $myEntry = $p;
            break;
        }
    }
    
    // Calculate total players
    $totalPlayers = (int)$pdo->query("SELECT COUNT(*) FROM leaderboard_stats")->fetchColumn();
    $percentile = 0;
    if ($myEntry && $totalPlayers > 1) {
        $percentile = round((1 - ($myEntry['rank'] / $totalPlayers)) * 100, 1);
    }
    
    // Calculate Weekly Position
    $stmtWeekly = $pdo->prepare("
        WITH WeeklyAgg AS (
            SELECT user_id, SUM(xp_earned) as weekly_xp FROM daily_activity
            WHERE date >= CURRENT_DATE - INTERVAL '7 days' GROUP BY user_id
        ),
        RankedWeekly AS (
            SELECT user_id, RANK() OVER (ORDER BY weekly_xp DESC) as rnk FROM WeeklyAgg
        )
        SELECT rnk FROM RankedWeekly WHERE user_id = :uid
    ");
    $stmtWeekly->execute(['uid' => $authUserId]);
    $weeklyRank = (int)($stmtWeekly->fetchColumn() ?: 0);
    
    // Calculate Monthly Position
    $stmtMonthly = $pdo->prepare("
        WITH MonthlyAgg AS (
            SELECT user_id, SUM(xp_earned) as monthly_xp FROM daily_activity
            WHERE date >= CURRENT_DATE - INTERVAL '30 days' GROUP BY user_id
        ),
        RankedMonthly AS (
            SELECT user_id, RANK() OVER (ORDER BY monthly_xp DESC) as rnk FROM MonthlyAgg
        )
        SELECT rnk FROM RankedMonthly WHERE user_id = :uid
    ");
    $stmtMonthly->execute(['uid' => $authUserId]);
    $monthlyRank = (int)($stmtMonthly->fetchColumn() ?: 0);

    echo json_encode([
        'success' => true,
        'current_user' => $myEntry,
        'percentile' => $percentile,
        'total_players' => $totalPlayers,
        'weekly_position' => $weeklyRank,
        'monthly_position' => $monthlyRank,
        'nearby_players' => $nearby
    ]);
} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
