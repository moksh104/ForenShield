import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Cybersecurity Incident & Activity Density Heat Map Widget.
class SecurityHeatMapWidget extends StatelessWidget {
  const SecurityHeatMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final densityMatrix = [
      [1, 2, 4, 3, 2, 1, 0], // Morning
      [3, 4, 5, 4, 3, 2, 1], // Midday
      [2, 3, 4, 5, 4, 3, 2], // Evening
      [1, 1, 2, 3, 2, 1, 1], // Night
    ];

    return GlassEffect(
      border: Border.all(
        color: primaryColor.withValues(alpha: 0.35),
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusLg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.grid_on_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Incident density',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Past 7 days',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foren.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Days Header Row
            Row(
              children: [
                const SizedBox(width: AppSpacing.xxxl),
                ...days.map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foren.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Density Grid Rows
            ...List.generate(densityMatrix.length, (rowIdx) {
              final rowName = ['00:00', '06:00', '12:00', '18:00'][rowIdx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(
                        rowName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foren.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    ...List.generate(7, (colIdx) {
                      final level = densityMatrix[rowIdx][colIdx];
                      final cellColor = _getHeatColor(
                        primaryColor,
                        foren,
                        level,
                      );

                      return Expanded(
                        child: Container(
                          height: 18,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: cellColor.withValues(alpha: 0.6),
                              width: 0.5,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getHeatColor(Color primary, ForenColors foren, int level) {
    switch (level) {
      case 5:
        return foren.critical.t500;
      case 4:
        return foren.warning.t500;
      case 3:
        return primary;
      case 2:
        return primary.withValues(alpha: 0.5);
      case 1:
        return primary.withValues(alpha: 0.2);
      case 0:
      default:
        return foren.surfaceRaised1.withValues(alpha: 0.4);
    }
  }
}
