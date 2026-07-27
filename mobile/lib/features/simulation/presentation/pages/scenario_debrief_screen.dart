import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../data/datasources/simulation_mock_data.dart';
import '../../providers/simulation_runner_notifier.dart';

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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Simulation Debrief',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
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

              // Success Icon Gauge
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: foren.success.t500.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: foren.success.t500,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  size: 48,
                  color: foren.success.t500,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                'MISSION ACCOMPLISHED',
                style: TextStyle(
                  color: foren.success.t500,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                scenario.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Score Summary Stats Row
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(
                    color: foren.borderSubtle.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _DebriefStat(
                      label: 'ACCURACY',
                      value: '100%',
                      color: foren.success.t500,
                    ),
                    _DebriefStat(
                      label: 'TIME SPENT',
                      value: timeStr,
                      color: primaryColor,
                    ),
                    _DebriefStat(
                      label: 'XP EARNED',
                      value: '+${scenario.xpReward}',
                      color: foren.warning.t500,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Incident Remediation Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(
                    color: foren.borderSubtle.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INCIDENT REMEDIATION REPORT',
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ReportBullet(
                      text:
                          'Malicious outbound connection on port 4444 analyzed.',
                    ),
                    _ReportBullet(
                      text:
                          'PID 4092 (ransomware_agent) terminated cleanly.',
                    ),
                    _ReportBullet(
                      text:
                          'Emergency firewall DROP rule applied to port 4444.',
                    ),
                  ],
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.dashboard_rounded),
                  label: const Text(
                    'BACK TO MISSION CONTROL',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('RETRY SCENARIO'),
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
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).extension<ForenColors>()!.textDisabled,
            fontSize: 10,
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
          Icon(Icons.check_circle_outline,
              size: 16, color: foren.success.t500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
