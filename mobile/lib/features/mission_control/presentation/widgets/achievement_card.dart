import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/mission_control_entity.dart';

/// Achievement and Level Progress Card with glassmorphism, count-up animations, and glow effects.
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final warningColor = foren.warning.t500;

    final levelProgress =
        (widget.nextLevelXp > 0) ? (widget.currentXp / widget.nextLevelXp).clamp(0.0, 1.0) : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          child: GlassEffect(
            blurX: 16.0,
            blurY: 16.0,
            opacity: _isHovered ? 0.16 : 0.12,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(
              color: _isHovered
                  ? warningColor.withValues(alpha: 0.5)
                  : foren.borderSubtle.withValues(alpha: 0.4),
              width: _isHovered ? 1.5 : 1.0,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Level progress header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GlowEffect(
                          glowColor: warningColor,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          animate: true,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
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
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LEVEL ${widget.currentLevel} SPECIALIST',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: widget.currentXp.toDouble()),
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeOutCubic,
                              builder: (context, xpVal, child) {
                                return Text(
                                  '${xpVal.toInt()} / ${widget.nextLevelXp} XP to Level ${widget.currentLevel + 1}',
                                  style: TextStyle(
                                    color: foren.textDisabled,
                                    fontSize: 11,
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
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: levelProgress),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, progressVal, child) {
                      return LinearProgressIndicator(
                        value: progressVal,
                        minHeight: 6,
                        backgroundColor: foren.surfaceRaised1,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          warningColor,
                        ),
                      );
                    },
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
                    itemCount: widget.achievements.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = widget.achievements[index];
                      return _BadgeItem(item: item);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final warningColor = foren.warning.t500;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 160,
        padding: const EdgeInsets.all(8),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: _isHovered
              ? (widget.item.isUnlocked
                  ? warningColor.withValues(alpha: 0.12)
                  : foren.surfaceRaised2)
              : foren.surfaceRaised1.withValues(alpha: 0.6),
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(
            color: widget.item.isUnlocked
                ? ( _isHovered ? warningColor : warningColor.withValues(alpha: 0.4) )
                : foren.borderSubtle.withValues(alpha: 0.3),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: _isHovered && widget.item.isUnlocked
              ? [
                  BoxShadow(
                    color: warningColor.withValues(alpha: 0.25),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
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
                    style: TextStyle(
                      color: widget.item.isUnlocked
                          ? theme.colorScheme.onSurface
                          : foren.textDisabled,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '+${widget.item.xpReward} XP',
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
      ),
    );
  }
}
