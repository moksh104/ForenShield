<?php

/**
 * ForenShield — Achievements API
 *
 * GET /achievements.php
 *
 * Returns all achievements for the authenticated user (locked and unlocked).
 */

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/achievement_service.php';

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

// ── Fetch Achievements ─────────────────────────────────────────────

$pdo = getDb();

try {
    $achievements = getAchievements($pdo, $authUserId);

    $unlockedCount = 0;
    $totalXpEarned = 0;
    foreach ($achievements as $a) {
        if ($a['unlocked']) {
            $unlockedCount++;
            $totalXpEarned += (int)$a['xp'];
        }
    }

    echo json_encode([
        'success' => true,
        'achievements' => $achievements,
        'total' => count($achievements),
        'unlocked_count' => $unlockedCount,
        'total_xp_earned' => $totalXpEarned,
    ]);
} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
