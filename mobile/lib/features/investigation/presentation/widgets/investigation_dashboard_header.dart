import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/investigation_entity.dart';
import '../pages/case_list_screen.dart';

/// Digital Forensics Command Center Dashboard Header.
class InvestigationDashboardHeader extends StatelessWidget {
  final List<InvestigationEntity> cases;

  const InvestigationDashboardHeader({
    super.key,
    required this.cases,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final totalCases = cases.length;
    final criticalCases = cases.where((c) => c.priority.toLowerCase() == 'critical').length;
    final totalEvidence = cases.fold<int>(0, (sum, c) => sum + c.evidenceList.length);
    final solvedCases = cases.where((c) => c.status.toLowerCase() == 'solved' || c.status.toLowerCase() == 'completed').length;
    final solveRatePercent = totalCases > 0 ? ((solvedCases / totalCases) * 100).toInt() : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GlassEffect(
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
              // Top SOC Telemetry Badge Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (CaseListScreen.enableAdvancedEffects)
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
                        )
                      else
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: foren.success.t500,
                            shape: BoxShape.circle,
                          ),
                        ),
                      const SizedBox(width: 8),
                      const Text(
                        'SOC FORENSIC WORKSTATION · ACTIVE',
                        style: TextStyle(
                          color: AppColors.logoGold,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
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
                      '$totalCases ACTIVE INVESTIGATIONS',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Animated Statistics Telemetry Grid Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _HeaderMetric(
                    label: 'TOTAL CASES',
                    value: totalCases.toDouble(),
                    suffix: '',
                    color: primaryColor,
                  ),
                  _HeaderMetric(
                    label: 'CRITICAL THREATS',
                    value: criticalCases.toDouble(),
                    suffix: '',
                    color: foren.critical.t500,
                  ),
                  _HeaderMetric(
                    label: 'EVIDENCE ARTIFACTS',
                    value: totalEvidence.toDouble(),
                    suffix: '',
                    color: AppColors.logoGold,
                  ),
                  _HeaderMetric(
                    label: 'SOLVED RATE',
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
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, animatedVal, child) {
            return Text(
              '${animatedVal.toInt()}$suffix',
              style: TextStyle(
                color: color,
                fontSize: 18,
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
