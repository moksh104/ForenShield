import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_motion.dart';

/// A specialized progress bar for tracking Experience Points (XP) towards the next level.
class XPProgressBar extends StatelessWidget {
  /// Current total XP.
  final int currentXP;

  /// XP required to reach the next level.
  final int targetXP;

  /// Current level number.
  final int currentLevel;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.targetXP,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentXP / targetXP).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $currentLevel',
              style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '$currentXP / $targetXP XP',
              style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: progress),
          duration: AppMotion.slow,
          curve: AppMotion.decelerate,
          builder: (context, value, _) {
            return Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    // Base fill
                    FractionallySizedBox(
                      widthFactor: value,
                      child: Container(color: AppColors.primary),
                    ),
                    // Shine effect
                    if (value > 0)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: FractionallySizedBox(
                          widthFactor: value,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
