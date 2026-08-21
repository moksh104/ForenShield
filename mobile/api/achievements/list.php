<?php

/**
 * ForenShield — Achievements List API
 *
 * GET /achievements/list.php
 * Params: ?category=mission&page=1&limit=20
 *
 * Returns a list of achievements and the user's computed progress.
 */

require_once __DIR__ . '/../cors.php';
require_once __DIR__ . '/../config.php';

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
    if (!$authUserId) throw new Exception('Invalid token payload.');
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

$page = max(1, (int)($_GET['page'] ?? 1));
$limit = max(1, min(100, (int)($_GET['limit'] ?? 20)));
$offset = ($page - 1) * $limit;
$categoryFilter = $_GET['category'] ?? '';
$searchQuery = $_GET['search'] ?? '';

$pdo = getDb();

try {
    // 1. Fetch user's leaderboard_stats to compute progress dynamically
    $statsStmt = $pdo->prepare("SELECT * FROM leaderboard_stats WHERE user_id = :uid");
    $statsStmt->execute(['uid' => $authUserId]);
    $stats = $statsStmt->fetch(PDO::FETCH_ASSOC) ?: [];

    // 2. Build query
    $whereClauses = [];
    $params = [];

    if ($categoryFilter && $categoryFilter !== 'all') {
        $whereClauses[] = "a.category = :cat";
        $params['cat'] = $categoryFilter;
    }

    if ($searchQuery) {
        $whereClauses[] = "(a.title ILIKE :search OR a.description ILIKE :search)";
        $params['search'] = "%$searchQuery%";
    }

    $whereSql = $whereClauses ? "WHERE " . implode(" AND ", $whereClauses) : "";

    // We want to sort completed achievements down, or just keep them sorted by threshold.
    // Actually, order by is_completed ASC, category ASC, threshold ASC.
    $sql = "
        SELECT 
            a.id, a.code, a.title, a.description, a.icon, a.category, 
            a.xp_reward, a.rarity, a.target_metric, a.threshold, a.created_at,
            ua.unlocked_at,
            (ua.id IS NOT NULL) AS is_completed
        FROM achievements a
        LEFT JOIN user_achievements ua ON a.id = ua.achievement_id AND ua.user_id = :uid
        $whereSql
        ORDER BY is_completed ASC, a.category ASC, a.threshold ASC
        LIMIT :limit OFFSET :offset
    ";

    $params['uid'] = $authUserId;

    $stmt = $pdo->prepare($sql);
    
    // Bind parameters carefully for LIMIT/OFFSET
    foreach ($params as $key => $val) {
        $stmt->bindValue(":$key", $val);
    }
    $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
    $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
    $stmt->execute();
    
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Compute progress for each
    $formatted = [];
    foreach ($results as $row) {
        $metric = $row['target_metric'];
        $threshold = (int)$row['threshold'];
        $isCompleted = (bool)$row['is_completed'];
        
        $currentVal = isset($stats[$metric]) ? (int)$stats[$metric] : 0;
        if ($isCompleted) {
            $progress = $threshold; // already unlocked
        } else {
            $progress = min($currentVal, $threshold); // cap at threshold just in case
        }

        $formatted[] = [
            'id' => $row['id'],
            'code' => $row['code'],
            'title' => $row['title'],
            'description' => $row['description'],
            'icon' => $row['icon'],
            'category' => $row['category'],
            'xp_reward' => (int)$row['xp_reward'],
            'rarity' => $row['rarity'],
            'target_metric' => $metric,
            'threshold' => $threshold,
            'progress' => $progress,
            'is_completed' => $isCompleted,
            'unlocked_at' => $row['unlocked_at']
        ];
    }

    echo json_encode([
        'achievements' => $formatted,
        'page' => $page,
        'limit' => $limit
    ]);

} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
