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

$page = max(1, (int)($_GET['page'] ?? 1));
$limit = min(100, max(1, (int)($_GET['limit'] ?? 20)));
$offset = ($page - 1) * $limit;

$search = trim($_GET['search'] ?? '');
$sort = strtolower(trim($_GET['sort'] ?? 'xp'));
$order = strtolower(trim($_GET['order'] ?? 'desc')) === 'asc' ? 'ASC' : 'DESC';

$pdo = getDb();
ensureLeaderboardEntry($pdo, $authUserId, $username);

$where = ["1=1"];
$params = [];

if ($search !== '') {
    if (preg_match('/^#(\d+)$/', $search, $m)) {
        // rank exact
        $where[] = "sub.rnk = :srch_rank";
        $params['srch_rank'] = (int)$m[1];
    } elseif (preg_match('/^>(\d+)$/', $search, $m)) {
        $where[] = "sub.total_xp > :srch_xp_gt";
        $params['srch_xp_gt'] = (int)$m[1];
    } elseif (preg_match('/^<(\d+)$/', $search, $m)) {
        $where[] = "sub.total_xp < :srch_xp_lt";
        $params['srch_xp_lt'] = (int)$m[1];
    } elseif (preg_match('/^XP:(\d+)-(\d+)$/i', $search, $m)) {
        $where[] = "sub.total_xp BETWEEN :srch_xp_low AND :srch_xp_high";
        $params['srch_xp_low'] = (int)$m[1];
        $params['srch_xp_high'] = (int)$m[2];
    } else {
        $where[] = "u.full_name ILIKE :srch_name";
        $params['srch_name'] = "%$search%";
    }
}

$orderCol = 'sub.total_xp';
if ($sort === 'rank') $orderCol = 'sub.rnk';
elseif ($sort === 'courses') $orderCol = 'sub.courses_completed';
elseif ($sort === 'investigations') $orderCol = 'sub.investigations_completed';
elseif ($sort === 'streak') $orderCol = 'sub.current_streak';

$whereSql = implode(' AND ', $where);

try {
    $sql = "
        WITH RankedUsers AS (
            SELECT 
                l.user_id,
                l.total_xp,
                l.current_streak,
                l.investigations_completed,
                l.courses_completed,
                l.reports_completed,
                RANK() OVER (ORDER BY l.total_xp DESC) as rnk
            FROM leaderboard_stats l
        )
        SELECT 
            sub.user_id,
            COALESCE(u.full_name, 'Agent') as username,
            sub.total_xp as xp,
            sub.rnk as rank,
            sub.courses_completed as completed_courses,
            sub.investigations_completed as completed_cases,
            sub.current_streak as streak,
            u.avatar_url
        FROM RankedUsers sub
        JOIN users u ON u.id = sub.user_id
        WHERE $whereSql
        ORDER BY $orderCol $order
        LIMIT :limit OFFSET :offset
    ";

    $stmt = $pdo->prepare($sql);
    foreach ($params as $k => $v) {
        $stmt->bindValue(":$k", $v);
    }
    $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
    $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
    $stmt->execute();
    $entries = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'page' => $page,
        'limit' => $limit,
        'leaderboard' => $entries,
        'total_players' => 0 // Pagination limits us from calculating exact total easily without another query, but we can return empty if not needed
    ]);
} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
