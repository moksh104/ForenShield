import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/achievement_model.dart';
import 'achievement_badge.dart';

/// Individual achievement card with badge, title, XP, and locked/unlocked state.
class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: achievement.unlocked
              ? theme.colorScheme.surface
              : foren.surfaceRaised1.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: achievement.unlocked
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : foren.borderSubtle,
          ),
          boxShadow: achievement.unlocked
              ? [
                  BoxShadow(
                    color:
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AchievementBadge(
              badge: achievement.badge,
              unlocked: achievement.unlocked,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: achievement.unlocked
                    ? theme.colorScheme.onSurface
                    : foren.textDisabled,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: achievement.unlocked
                    ? foren.success.t500.withValues(alpha: 0.15)
                    : foren.surfaceRaised2.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${achievement.xp} XP',
                style: TextStyle(
                  color: achievement.unlocked
                      ? foren.success.t300
                      : foren.textDisabled,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
