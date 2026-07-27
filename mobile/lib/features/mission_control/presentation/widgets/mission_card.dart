import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Today's Mission Card displaying mission title, estimated time, difficulty, progress, and a action button.
class MissionCard extends StatelessWidget {
  final String title;
  final int estimatedMinutes;
  final String difficulty;
  final double progress;
  final bool isCompleted;
  final VoidCallback? onContinueTap;

  const MissionCard({
    super.key,
    required this.title,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.progress,
    this.isCompleted = false,
    this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final diffColor = _getDifficultyColor(foren, difficulty);

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
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderRadiusXs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag_outlined,
                          size: 12, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'TODAY\'S MISSION',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: diffColor.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusXs,
                  ),
                  child: Text(
                    difficulty.toUpperCase(),
                    style: TextStyle(
                      color: diffColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 13,
                  color: foren.textDisabled,
                ),
                const SizedBox(width: 4),
                Text(
                  '$estimatedMinutes min estimated',
                  style: TextStyle(
                    color: foren.textDisabled,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Progress Bar & Action Button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}% Completed',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: AppRadius.borderRadiusXs,
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: foren.surfaceRaised1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ElevatedButton(
                  onPressed: onContinueTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 8,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isCompleted ? 'Review' : 'Continue',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(ForenColors foren, String diff) {
    switch (diff.toLowerCase()) {
      case 'hard':
      case 'expert':
        return foren.critical.t500;
      case 'medium':
        return foren.warning.t500;
      case 'easy':
      default:
        return foren.success.t500;
    }
  }
}
