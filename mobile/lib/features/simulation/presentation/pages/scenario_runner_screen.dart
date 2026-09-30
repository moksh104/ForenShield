import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../domain/entities/simulation_node.dart';
import '../../providers/simulation_runner_notifier.dart';

/// Interactive Stateful Branching Cybersecurity Simulation Runner Screen.
class ScenarioRunnerScreen extends ConsumerStatefulWidget {
  final String scenarioId;

  const ScenarioRunnerScreen({super.key, required this.scenarioId});

  @override
  ConsumerState<ScenarioRunnerScreen> createState() =>
      _ScenarioRunnerScreenState();
}

class _ScenarioRunnerScreenState extends ConsumerState<ScenarioRunnerScreen> {
  String _formatTime(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _showRestartConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusLg,
              side: BorderSide(color: foren.borderSubtle),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.restart_alt_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Restart Incident?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: Text(
              'This will abandon your current simulation state and restart from the initial incident brief.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ref
                      .read(simulationRunnerProvider(widget.scenarioId).notifier)
                      .restartScenario();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text('Restart'),
              ),
            ],
          ),
    );
  }

  void _showEvidencePreview(
    BuildContext context,
    Map<String, dynamic> evidence,
  ) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: foren.investigation.t500.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusSm,
                      ),
                      child: Icon(
                        Icons.fingerprint_rounded,
                        color: foren.investigation.t500,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evidence['title'] ?? 'Forensic Artifact',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Type: ${(evidence['evidence_type'] ?? 'log').toString().toUpperCase()}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: foren.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(color: foren.borderSubtle),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      evidence['content_text'] ??
                          'Evidence data collected during simulation investigation.',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Close Artifact'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final state = ref.watch(simulationRunnerProvider(widget.scenarioId));
    final notifier = ref.read(
      simulationRunnerProvider(widget.scenarioId).notifier,
    );

    // Auto-navigate to debrief when completed
    ref.listen(
      simulationRunnerProvider(widget.scenarioId).select((s) => s.isCompleted),
      (_, isDone) {
        if (isDone) {
          context.go('${RouteConstants.simulationDebrief}/${widget.scenarioId}');
        }
      },
    );

    if (state.isLoading && state.currentNode == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => context.pop(),
          ),
          title: const Text('Loading Incident...'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Initializing isolated sandboxed environment...',
                style: TextStyle(color: foren.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    if (state.errorMessage != null && state.currentNode == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Simulation Error',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: foren.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => notifier.initScenario(forceNew: true),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry Incident'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentNode = state.currentNode;
    final scenario = state.scenario;
    final score = state.score;

    Color scoreColor;
    if (score >= 85) {
      scoreColor = Colors.green;
    } else if (score >= 70) {
      scoreColor = Colors.amber.shade700;
    } else {
      scoreColor = Colors.redAccent;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          scenario?.title ?? 'Incident Simulation',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          // Live Score Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderRadiusSm,
                border: Border.all(color: scoreColor.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.security_rounded, size: 13, color: scoreColor),
                  const SizedBox(width: 4),
                  Text(
                    '$score pts',
                    style: TextStyle(
                      color: scoreColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),

          // Timer
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.borderRadiusSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 13, color: primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(state.secondsElapsed),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),

          // Restart Action
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded, size: 20),
            tooltip: 'Restart Incident',
            onPressed: () => _showRestartConfirmation(context),
          ),
        ],
      ),
      body: SafeArea(
        child:
            currentNode == null
                ? const SizedBox.shrink()
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 1. Node Header & Narrative Card ──
                      _buildNarrativeCard(context, currentNode, foren),

                      const SizedBox(height: AppSpacing.md),

                      // ── 2. Context Data / IOC Telemetry ──
                      if (currentNode.contextData.isNotEmpty) ...[
                        _buildContextTelemetryCard(
                          context,
                          currentNode.contextData,
                          foren,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // ── 3. Forensic Evidence Discovered ──
                      if (state.discoveredEvidence.isNotEmpty) ...[
                        _buildDiscoveredEvidenceSection(
                          context,
                          state.discoveredEvidence,
                          foren,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // ── 4. Consequence Alert from Last Action ──
                      if (state.lastActionResult != null) ...[
                        _buildConsequenceAlert(
                          context,
                          state.lastActionResult!,
                          foren,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // ── 5. Action Choices / Decision Engine ──
                      if (!currentNode.isTerminal) ...[
                        _buildDecisionSection(
                          context,
                          currentNode.availableActions,
                          state.isLoading,
                          notifier,
                          foren,
                        ),
                      ] else ...[
                        // Terminal Node CTA
                        _buildTerminalResolutionCTA(context, currentNode),
                      ],

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildNarrativeCard(
    BuildContext context,
    SimulationNode node,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    String typeBadge;
    Color typeColor;

    switch (node.type) {
      case SimulationNodeType.incidentStart:
        typeBadge = 'INCIDENT BRIEF';
        typeColor = primaryColor;
        break;
      case SimulationNodeType.investigation:
        typeBadge = 'INVESTIGATION';
        typeColor = foren.investigation.t500;
        break;
      case SimulationNodeType.decision:
        typeBadge = 'DECISION REQUIRED';
        typeColor = Colors.amber.shade700;
        break;
      case SimulationNodeType.containment:
        typeBadge = 'PERIMETER CONTAINMENT';
        typeColor = Colors.deepOrange;
        break;
      case SimulationNodeType.resolution:
        typeBadge = 'INCIDENT RESOLUTION';
        typeColor = Colors.green;
        break;
      case SimulationNodeType.failure:
        typeBadge = 'CONTAINMENT FAILURE';
        typeColor = Colors.red;
        break;
      default:
        typeBadge = 'INCIDENT STAGE';
        typeColor = primaryColor;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: foren.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderRadiusXs,
                  border: Border.all(color: typeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  typeBadge,
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.shield_outlined, size: 16, color: foren.textSecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            node.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            node.narrative,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextTelemetryCard(
    BuildContext context,
    Map<String, dynamic> contextData,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: foren.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.terminal_rounded,
                size: 15,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'INCIDENT TELEMETRY / IOCs',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...contextData.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: foren.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value.toString(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDiscoveredEvidenceSection(
    BuildContext context,
    List<Map<String, dynamic>> evidenceList,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.fingerprint_rounded,
              size: 16,
              color: foren.investigation.t500,
            ),
            const SizedBox(width: 6),
            Text(
              'DISCOVERED EVIDENCE (${evidenceList.length})',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: foren.investigation.t500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: evidenceList.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final ev = evidenceList[index];
              return ActionChip(
                backgroundColor: theme.colorScheme.surface,
                side: BorderSide(
                  color: foren.investigation.t500.withValues(alpha: 0.3),
                ),
                avatar: Icon(
                  Icons.insert_drive_file_outlined,
                  size: 14,
                  color: foren.investigation.t500,
                ),
                label: Text(
                  ev['title'] ?? 'Artifact ${index + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onPressed: () => _showEvidencePreview(context, ev),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConsequenceAlert(
    BuildContext context,
    dynamic lastActionResult,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);
    final delta = lastActionResult.scoreDelta as int;
    final isNegative = delta < 0;
    final color = isNegative ? Colors.redAccent : Colors.green;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isNegative ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                'ACTION OUTCOME ${delta != 0 ? "(${delta > 0 ? '+$delta' : delta} pts)" : ""}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            lastActionResult.consequence as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionSection(
    BuildContext context,
    List<SimulationAction> actions,
    bool isLoading,
    SimulationRunnerNotifier notifier,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.touch_app_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'SELECT ACTION / DECISION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...actions.map((act) {
          Color safetyColor;
          String safetyLabel;
          switch (act.safety) {
            case SimulationActionSafety.safe:
              safetyColor = Colors.green;
              safetyLabel = 'SAFE';
              break;
            case SimulationActionSafety.caution:
              safetyColor = Colors.amber.shade700;
              safetyLabel = 'CAUTION';
              break;
            case SimulationActionSafety.critical:
              safetyColor = Colors.redAccent;
              safetyLabel = 'CRITICAL RISK';
              break;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : () => notifier.chooseAction(act.id),
                borderRadius: AppRadius.borderRadiusMd,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(
                      color: safetyColor.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: safetyColor.withValues(alpha: 0.12),
                              borderRadius: AppRadius.borderRadiusXs,
                            ),
                            child: Text(
                              safetyLabel,
                              style: TextStyle(
                                color: safetyColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: AppRadius.borderRadiusXs,
                            ),
                            child: Text(
                              act.actionType.toUpperCase(),
                              style: TextStyle(
                                color: foren.textSecondary,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: foren.textDisabled,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        act.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        act.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: foren.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTerminalResolutionCTA(
    BuildContext context,
    SimulationNode currentNode,
  ) {
    final theme = Theme.of(context);
    final isSuccess = currentNode.isSuccess;
    final color = isSuccess ? Colors.green : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(
            isSuccess
                ? Icons.check_circle_rounded
                : Icons.cancel_outlined,
            size: 40,
            color: color,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isSuccess ? 'Scenario Completed!' : 'Scenario Failed',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isSuccess
                ? 'Your incident response decisions have been authoritatively evaluated by the ForenShield engine.'
                : 'Containment parameters failed. Review decision post-mortem in debrief.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.go(
                  '${RouteConstants.simulationDebrief}/${widget.scenarioId}',
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.assessment_rounded, size: 18),
              label: const Text(
                'View Incident Debrief & Forensics',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
