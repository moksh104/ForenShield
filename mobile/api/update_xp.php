<?php

/**
 * ForenShield — Update XP API
 *
 * POST /update_xp.php
 * Body: { "xp": 50, "reason": "quiz_pass" }
 *
 * Awards XP to the authenticated user, recalculates ranks,
 * updates streak, and triggers achievement evaluation.
 */

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/rank_service.php';
require_once __DIR__ . '/streak_service.php';
require_once __DIR__ . '/achievement_engine.php';

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
    $username = $decoded->name ?? '';
    if (!$authUserId) throw new Exception('Invalid token payload.');
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

// ── Validate Input ─────────────────────────────────────────────────

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'POST method required.']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$xpToAdd = (int)($input['xp'] ?? 0);
$reason = trim($input['reason'] ?? 'general');

if ($xpToAdd <= 0 || $xpToAdd > 500) {
    http_response_code(400);
    echo json_encode(['error' => 'XP must be between 1 and 500.']);
    exit;
}

// ── Update XP ──────────────────────────────────────────────────────

$pdo = getDb();

try {
    // Ensure user has a leaderboard entry
    ensureLeaderboardEntry($pdo, $authUserId, $username);

    // Add XP
    $stmt = $pdo->prepare("
        UPDATE leaderboard
        SET xp = xp + :xp, last_activity = NOW()
        WHERE user_id = :user_id
    ");
    $stmt->execute(['xp' => $xpToAdd, 'user_id' => $authUserId]);

    // Update completed counts based on reason
    if ($reason === 'course_complete') {
        $pdo->prepare("UPDATE leaderboard SET completed_courses = completed_courses + 1 WHERE user_id = :uid")
            ->execute(['uid' => $authUserId]);
    } elseif ($reason === 'investigation_complete') {
        $pdo->prepare("UPDATE leaderboard SET completed_cases = completed_cases + 1 WHERE user_id = :uid")
            ->execute(['uid' => $authUserId]);
    }

    // Update streak
    $streak = updateStreak($pdo, $authUserId);

    // Recalculate all ranks
    recalculateRanks($pdo);

    // Get updated stats
    $updStmt = $pdo->prepare("SELECT xp, rank, completed_courses, completed_cases, streak FROM leaderboard WHERE user_id = :uid");
    $updStmt->execute(['uid' => $authUserId]);
    $stats = $updStmt->fetch(PDO::FETCH_ASSOC);

    $level = getLevelForXp((int)$stats['xp']);

    // Evaluate achievements
    $newAchievements = evaluateAchievements($pdo, $authUserId, $stats);

    echo json_encode([
        'success' => true,
        'xp_added' => $xpToAdd,
        'reason' => $reason,
        'total_xp' => (int)$stats['xp'],
        'rank' => (int)$stats['rank'],
        'level' => $level,
        'streak' => (int)$stats['streak'],
        'completed_courses' => (int)$stats['completed_courses'],
        'completed_cases' => (int)$stats['completed_cases'],
        'new_achievements' => $newAchievements,
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to update XP: ' . $e->getMessage()]);
}
