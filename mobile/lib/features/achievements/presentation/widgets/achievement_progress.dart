import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Linear progress bar for achievement unlock progress (e.g., 3/5 investigations).
class AchievementProgress extends StatelessWidget {
  final int current;
  final int target;
  final String label;

  const AchievementProgress({
    super.key,
    required this.current,
    required this.target,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final isComplete = current >= target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: foren.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              isComplete ? '✅ Complete' : '$current / $target',
              style: TextStyle(
                color: isComplete
                    ? foren.success.t300
                    : theme.colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: foren.surfaceRaised1,
                valueColor: AlwaysStoppedAnimation(
                  isComplete
                      ? foren.success.t500
                      : theme.colorScheme.primary,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
