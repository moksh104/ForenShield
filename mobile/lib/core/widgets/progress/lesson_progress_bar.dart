import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_motion.dart';

/// A segmented progress bar designed for lessons or step-by-step modules.
class LessonProgressBar extends StatelessWidget {
  /// The total number of steps/lessons.
  final int totalSteps;

  /// The number of completed steps/lessons.
  final int completedSteps;

  const LessonProgressBar({
    super.key,
    required this.totalSteps,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < completedSteps;
        final isCurrent = index == completedSteps;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == totalSteps - 1 ? 0.0 : AppSpacing.xs,
            ),
            child: AnimatedContainer(
              duration: AppMotion.normal,
              height: 6,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? AppColors.primary 
                    : (isCurrent ? AppColors.primary.withValues(alpha: 0.5) : AppColors.surfaceVariant),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      }),
    );
  }
}
