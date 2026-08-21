<?php
/**
 * ForenShield — XP Service (Phase 19 — Concurrency-safe)
 *
 * awardXp() is the single authoritative entry point for all XP grants.
 *
 * Concurrency design:
 *   When refId is provided, we use INSERT ... ON CONFLICT DO NOTHING on the
 *   unique index (user_id, event_type, reference_id) rather than a SELECT-
 *   then-INSERT pattern.  This is atomic: even two concurrent requests that
 *   both pass the SELECT check cannot both INSERT, because the DB unique
 *   constraint prevents it.  We detect "duplicate" by checking affected rows.
 *
 *   Events without a refId (e.g. streak bonuses) fall through without
 *   idempotency protection, because they have no stable key to deduplicate on.
 */

require_once __DIR__ . '/rank_service.php';
require_once __DIR__ . '/streak_service.php';
require_once __DIR__ . '/achievement_engine.php';

function awardXp(PDO $pdo, int $userId, int $xpToAdd, string $reason, string $eventType, string $sourceModule, ?string $refId = null): array {
    if ($xpToAdd <= 0) {
        return ['duplicate' => false, 'xp_added' => 0, 'bonus_xp' => 0, 'new_achievements' => []];
    }

    try {
        $pdo->beginTransaction();

        // Resolve username for leaderboard init
        $uStmt = $pdo->prepare("SELECT full_name FROM users WHERE id = :uid");
        $uStmt->execute(['uid' => $userId]);
        $userRow = $uStmt->fetch(PDO::FETCH_ASSOC);
        $username = $userRow ? $userRow['full_name'] : 'Unknown';
        ensureLeaderboardEntry($pdo, $userId, $username);

        // ── Idempotency via ON CONFLICT DO NOTHING ─────────────────────────
        // The unique index idx_xp_transactions_idempotency enforces:
        //   UNIQUE(user_id, event_type, reference_id) WHERE reference_id IS NOT NULL
        // Two concurrent requests will race to INSERT; exactly one wins.

        if (!empty($refId)) {
            $stmtTx = $pdo->prepare("
                INSERT INTO xp_transactions
                    (user_id, action, xp_earned, reason, reference_id, event_type, source_module)
                VALUES
                    (:uid, :act, :xp, :reason, :ref_id, :ev_type, :src_mod)
                ON CONFLICT (user_id, event_type, reference_id)
                    WHERE reference_id IS NOT NULL
                DO NOTHING
            ");
        } else {
            $stmtTx = $pdo->prepare("
                INSERT INTO xp_transactions
                    (user_id, action, xp_earned, reason, reference_id, event_type, source_module)
                VALUES
                    (:uid, :act, :xp, :reason, :ref_id, :ev_type, :src_mod)
            ");
        }

        $stmtTx->execute([
            'uid'     => $userId,
            'act'     => 'xp_gain',
            'xp'      => $xpToAdd,
            'reason'  => $reason,
            'ref_id'  => $refId ?: null,
            'ev_type' => $eventType,
            'src_mod' => $sourceModule,
        ]);

        // rowCount() == 0 means ON CONFLICT fired — this is a duplicate
        if (!empty($refId) && $stmtTx->rowCount() === 0) {
            $pdo->rollBack();
            return ['duplicate' => true, 'xp_added' => 0, 'bonus_xp' => 0, 'new_achievements' => []];
        }

        // ── Daily activity aggregation ─────────────────────────────────────
        $dateToday   = date('Y-m-d');
        $coursesInc  = ($eventType === 'course_completed')        ? 1 : 0;
        $casesInc    = ($eventType === 'investigation_completed')  ? 1 : 0;
        $reportsInc  = ($eventType === 'report_completed')        ? 1 : 0;
        $missionsInc = ($eventType === 'mission_completed')       ? 1 : 0;

        $pdo->prepare("
            INSERT INTO daily_activity
                (user_id, date, xp_earned, courses_completed, cases_completed, reports_completed)
            VALUES
                (:uid, :dt, :xp, :c_crs, :c_cas, :c_rep)
            ON CONFLICT (user_id, date) DO UPDATE SET
                xp_earned         = daily_activity.xp_earned         + EXCLUDED.xp_earned,
                courses_completed = daily_activity.courses_completed + EXCLUDED.courses_completed,
                cases_completed   = daily_activity.cases_completed   + EXCLUDED.cases_completed,
                reports_completed = daily_activity.reports_completed + EXCLUDED.reports_completed
        ")->execute([
            'uid'   => $userId,
            'dt'    => $dateToday,
            'xp'    => $xpToAdd,
            'c_crs' => $coursesInc,
            'c_cas' => $casesInc,
            'c_rep' => $reportsInc,
        ]);

        // ── Leaderboard stats ──────────────────────────────────────────────
        $pdo->prepare("
            UPDATE leaderboard_stats
            SET total_xp                 = total_xp                 + :xp,
                courses_completed        = courses_completed        + :c_crs,
                investigations_completed = investigations_completed + :c_cas,
                reports_completed        = reports_completed        + :c_rep,
                missions_completed       = missions_completed       + :m_comp,
                last_updated             = NOW()
            WHERE user_id = :uid
        ")->execute([
            'xp'     => $xpToAdd,
            'c_crs'  => $coursesInc,
            'c_cas'  => $casesInc,
            'c_rep'  => $reportsInc,
            'm_comp' => $missionsInc,
            'uid'    => $userId,
        ]);

        // ── Legacy leaderboard table (compatibility) ───────────────────────
        $pdo->prepare("
            UPDATE leaderboard
            SET xp                = xp                + :xp,
                completed_courses = completed_courses + :c_crs,
                completed_cases   = completed_cases   + :c_cas,
                last_activity     = NOW()
            WHERE user_id = :uid
        ")->execute([
            'xp'    => $xpToAdd,
            'c_crs' => $coursesInc,
            'c_cas' => $casesInc,
            'uid'   => $userId,
        ]);

        // ── Streak ────────────────────────────────────────────────────────
        $streak = updateStreak($pdo, $userId);
        $pdo->prepare("UPDATE leaderboard_stats SET current_streak = :st WHERE user_id = :uid")
            ->execute(['st' => $streak, 'uid' => $userId]);

        // ── Achievement evaluation ─────────────────────────────────────────
        $statsStmt = $pdo->prepare("SELECT * FROM leaderboard_stats WHERE user_id = :uid");
        $statsStmt->execute(['uid' => $userId]);
        $stats = $statsStmt->fetch(PDO::FETCH_ASSOC);

        $newAchievements = evaluateAchievements($pdo, $userId, $stats);
        $bonusXp = 0;

        foreach ($newAchievements as $ach) {
            $reward = (int)$ach['xp_reward'];
            if ($reward <= 0) continue;
            $bonusXp += $reward;

            // Achievement XP: no refId, so no idempotency conflict possible here.
            // The achievement engine itself prevents duplicate unlocks.
            $pdo->prepare("
                INSERT INTO xp_transactions
                    (user_id, action, xp_earned, reason, event_type, source_module)
                VALUES
                    (:uid, 'achievement_reward', :xp, :reason, 'achievement_unlocked', 'achievements')
            ")->execute([
                'uid'    => $userId,
                'xp'     => $reward,
                'reason' => 'Unlocked ' . $ach['title'],
            ]);

            $pdo->prepare("
                UPDATE daily_activity SET xp_earned = xp_earned + :xp
                WHERE user_id = :uid AND date = :dt
            ")->execute(['xp' => $reward, 'uid' => $userId, 'dt' => $dateToday]);

            $pdo->prepare("
                UPDATE leaderboard_stats SET total_xp = total_xp + :xp WHERE user_id = :uid
            ")->execute(['xp' => $reward, 'uid' => $userId]);

            $pdo->prepare("
                UPDATE leaderboard SET xp = xp + :xp WHERE user_id = :uid
            ")->execute(['xp' => $reward, 'uid' => $userId]);
        }

        $pdo->commit();

        return [
            'duplicate'        => false,
            'xp_added'         => $xpToAdd,
            'bonus_xp'         => $bonusXp,
            'new_achievements' => array_column($newAchievements, 'title'),
        ];

    } catch (Exception $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        error_log('[awardXp] Error: ' . $e->getMessage());
        throw $e;
    }
}
