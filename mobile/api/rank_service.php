<?php

/**
 * ForenShield — Rank Service (Phase B Updated)
 *
 * Utility functions for user ranks based on XP leaderboard positions.
 * Note: Ranks are no longer persisted dynamically in the DB.
 */

/**
 * Ensures a leaderboard_stats row exists for the given user.
 */
function ensureLeaderboardEntry(PDO $pdo, int $userId, string $username = ''): void
{
    $stmt = $pdo->prepare("SELECT user_id FROM leaderboard_stats WHERE user_id = :user_id");
    $stmt->execute(['user_id' => $userId]);

    if (!$stmt->fetch()) {
        $ins = $pdo->prepare("
            INSERT INTO leaderboard_stats (user_id, total_xp, current_streak, investigations_completed, courses_completed, reports_completed, threats_resolved, last_updated)
            VALUES (:user_id, 0, 0, 0, 0, 0, 0, NOW())
        ");
        $ins->execute(['user_id' => $userId]);
    }

    // Temporary: also ensure legacy leaderboard entry just in case
    $stmtLegacy = $pdo->prepare("SELECT id FROM leaderboard WHERE user_id = :user_id");
    $stmtLegacy->execute(['user_id' => $userId]);
    if (!$stmtLegacy->fetch()) {
        $insL = $pdo->prepare("
            INSERT INTO leaderboard (user_id, username, xp, rank, completed_courses, completed_cases, streak, last_activity)
            VALUES (:user_id, :username, 0, 0, 0, 0, 0, NOW())
        ");
        $insL->execute(['user_id' => $userId, 'username' => $username]);
    }
}

/**
 * Get the global rank position for a specific user dynamically.
 */
function getUserRank(PDO $pdo, int $userId): int
{
    $stmt = $pdo->prepare("
        SELECT rnk FROM (
            SELECT user_id, RANK() OVER (ORDER BY total_xp DESC) as rnk
            FROM leaderboard_stats
        ) sub
        WHERE user_id = :user_id
    ");
    $stmt->execute(['user_id' => $userId]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    return $row ? (int)$row['rnk'] : 0;
}

/**
 * (Deprecated) Recalculate ranks. Kept for legacy compatibility.
 */
function recalculateRanks(PDO $pdo): void
{
    // No-op for new schema as ranks are dynamic.
    // Kept to avoid breaking legacy calls.
}

/**
 * Determine user level based on XP thresholds.
 */
function getLevelForXp(int $xp): int
{
    return (int)floor($xp / 500) + 1;
}
