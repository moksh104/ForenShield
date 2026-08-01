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

    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final densityMatrix = [
      [1, 2, 4, 3, 2, 1, 0], // Morning
      [3, 4, 5, 4, 3, 2, 1], // Midday
      [2, 3, 4, 5, 4, 3, 2], // Evening
      [1, 1, 2, 3, 2, 1, 1], // Night
    ];

    return GlassEffect(
      blurX: 14.0,
      blurY: 14.0,
      opacity: 0.12,
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
                    const Icon(Icons.grid_on_outlined, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'INCIDENT DENSITY HEATMAP',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Text(
                  'PAST 7 DAYS',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Days Header Row
            Row(
              children: [
                const SizedBox(width: 48),
                ...days.map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
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
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 9,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ...List.generate(7, (colIdx) {
                      final level = densityMatrix[rowIdx][colIdx];
                      final cellColor = _getHeatColor(primaryColor, foren, level);

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
