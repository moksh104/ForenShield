import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
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
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Geist',
          ),
        ),
      ),
      body: ParticleBackground(
        numberOfParticles: 40,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: Stack(
          children: [
            const Positioned.fill(child: BackgroundGrid()),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    // Success Icon Gauge with Pulsating Glow
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: GlowEffect(
                        glowColor: foren.success.t500,
                        blurRadius: 24,
                        animate: true,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
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
                      ),
                    )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.easeOutBack),

                    const SizedBox(height: AppSpacing.md),

                    Text(
                      'MISSION ACCOMPLISHED',
                      style: TextStyle(
                        color: foren.success.t500,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                      ),
                    )
                        .animate(delay: 150.ms)
                        .fadeIn(duration: 400.ms),

                    const SizedBox(height: 4),

                    Text(
                      scenario.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Geist',
                      ),
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 400.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Score Summary Stats Row
                    GlassEffect(
                      blurX: 16.0,
                      blurY: 16.0,
                      opacity: 0.12,
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
                              color: AppColors.logoGold,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: 300.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: AppSpacing.lg),

                    // Incident Remediation Summary Card
                    GlassEffect(
                      blurX: 14.0,
                      blurY: 14.0,
                      opacity: 0.10,
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
                              'INCIDENT REMEDIATION REPORT',
                              style: TextStyle(
                                color: foren.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const _ReportBullet(
                              text: 'Malicious outbound connection on port 4444 analyzed.',
                            ),
                            const _ReportBullet(
                              text: 'PID 4092 (ransomware_agent) terminated cleanly.',
                            ),
                            const _ReportBullet(
                              text: 'Emergency firewall DROP rule applied to port 4444.',
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

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
                        label: const Text(
                          'BACK TO MISSION CONTROL',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                        .animate(delay: 500.ms)
                        .fadeIn(duration: 400.ms),

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
                        label: const Text(
                          'RETRY SCENARIO LAB',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                        .animate(delay: 550.ms)
                        .fadeIn(duration: 400.ms),
                  ],
                ),
              ),
            ),
          ],
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
            fontFamily: 'Geist',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).extension<ForenColors>()!.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
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
