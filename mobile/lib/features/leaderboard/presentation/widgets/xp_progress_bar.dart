import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/xp_config.dart';

/// Animated linear progress bar showing XP toward next level.
class XpProgressBar extends StatelessWidget {
  final int xp;
  final bool showLabels;

  const XpProgressBar({super.key, required this.xp, this.showLabels = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final level = XpConfig.levelForXp(xp);
    final progress = XpConfig.progressToNextLevel(xp);
    final nextLevelXp = XpConfig.xpForNextLevel(xp);
    final isMaxLevel = nextLevelXp == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabels) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $level',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                isMaxLevel ? 'MAX LEVEL' : 'Level ${level + 1}',
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: foren.surfaceRaised1,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              );
            },
          ),
        ),
        if (showLabels) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            isMaxLevel
                ? '$xp XP — Maximum Level Reached!'
                : '$xp / $nextLevelXp XP',
            style: TextStyle(color: foren.textSecondary, fontSize: 11),
          ),
        ],
      ],
    );
  }
}
