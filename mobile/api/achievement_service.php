<?php

/**
 * ForenShield — Achievement Service
 *
 * Contains achievement definitions and seeding logic.
 */

/**
 * The 8 base achievement definitions.
 */
function getAchievementDefinitions(): array
{
    return [
        [
            'title' => 'Beginner Investigator',
            'description' => 'Complete your first digital forensics investigation.',
            'badge' => '🏆',
            'xp' => 200,
        ],
        [
            'title' => 'Threat Hunter',
            'description' => 'Complete 5 investigations and prove your threat hunting skills.',
            'badge' => '🔍',
            'xp' => 200,
        ],
        [
            'title' => 'Cyber Defender',
            'description' => 'Reach Level 3 and demonstrate cyber defense proficiency.',
            'badge' => '🛡',
            'xp' => 200,
        ],
        [
            'title' => 'Academy Master',
            'description' => 'Complete 5 Cyber Academy courses.',
            'badge' => '📚',
            'xp' => 200,
        ],
        [
            'title' => 'Speed Analyst',
            'description' => 'Complete an investigation in under 5 minutes.',
            'badge' => '⚡',
            'xp' => 200,
        ],
        [
            'title' => 'Seven-Day Streak',
            'description' => 'Maintain a 7-day daily activity streak.',
            'badge' => '🔥',
            'xp' => 200,
        ],
        [
            'title' => 'Threat Specialist',
            'description' => 'Reach Level 5 and become a certified threat specialist.',
            'badge' => '🚨',
            'xp' => 200,
        ],
        [
            'title' => 'Forensic Expert',
            'description' => 'Earn 5,000+ XP and achieve mastery in digital forensics.',
            'badge' => '🧠',
            'xp' => 200,
        ],
    ];
}

/**
 * Seed achievement rows for a user if they don't exist yet.
 */
function seedAchievements(PDO $pdo, int $userId): void
{
    $definitions = getAchievementDefinitions();

    foreach ($definitions as $def) {
        $stmt = $pdo->prepare("
            SELECT id FROM achievements
            WHERE user_id = :user_id AND title = :title
        ");
        $stmt->execute(['user_id' => $userId, 'title' => $def['title']]);

        if (!$stmt->fetch()) {
            $ins = $pdo->prepare("
                INSERT INTO achievements (user_id, title, description, badge, xp, unlocked)
                VALUES (:user_id, :title, :description, :badge, :xp, FALSE)
            ");
            $ins->execute([
                'user_id' => $userId,
                'title' => $def['title'],
                'description' => $def['description'],
                'badge' => $def['badge'],
                'xp' => $def['xp'],
            ]);
        }
    }
}

/**
 * Get all achievements for a user.
 */
function getAchievements(PDO $pdo, int $userId): array
{
    seedAchievements($pdo, $userId);

    $stmt = $pdo->prepare("
        SELECT id, user_id, title, description, badge, xp, unlocked, unlocked_at, created_at
        FROM achievements
        WHERE user_id = :user_id
        ORDER BY unlocked DESC, id ASC
    ");
    $stmt->execute(['user_id' => $userId]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
