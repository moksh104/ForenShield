<?php

/**
 * ForenShield — Production Achievement Engine
 *
 * Generic rule engine that evaluates achievement unlocks dynamically based
 * on threshold rules defined in the achievements table.
 */

/**
 * Evaluates all locked achievements for a user and unlocks them if thresholds are met.
 * Must be called within an active PDO transaction.
 *
 * @param PDO $pdo        Database connection
 * @param int $userId     Authenticated user ID
 * @param array $stats    Current leaderboard_stats row for the user
 * @return array          List of newly unlocked achievement arrays
 */
function evaluateAchievements(PDO $pdo, int $userId, array $stats): array
{
    // Fetch all achievements the user has NOT unlocked yet
    $stmt = $pdo->prepare("
        SELECT a.id, a.code, a.title, a.xp_reward, a.target_metric, a.threshold
        FROM achievements a
        LEFT JOIN user_achievements ua ON a.id = ua.achievement_id AND ua.user_id = :uid
        WHERE ua.id IS NULL
    ");
    $stmt->execute(['uid' => $userId]);
    $lockedAchievements = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $newlyUnlocked = [];

    foreach ($lockedAchievements as $ach) {
        $metric = $ach['target_metric'];
        $threshold = (int)$ach['threshold'];

        // Determine if condition is met based on the dynamic metric from stats
        $currentValue = isset($stats[$metric]) ? (int)$stats[$metric] : 0;
        
        if ($currentValue >= $threshold) {
            // Unlock!
            $ins = $pdo->prepare("
                INSERT INTO user_achievements (user_id, achievement_id, unlocked_at)
                VALUES (:uid, :ach_id, NOW())
            ");
            $ins->execute([
                'uid' => $userId,
                'ach_id' => $ach['id']
            ]);

            // Create notification
            $xpStr = $ach['xp_reward'] > 0 ? " +{$ach['xp_reward']} XP" : "";
            $notif = $pdo->prepare("
                INSERT INTO notifications (user_id, title, message, type)
                VALUES (:uid, :title, :message, 'achievement')
            ");
            $notif->execute([
                'uid' => $userId,
                'title' => '🏆 Achievement Unlocked',
                'message' => "{$ach['title']}{$xpStr}",
            ]);

            // Add to return array so the caller can award XP and log transaction
            $newlyUnlocked[] = $ach;
        }
    }

    // Level up check
    $xp = (int)($stats['total_xp'] ?? 0);
    $levelThresholds = [2 => 250, 3 => 500, 4 => 1000, 5 => 2500, 6 => 5000];
    foreach ($levelThresholds as $lvl => $thresh) {
        // Only notify if exactly matching threshold area (simple check for recent level up)
        if ($xp >= $thresh && $xp < $thresh + 200) {
            $checkNotif = $pdo->prepare("SELECT id FROM notifications WHERE user_id = :uid AND title = :title AND created_at > NOW() - INTERVAL '1 day'");
            $titleStr = "⬆️ Level $lvl Reached!";
            $checkNotif->execute(['uid' => $userId, 'title' => $titleStr]);
            if (!$checkNotif->fetch()) {
                $pdo->prepare("INSERT INTO notifications (user_id, title, message, type) VALUES (:uid, :title, :message, 'level_up')")
                    ->execute([
                        'uid' => $userId,
                        'title' => $titleStr,
                        'message' => "Congratulations! You've reached Level $lvl."
                    ]);
            }
        }
    }

    return $newlyUnlocked;
}
