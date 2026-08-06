<?php

/**
 * ForenShield — Achievement Engine
 *
 * Evaluates whether a user has met the unlock conditions for each
 * achievement and triggers unlock + notification insertion.
 */

require_once __DIR__ . '/achievement_service.php';
require_once __DIR__ . '/rank_service.php';

/**
 * Evaluate all achievement conditions for a user.
 *
 * @param PDO $pdo        Database connection
 * @param int $userId     Authenticated user ID
 * @param array $stats    Current leaderboard stats: xp, rank, completed_courses, completed_cases, streak
 * @return array          List of newly unlocked achievement titles
 */
function evaluateAchievements(PDO $pdo, int $userId, array $stats): array
{
    // Ensure achievement rows exist
    seedAchievements($pdo, $userId);

    $xp = (int)($stats['xp'] ?? 0);
    $completedCases = (int)($stats['completed_cases'] ?? 0);
    $completedCourses = (int)($stats['completed_courses'] ?? 0);
    $streak = (int)($stats['streak'] ?? 0);
    $level = getLevelForXp($xp);

    // Define unlock conditions: title => condition
    $conditions = [
        'Beginner Investigator' => $completedCases >= 1,
        'Threat Hunter'         => $completedCases >= 5,
        'Cyber Defender'        => $level >= 3,
        'Academy Master'        => $completedCourses >= 5,
        'Speed Analyst'         => false, // Requires time-based tracking (future)
        'Seven-Day Streak'      => $streak >= 7,
        'Threat Specialist'     => $level >= 5,
        'Forensic Expert'       => $xp >= 5000,
    ];

    $newlyUnlocked = [];

    foreach ($conditions as $title => $met) {
        if (!$met) continue;

        // Check if already unlocked
        $check = $pdo->prepare("
            SELECT id, unlocked FROM achievements
            WHERE user_id = :user_id AND title = :title
        ");
        $check->execute(['user_id' => $userId, 'title' => $title]);
        $row = $check->fetch(PDO::FETCH_ASSOC);

        if ($row && !$row['unlocked']) {
            // Unlock it
            $unlock = $pdo->prepare("
                UPDATE achievements
                SET unlocked = TRUE, unlocked_at = NOW()
                WHERE id = :id
            ");
            $unlock->execute(['id' => $row['id']]);

            // Award achievement XP
            $pdo->prepare("UPDATE leaderboard SET xp = xp + 200 WHERE user_id = :uid")
                ->execute(['uid' => $userId]);

            // Insert notification
            $notif = $pdo->prepare("
                INSERT INTO notifications (user_id, title, message, type)
                VALUES (:uid, :title, :message, 'achievement')
            ");
            $notif->execute([
                'uid' => $userId,
                'title' => '🏆 Achievement Unlocked!',
                'message' => "You earned \"$title\" and received 200 XP!",
            ]);

            $newlyUnlocked[] = $title;
        }
    }

    // Check for level-up notification
    if ($level >= 2) {
        // Only notify if XP just crossed the threshold (rough check)
        $levelThresholds = [2 => 250, 3 => 500, 4 => 1000, 5 => 2500, 6 => 5000];
        foreach ($levelThresholds as $lvl => $threshold) {
            if ($xp >= $threshold && $xp < $threshold + 200) {
                $notif = $pdo->prepare("
                    INSERT INTO notifications (user_id, title, message, type)
                    VALUES (:uid, :title, :message, 'level_up')
                ");
                $notif->execute([
                    'uid' => $userId,
                    'title' => "⬆️ Level $lvl Reached!",
                    'message' => "Congratulations! You've reached Level $lvl.",
                ]);
                break;
            }
        }
    }

    // Check for top rank notification
    $rank = getUserRank($pdo, $userId);
    if ($rank > 0 && $rank <= 3) {
        $ordinals = [1 => '1st', 2 => '2nd', 3 => '3rd'];
        // Simple: only notify if rank is in top 3 (could be enhanced with duplicate checks)
        $checkNotif = $pdo->prepare("
            SELECT id FROM notifications
            WHERE user_id = :uid AND type = 'rank_top'
            AND created_at > NOW() - INTERVAL '24 hours'
        ");
        $checkNotif->execute(['uid' => $userId]);
        if (!$checkNotif->fetch()) {
            $notif = $pdo->prepare("
                INSERT INTO notifications (user_id, title, message, type)
                VALUES (:uid, :title, :message, 'rank_top')
            ");
            $notif->execute([
                'uid' => $userId,
                'title' => '🥇 Top Ranked!',
                'message' => "You're now ranked {$ordinals[$rank]} on the global leaderboard!",
            ]);
        }
    }

    // Check streak milestones
    $streakMilestones = [7, 14, 30, 60, 100];
    if (in_array($streak, $streakMilestones)) {
        $notif = $pdo->prepare("
            INSERT INTO notifications (user_id, title, message, type)
            VALUES (:uid, :title, :message, 'streak_milestone')
        ");
        $notif->execute([
            'uid' => $userId,
            'title' => "🔥 $streak-Day Streak!",
            'message' => "Incredible! You've maintained a $streak-day activity streak!",
        ]);
    }

    return $newlyUnlocked;
}
