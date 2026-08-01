import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/simulation_scenario.dart';

/// Cyber Simulation Operations Center Dashboard Telemetry Header.
class SimulationDashboardHeader extends StatelessWidget {
  final List<SimulationScenario> scenarios;

  const SimulationDashboardHeader({
    super.key,
    required this.scenarios,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final totalScenarios = scenarios.length;
    final totalXp = scenarios.fold<int>(0, (sum, s) => sum + s.xpReward);
    final hardScenarios = scenarios.where((s) => s.difficulty == ScenarioDifficulty.hard || s.difficulty == ScenarioDifficulty.critical).length;
    final avgMinutes = totalScenarios > 0 ? (scenarios.fold<int>(0, (sum, s) => sum + s.estimatedMinutes) ~/ totalScenarios) : 15;

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
            // Top SOC Status Indicator Badge
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
                      'SIMULATION ENGINE · VM READY',
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
                    '$totalScenarios TRAINING LABS',
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

            // Animated Statistics Telemetry Grid Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeaderMetric(
                  label: 'TOTAL LABS',
                  value: totalScenarios.toDouble(),
                  suffix: '',
                  color: primaryColor,
                ),
                _HeaderMetric(
                  label: 'TOTAL XP',
                  value: totalXp.toDouble(),
                  suffix: ' XP',
                  color: AppColors.logoGold,
                ),
                _HeaderMetric(
                  label: 'HARD TRACKS',
                  value: hardScenarios.toDouble(),
                  suffix: '',
                  color: foren.critical.t500,
                ),
                _HeaderMetric(
                  label: 'AVG DURATION',
                  value: avgMinutes.toDouble(),
                  suffix: 'm',
                  color: foren.success.t500,
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
