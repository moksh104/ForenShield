import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/achievement_model.dart';
import 'achievement_badge.dart';

/// Modal dialog shown when an achievement is tapped or newly unlocked.
class AchievementDialog extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementDialog({super.key, required this.achievement});

  static Future<void> show(BuildContext context, AchievementModel achievement) {
    return showDialog(
      context: context,
      builder: (_) => AchievementDialog(achievement: achievement),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: achievement.unlocked
              ? theme.colorScheme.primary.withValues(alpha: 0.4)
              : foren.borderDefault,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge
            AchievementBadge(
              badge: achievement.badge,
              unlocked: achievement.unlocked,
              size: 80,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              achievement.unlocked
                  ? '🏆 Achievement Unlocked!'
                  : '🔒 Locked Achievement',
              style: TextStyle(
                color: achievement.unlocked
                    ? theme.colorScheme.primary
                    : foren.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Description
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: foren.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // XP Reward
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: achievement.unlocked
                    ? foren.success.t500.withValues(alpha: 0.15)
                    : foren.surfaceRaised1,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: achievement.unlocked
                      ? foren.success.t500.withValues(alpha: 0.4)
                      : foren.borderSubtle,
                ),
              ),
              child: Text(
                '+${achievement.xp} XP Reward',
                style: TextStyle(
                  color: achievement.unlocked
                      ? foren.success.t300
                      : foren.textDisabled,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // Unlocked date
            if (achievement.unlocked && achievement.unlockedAt != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Unlocked ${achievement.unlockedAt!.toLocal().toString().split('.')[0]}',
                style: TextStyle(
                  color: foren.textDisabled,
                  fontSize: 11,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
