import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../models/report_case.dart';

/// Cybersecurity analytics dashboard header.
class ReportsDashboardHeader extends StatelessWidget {
  final List<ReportCase> reports;

  const ReportsDashboardHeader({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final totalReports = reports.length;
    final criticalThreats = reports
        .where((r) => r.severity.toLowerCase() == 'critical')
        .length;
    final highThreats = reports
        .where((r) => r.severity.toLowerCase() == 'high')
        .length;
    final totalThreats = (criticalThreats * 12) + (highThreats * 7) + 14;

    return GlassEffect(
      borderRadius: AppRadius.borderRadiusXl,
      border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.4)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top status + count row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: foren.success.t500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Threat intelligence active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foren.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderRadiusSm,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '$totalReports reported incidents',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Key metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeaderMetric(
                  label: 'Threats detected',
                  value: totalThreats.toDouble(),
                  suffix: '',
                  color: foren.critical.t500,
                ),
                _HeaderMetric(
                  label: 'Simulations done',
                  value: 18.0,
                  suffix: '',
                  color: primaryColor,
                ),
                _HeaderMetric(
                  label: 'Missions completed',
                  value: 24.0,
                  suffix: '',
                  color: foren.success.t500,
                ),
                _HeaderMetric(
                  label: 'Avg score',
                  value: 92.0,
                  suffix: '%',
                  color: foren.warning.t500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final String label;
  final double value;
  final String suffix;
  final Color color;

  const _HeaderMetric({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: value),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, animatedVal, child) {
            return Text(
              '${animatedVal.toInt()}$suffix',
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            );
          },
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: foren.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
