import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Continue Learning Progress Card.
class ProgressCard extends StatelessWidget {
  final String courseTitle;
  final String moduleTitle;
  final double completionPercentage;
  final String timeRemaining;
  final VoidCallback? onResumeTap;

  const ProgressCard({
    super.key,
    required this.courseTitle,
    required this.moduleTitle,
    required this.completionPercentage,
    required this.timeRemaining,
    this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;

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
                    color: academyColor.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusXs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school_outlined,
                          size: 12, color: academyColor),
                      const SizedBox(width: 4),
                      Text(
                        'CONTINUE LEARNING',
                        style: TextStyle(
                          color: academyColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  timeRemaining,
                  style: TextStyle(
                    color: foren.textDisabled,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              courseTitle,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              moduleTitle,
              style: TextStyle(
                color: foren.textSecondary,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(completionPercentage * 100).toInt()}% Course Progress',
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: AppRadius.borderRadiusXs,
                        child: LinearProgressIndicator(
                          value: completionPercentage,
                          minHeight: 5,
                          backgroundColor: foren.surfaceRaised1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            academyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                OutlinedButton(
                  onPressed: onResumeTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: academyColor,
                    side: BorderSide(color: academyColor, width: 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 8,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  child: const Text(
                    'Resume',
                    style: TextStyle(
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
}
