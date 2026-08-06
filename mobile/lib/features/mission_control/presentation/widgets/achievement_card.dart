import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/mission_control_entity.dart';

/// Achievement and Level Progress Card with clean surface and count-up animations.
class AchievementCard extends StatefulWidget {
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
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final warningColor = foren.warning.t500;

    final levelProgress = (widget.nextLevelXp > 0)
        ? (widget.currentXp / widget.nextLevelXp).clamp(0.0, 1.0)
        : 1.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.4)),
        boxShadow: AppShadows.forBrightness(
          brightness: theme.brightness,
          level: ElevationLevel.low,
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
                        'Level ${widget.currentLevel} Specialist',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: widget.currentXp.toDouble(),
                        ),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOutCubic,
                        builder: (context, xpVal, child) {
                          return Text(
                            '${xpVal.toInt()} / ${widget.nextLevelXp} XP to Level ${widget.currentLevel + 1}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: foren.textDisabled,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: widget.onViewAllTap,
                child: Text(
                  'Wall',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: levelProgress),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, progressVal, child) {
                return LinearProgressIndicator(
                  value: progressVal,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(100),
                  backgroundColor: foren.surfaceRaised1,
                  valueColor: AlwaysStoppedAnimation<Color>(warningColor),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Unlocked Badges & Rewards',
            style: theme.textTheme.bodySmall?.copyWith(
              color: foren.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Badges row
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.achievements.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = widget.achievements[index];
                return _BadgeItem(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatefulWidget {
  final AchievementItem item;

  const _BadgeItem({required this.item});

  @override
  State<_BadgeItem> createState() => _BadgeItemState();
}

class _BadgeItemState extends State<_BadgeItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final warningColor = foren.warning.t500;

    return InkWell(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCirc,
        width: 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isPressed
              ? (widget.item.isUnlocked
                    ? warningColor.withValues(alpha: 0.12)
                    : foren.surfaceRaised2)
              : foren.surfaceRaised1.withValues(alpha: 0.6),
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(
            color: widget.item.isUnlocked
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
                color: widget.item.isUnlocked
                    ? warningColor.withValues(alpha: 0.15)
                    : foren.surfaceRaised2,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.item.isUnlocked ? Icons.verified : Icons.lock_outline,
                color: widget.item.isUnlocked
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
                    widget.item.title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: widget.item.isUnlocked
                          ? theme.colorScheme.onSurface
                          : foren.textDisabled,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '+${widget.item.xpReward} XP',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
