import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../models/report_case.dart';

/// Enterprise Cybersecurity Analytics Dashboard Header.
class ReportsDashboardHeader extends StatelessWidget {
  final List<ReportCase> reports;

  const ReportsDashboardHeader({
    super.key,
    required this.reports,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final totalReports = reports.length;
    final criticalThreats = reports.where((r) => r.severity.toLowerCase() == 'critical').length;
    final highThreats = reports.where((r) => r.severity.toLowerCase() == 'high').length;
    final totalThreats = (criticalThreats * 12) + (highThreats * 7) + 14;

    return GlassEffect(
      blurX: 16.0,
      blurY: 16.0,
      opacity: 0.12,
      border: Border.all(
        color: primaryColor.withValues(alpha: 0.4),
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusXl,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top SOC Intelligence Status Indicator Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GlowEffect(
                      glowColor: foren.success.t500,
                      blurRadius: 8,
                      animate: true,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: foren.success.t500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'CYBER THREAT INTELLIGENCE · ACTIVE',
                      style: TextStyle(
                        color: AppColors.logoGold,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusSm,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '$totalReports REPORTED INCIDENTS',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Animated Statistics Telemetry Grid Row (8 Primary Metrics)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _HeaderMetric(
                      label: 'THREATS DETECTED',
                      value: totalThreats.toDouble(),
                      suffix: '',
                      color: foren.critical.t500,
                    ),
                    _HeaderMetric(
                      label: 'SIMULATIONS DONE',
                      value: 18.0,
                      suffix: '',
                      color: primaryColor,
                    ),
                    _HeaderMetric(
                      label: 'MISSIONS COMPLETED',
                      value: 24.0,
                      suffix: '',
                      color: foren.success.t500,
                    ),
                    _HeaderMetric(
                      label: 'AVG SCORE',
                      value: 92.0,
                      suffix: '%',
                      color: AppColors.logoGold,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _HeaderMetric(
                      label: 'INVESTIGATION HRS',
                      value: 48.5,
                      suffix: 'h',
                      isDecimal: true,
                      color: primaryColor,
                    ),
                    _HeaderMetric(
                      label: 'COMPLETION RATE',
                      value: 96.0,
                      suffix: '%',
                      color: foren.success.t500,
                    ),
                    _HeaderMetric(
                      label: 'XP EARNED',
                      value: 3450.0,
                      suffix: ' XP',
                      color: AppColors.logoGold,
                    ),
                    _HeaderMetric(
                      label: 'BADGES UNLOCKED',
                      value: 8.0,
                      suffix: '',
                      color: foren.warning.t500,
                    ),
                  ],
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
  final bool isDecimal;
  final Color color;

  const _HeaderMetric({
    required this.label,
    required this.value,
    required this.suffix,
    this.isDecimal = false,
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
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, animatedVal, child) {
            final displayVal = isDecimal
                ? animatedVal.toStringAsFixed(1)
                : animatedVal.toInt().toString();

            return Text(
              '$displayVal$suffix',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'Geist',
              ),
            );
          },
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: foren.textSecondary,
            fontSize: 8,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
