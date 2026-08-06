import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/investigation_entity.dart';

/// Digital Forensics Investigation Lab header with summary metrics.
class InvestigationDashboardHeader extends StatelessWidget {
  final List<InvestigationEntity> cases;

  const InvestigationDashboardHeader({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final totalCases = cases.length;
    final criticalCases = cases
        .where((c) => c.priority.toLowerCase() == 'critical')
        .length;
    final totalEvidence = cases.fold<int>(
      0,
      (sum, c) => sum + c.evidenceList.length,
    );
    final solvedCases = cases
        .where(
          (c) =>
              c.status.toLowerCase() == 'solved' ||
              c.status.toLowerCase() == 'completed',
        )
        .length;
    final solveRatePercent = totalCases > 0
        ? ((solvedCases / totalCases) * 100).toInt()
        : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GlassEffect(
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
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Workstation online',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foren.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
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
                      '$totalCases active investigations',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Summary metrics grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _HeaderMetric(
                    label: 'Total cases',
                    value: totalCases.toDouble(),
                    suffix: '',
                    color: primaryColor,
                  ),
                  _HeaderMetric(
                    label: 'Critical',
                    value: criticalCases.toDouble(),
                    suffix: '',
                    color: foren.critical.t500,
                  ),
                  _HeaderMetric(
                    label: 'Evidence',
                    value: totalEvidence.toDouble(),
                    suffix: '',
                    color: foren.warning.t500,
                  ),
                  _HeaderMetric(
                    label: 'Solved rate',
                    value: solveRatePercent.toDouble(),
                    suffix: '%',
                    color: foren.success.t500,
                  ),
                ],
              ),
            ],
          ),
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
