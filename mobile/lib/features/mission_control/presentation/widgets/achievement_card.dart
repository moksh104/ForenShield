import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/mission_control_entity.dart';

/// Achievement and Level Progress Card.
class AchievementCard extends StatelessWidget {
  final int currentLevel;
  final int currentXp;
  final int nextLevelXp;
  final List<AchievementItem> achievements;
  final VoidCallback? onViewAllTap;

  const AchievementCard({
    super.key,
    required this.currentLevel,
    required this.currentXp,
    required this.nextLevelXp,
    required this.achievements,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final warningColor = foren.warning.t500;

    final levelProgress =
        (nextLevelXp > 0) ? (currentXp / nextLevelXp).clamp(0.0, 1.0) : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: foren.borderSubtle.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level progress header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: warningColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.military_tech,
                        size: 16,
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LEVEL $currentLevel SPECIALIST',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '$currentXp / $nextLevelXp XP to Level ${currentLevel + 1}',
                          style: TextStyle(
                            color: foren.textDisabled,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: onViewAllTap,
                  child: Text(
                    'Wall',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: AppRadius.borderRadiusXs,
              child: LinearProgressIndicator(
                value: levelProgress,
                minHeight: 6,
                backgroundColor: foren.surfaceRaised1,
                valueColor: AlwaysStoppedAnimation<Color>(
                  warningColor,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unlocked Badges & Rewards',
              style: TextStyle(
                color: foren.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Badges row
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: achievements.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = achievements[index];
                  return _BadgeItem(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final AchievementItem item;

  const _BadgeItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final warningColor = foren.warning.t500;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: foren.surfaceRaised1,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: item.isUnlocked
              ? warningColor.withValues(alpha: 0.4)
              : foren.borderSubtle.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.isUnlocked
                  ? warningColor.withValues(alpha: 0.15)
                  : foren.surfaceRaised2,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isUnlocked ? Icons.verified : Icons.lock_outline,
              color: item.isUnlocked
                  ? warningColor
                  : foren.textDisabled,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: item.isUnlocked
                        ? theme.colorScheme.onSurface
                        : foren.textDisabled,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '+${item.xpReward} XP',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
