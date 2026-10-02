import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
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
    final scenario = state.scenario;
    final attempt = state.attempt;
    final handoff = state.investigationHandoff;

    if (scenario == null || attempt == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isSuccess = state.isSuccess;
    final score = attempt.score;
    final passingScore = scenario.passingScore;
    final xpAwarded = state.xpAwarded;

    final mins = state.secondsElapsed ~/ 60;
    final secs = state.secondsElapsed % 60;
    final timeStr = '${mins}m ${secs}s';

    final resultColor = isSuccess ? Colors.green : Colors.redAccent;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Incident Debrief',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.go(RouteConstants.simulation),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── 1. Result Icon & Title ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: resultColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: resultColor, width: 2.5),
                ),
                child: Icon(
                  isSuccess
                      ? Icons.verified_user_rounded
                      : Icons.warning_amber_rounded,
                  size: 44,
                  color: resultColor,
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

              const SizedBox(height: AppSpacing.md),

              Text(
                isSuccess
                    ? 'INCIDENT CONTAINED SUCCESSFULLY'
                    : 'CONTAINMENT FAILURE DECLARED',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: resultColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                scenario.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── 2. Performance Stats Grid ──
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(color: foren.borderSubtle),
                ),
                child: Row(
                  children: [
                    // Score
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$score / 100',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: resultColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Pass: $passingScore pts',
                            style: TextStyle(
                              fontSize: 10,
                              color: foren.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: foren.borderSubtle,
                    ),

                    // XP Earned
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '+$xpAwarded XP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color:
                                  xpAwarded > 0
                                      ? foren.academy.t500
                                      : foren.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            xpAwarded > 0 ? 'Awarded' : 'Previously Claimed',
                            style: TextStyle(
                              fontSize: 10,
                              color: foren.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: foren.borderSubtle,
                    ),

                    // Time
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Duration',
                            style: TextStyle(
                              fontSize: 10,
                              color: foren.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── 3. Investigation Handoff Bridge Card (Step 14) ──
              if (handoff != null && handoff.caseId != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        foren.investigation.t500.withValues(alpha: 0.12),
                        primaryColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppRadius.borderRadiusLg,
                    border: Border.all(
                      color: foren.investigation.t500.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: foren.investigation.t500.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: AppRadius.borderRadiusSm,
                            ),
                            child: Icon(
                              Icons.sync_alt_rounded,
                              size: 16,
                              color: foren.investigation.t500,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'INVESTIGATION LAB HANDOFF',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: foren.investigation.t500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'This incident has generated forensic artifacts linked to Investigation Case ${handoff.caseTitle ?? handoff.caseId}. Transfer the recovered artifacts into the Investigation Lab for deeper examination and final verdict submission.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            context.push('${RouteConstants.caseDetail}/${handoff.caseId}');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: foren.investigation.t500,
                          ),
                          icon: const Icon(Icons.fingerprint_rounded, size: 18),
                          label: Text(
                            'Examine Case: ${handoff.caseTitle ?? handoff.caseId}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ── 4. Decision Audit Trail Timeline ──
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DECISION AUDIT TRAIL (${attempt.selectedActions.length})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: foren.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              if (attempt.selectedActions.isEmpty) ...[
                Text(
                  'No decision records captured for this attempt.',
                  style: TextStyle(color: foren.textSecondary, fontSize: 12),
                ),
              ] else ...[
                ...attempt.selectedActions.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final act = entry.value;

                  Color dotColor;
                  if (act.scoreDelta > 0) {
                    dotColor = Colors.green;
                  } else if (act.scoreDelta < 0) {
                    dotColor = Colors.redAccent;
                  } else {
                    dotColor = Colors.amber;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppRadius.borderRadiusMd,
                      border: Border.all(color: foren.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: dotColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${idx + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: dotColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                act.actionLabel,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (act.scoreDelta != 0)
                              Text(
                                act.scoreDelta > 0
                                    ? '+${act.scoreDelta} pts'
                                    : '${act.scoreDelta} pts',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: dotColor,
                                ),
                              ),
                          ],
                        ),
                        if (act.consequence.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            act.consequence,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: foren.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: AppSpacing.lg),

              // ── 5. Action Buttons ──
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.go(RouteConstants.simulation);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: foren.borderSubtle),
                      ),
                      child: Text(
                        'Simulation Hub',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ref
                            .read(simulationRunnerProvider(scenarioId).notifier)
                            .restartScenario();
                        context.go(
                          '${RouteConstants.simulationRun}/$scenarioId',
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: primaryColor,
                      ),
                      child: const Text('Replay Scenario'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
