<?php

/**
 * ForenShield — Streak Service
 *
 * Utility functions for tracking and updating daily activity streaks.
 */

/**
 * Get the current streak for a user.
 */
function getStreak(PDO $pdo, int $userId): int
{
    $stmt = $pdo->prepare("SELECT streak FROM leaderboard WHERE user_id = :user_id");
    $stmt->execute(['user_id' => $userId]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    return $row ? (int)$row['streak'] : 0;
}

/**
 * Update streak based on last_activity timestamp.
 *
 * If the last activity was yesterday, increment streak.
 * If the last activity was today, no change.
 * If older than yesterday, reset to 1.
 *
 * Returns the updated streak value.
 */
function updateStreak(PDO $pdo, int $userId): int
{
    $stmt = $pdo->prepare("
        SELECT streak, last_activity FROM leaderboard WHERE user_id = :user_id
    ");
    $stmt->execute(['user_id' => $userId]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        return 0;
    }

    $lastActivity = $row['last_activity']
        ? new DateTime($row['last_activity'])
        : new DateTime('2000-01-01');
    $today = new DateTime('today');
    $yesterday = new DateTime('yesterday');
    $currentStreak = (int)$row['streak'];

    // Calculate the date portion of last activity
    $lastDate = (clone $lastActivity)->setTime(0, 0, 0);

    if ($lastDate == $today) {
        // Already active today — keep current streak
        $newStreak = $currentStreak;
    } elseif ($lastDate == $yesterday) {
        // Active yesterday — extend streak
        $newStreak = $currentStreak + 1;
    } else {
        // Gap in activity — reset
        $newStreak = 1;
    }

    // Update streak and last_activity
    $upd = $pdo->prepare("
        UPDATE leaderboard
        SET streak = :streak, last_activity = NOW()
        WHERE user_id = :user_id
    ");
    $upd->execute(['streak' => $newStreak, 'user_id' => $userId]);

    return $newStreak;
}
