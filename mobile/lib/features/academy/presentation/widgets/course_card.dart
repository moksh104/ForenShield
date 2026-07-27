import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/course_entity.dart';

/// Reusable Course Card for Cyber Academy list.
class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback? onTap;
  final VoidCallback? onContinueTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;
    final primaryColor = theme.colorScheme.primary;
    final diffColor = _getDifficultyColor(foren, course.difficulty);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: foren.borderSubtle.withValues(alpha: 0.4),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: academyColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Text(
                        course.category.toUpperCase(),
                        style: TextStyle(
                          color: academyColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: diffColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Text(
                        course.difficulty.toUpperCase(),
                        style: TextStyle(
                          color: diffColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.schedule_outlined,
                      size: 13,
                      color: foren.textDisabled,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.durationMinutes} min',
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Course Title
                Text(
                  course.title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  course.description,
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                // Progress Bar & CTA
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
                                '${(course.completionPercentage * 100).toInt()}% Completed',
                                style: TextStyle(
                                  color: foren.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '+${course.totalXp} XP',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: AppRadius.borderRadiusXs,
                            child: LinearProgressIndicator(
                              value: course.completionPercentage,
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
                    ElevatedButton(
                      onPressed: onContinueTap ?? onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: academyColor,
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
                        course.completionPercentage > 0
                            ? 'Continue'
                            : 'Start',
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
        ),
      ),
    );
  }

  Color _getDifficultyColor(ForenColors foren, String diff) {
    switch (diff.toLowerCase()) {
      case 'advanced':
        return foren.critical.t500;
      case 'intermediate':
        return foren.warning.t500;
      case 'beginner':
      default:
        return foren.success.t500;
    }
  }
}
