<?php

/**
 * ForenShield — Rank Service
 *
 * Utility functions for recalculating and querying user ranks
 * based on XP leaderboard positions.
 */

/**
 * Recalculate all user ranks based on XP (descending).
 */
function recalculateRanks(PDO $pdo): void
{
    $pdo->exec("
        UPDATE leaderboard AS lb
        SET rank = sub.new_rank
        FROM (
            SELECT id, ROW_NUMBER() OVER (ORDER BY xp DESC) AS new_rank
            FROM leaderboard
        ) AS sub
        WHERE lb.id = sub.id
    ");
}

/**
 * Get the rank position for a specific user.
 */
function getUserRank(PDO $pdo, int $userId): int
{
    $stmt = $pdo->prepare("
        SELECT rank FROM leaderboard WHERE user_id = :user_id
    ");
    $stmt->execute(['user_id' => $userId]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    return $row ? (int)$row['rank'] : 0;
}

/**
 * Ensure a leaderboard row exists for the given user.
 */
function ensureLeaderboardEntry(PDO $pdo, int $userId, string $username = ''): void
{
    $stmt = $pdo->prepare("SELECT id FROM leaderboard WHERE user_id = :user_id");
    $stmt->execute(['user_id' => $userId]);

    if (!$stmt->fetch()) {
        $ins = $pdo->prepare("
            INSERT INTO leaderboard (user_id, username, xp, rank, completed_courses, completed_cases, streak, last_activity)
            VALUES (:user_id, :username, 0, 0, 0, 0, 0, NOW())
        ");
        $ins->execute(['user_id' => $userId, 'username' => $username]);
    }
}

/**
 * Determine user level based on XP thresholds.
 *
 * Level 1 → 0 XP
 * Level 2 → 250 XP
 * Level 3 → 500 XP
 * Level 4 → 1000 XP
 * Level 5 → 2500 XP
 * Level 6 → 5000 XP
 */
function getLevelForXp(int $xp): int
{
    if ($xp >= 5000) return 6;
    if ($xp >= 2500) return 5;
    if ($xp >= 1000) return 4;
    if ($xp >= 500) return 3;
    if ($xp >= 250) return 2;
    return 1;
}
