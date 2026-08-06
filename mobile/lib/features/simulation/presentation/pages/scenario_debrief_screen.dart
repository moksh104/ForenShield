import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../data/datasources/simulation_mock_data.dart';
import '../../providers/simulation_runner_notifier.dart';

/// Scenario Completion & Incident Remediation Debrief Screen.
class ScenarioDebriefScreen extends ConsumerWidget {
  final String scenarioId;

  const ScenarioDebriefScreen({super.key, required this.scenarioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final state = ref.watch(simulationRunnerProvider(scenarioId));

    final scenario = SimulationMockData.scenarios.firstWhere(
      (s) => s.id == scenarioId,
      orElse: () => SimulationMockData.scenarios.first,
    );

    final mins = state.secondsElapsed ~/ 60;
    final secs = state.secondsElapsed % 60;
    final timeStr = '${mins}m ${secs}s';

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Simulation Debrief',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Success icon (single celebration animation)
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: foren.success.t500.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: foren.success.t500, width: 3),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  size: 48,
                  color: foren.success.t500,
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

              const SizedBox(height: AppSpacing.md),

              Text(
                'Mission accomplished',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: foren.success.t500,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                scenario.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Score Summary Stats
              GlassEffect(
                border: Border.all(
                  color: foren.success.t500.withValues(alpha: 0.4),
                  width: 1.0,
                ),
                borderRadius: AppRadius.borderRadiusLg,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _DebriefStat(
                        label: 'Accuracy',
                        value: '100%',
                        color: foren.success.t500,
                      ),
                      _DebriefStat(
                        label: 'Time spent',
                        value: timeStr,
                        color: primaryColor,
                      ),
                      _DebriefStat(
                        label: 'XP earned',
                        value: '+${scenario.xpReward}',
                        color: foren.warning.t500,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Incident Remediation Summary
              GlassEffect(
                border: Border.all(
                  color: foren.borderSubtle.withValues(alpha: 0.4),
                  width: 1.0,
                ),
                borderRadius: AppRadius.borderRadiusLg,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Incident remediation report',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foren.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const _ReportBullet(
                        text:
                            'Malicious outbound connection on port 4444 analyzed.',
                      ),
                      const _ReportBullet(
                        text: 'PID 4092 (ransomware_agent) terminated cleanly.',
                      ),
                      const _ReportBullet(
                        text:
                            'Emergency firewall DROP rule applied to port 4444.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go(RouteConstants.missionControl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.dashboard_rounded),
                  label: Text(
                    'Back to mission control',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.scaffoldBackgroundColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(simulationRunnerProvider(scenarioId).notifier)
                        .initScenario(scenarioId);
                    context.go('${RouteConstants.simulationRun}/$scenarioId');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    'Retry scenario',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DebriefStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DebriefStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: foren.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ReportBullet extends StatelessWidget {
  final String text;

  const _ReportBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: foren.success.t500),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
