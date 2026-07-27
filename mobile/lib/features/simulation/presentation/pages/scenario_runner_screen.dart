import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/progress/lesson_progress_bar.dart';
import '../../../../routes/route_constants.dart';
import '../../providers/simulation_runner_notifier.dart';
import '../widgets/objective_checklist_widget.dart';
import '../widgets/terminal_console_widget.dart';

class ScenarioRunnerScreen extends ConsumerWidget {
  final String scenarioId;

  const ScenarioRunnerScreen({super.key, required this.scenarioId});

  String _formatTime(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final state = ref.watch(simulationRunnerProvider(scenarioId));
    final notifier = ref.read(simulationRunnerProvider(scenarioId).notifier);

    // Automatically navigate to debrief screen when all objectives completed
    ref.listen(
      simulationRunnerProvider(scenarioId).select((s) => s.isCompleted),
      (_, isDone) {
        if (isDone) {
          context.go('${RouteConstants.simulationDebrief}/$scenarioId');
        }
      },
    );

    final scenario = state.scenario;
    if (scenario == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          scenario.title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(state.secondsElapsed),
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
              child: LessonProgressBar(
                totalSteps: state.objectives.length,
                completedSteps: state.completedObjectivesCount,
              ),
            ),

            // Main Content Area
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 768;

                  if (isWide) {
                    // Desktop Split View
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: TerminalConsoleWidget(
                              lines: state.terminalLines,
                              onCommandSubmitted: notifier.executeCommand,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            flex: 4,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ObjectiveChecklistWidget(
                                    objectives: state.objectives,
                                    onQuickCommandTap: notifier.executeCommand,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: notifier.completeLabManually,
                                      icon: const Icon(Icons.check_circle_outline),
                                      label: const Text('FORCE COMPLETE LAB'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Mobile Stack View
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: TerminalConsoleWidget(
                            lines: state.terminalLines,
                            onCommandSubmitted: notifier.executeCommand,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: ObjectiveChecklistWidget(
                              objectives: state.objectives,
                              onQuickCommandTap: notifier.executeCommand,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
