import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/simulation_action_result_model.dart';
import '../domain/entities/investigation_handoff.dart';
import '../domain/entities/simulation_attempt.dart';
import '../domain/entities/simulation_node.dart';
import '../domain/entities/simulation_scenario.dart';
import '../providers/simulation_provider.dart';

class SimulationRunnerState {
  final SimulationScenario? scenario;
  final SimulationAttempt? attempt;
  final SimulationNode? currentNode;
  final List<Map<String, dynamic>> discoveredEvidence;
  final SimulationActionResult? lastActionResult;
  final InvestigationHandoff? investigationHandoff;
  final int secondsElapsed;
  final bool isLoading;
  final String? errorMessage;
  final bool isCompleted;
  final bool isSuccess;
  final int xpAwarded;

  const SimulationRunnerState({
    this.scenario,
    this.attempt,
    this.currentNode,
    this.discoveredEvidence = const [],
    this.lastActionResult,
    this.investigationHandoff,
    this.secondsElapsed = 0,
    this.isLoading = false,
    this.errorMessage,
    this.isCompleted = false,
    this.isSuccess = false,
    this.xpAwarded = 0,
  });

  int get score => attempt?.score ?? 100;

  SimulationRunnerState copyWith({
    SimulationScenario? scenario,
    SimulationAttempt? attempt,
    SimulationNode? currentNode,
    List<Map<String, dynamic>>? discoveredEvidence,
    SimulationActionResult? lastActionResult,
    InvestigationHandoff? investigationHandoff,
    int? secondsElapsed,
    bool? isLoading,
    String? errorMessage,
    bool? isCompleted,
    bool? isSuccess,
    int? xpAwarded,
  }) {
    return SimulationRunnerState(
      scenario: scenario ?? this.scenario,
      attempt: attempt ?? this.attempt,
      currentNode: currentNode ?? this.currentNode,
      discoveredEvidence: discoveredEvidence ?? this.discoveredEvidence,
      lastActionResult: lastActionResult ?? this.lastActionResult,
      investigationHandoff: investigationHandoff ?? this.investigationHandoff,
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
      isSuccess: isSuccess ?? this.isSuccess,
      xpAwarded: xpAwarded ?? this.xpAwarded,
    );
  }
}

class SimulationRunnerNotifier extends StateNotifier<SimulationRunnerState> {
  Timer? _timer;
  final Ref _ref;
  final String _scenarioId;

  SimulationRunnerNotifier(this._ref, this._scenarioId)
    : super(const SimulationRunnerState(isLoading: true)) {
    initScenario();
  }

  Future<void> initScenario({bool forceNew = false}) async {
    _timer?.cancel();
    state = state.copyWith(isLoading: true, errorMessage: null);

    final repository = _ref.read(simulationRepositoryProvider);

    // 1. Fetch scenarios list to find metadata
    final scenariosResult = await repository.getScenarios();
    SimulationScenario? foundScenario;
    scenariosResult.when(
      success: (list) {
        foundScenario = list.cast<SimulationScenario?>().firstWhere(
          (s) => s?.id == _scenarioId,
          orElse: () => null,
        );
      },
      failure: (_) {},
    );

    // 2. Start or Resume Attempt on Backend
    final startResult = await repository.startAttempt(
      _scenarioId,
      forceNew: forceNew,
    );

    startResult.when(
      success: (data) {
        final attempt = data.attempt;
        final currentNode = data.currentNode;
        final isFinished =
            currentNode.isTerminal ||
            attempt.status == SimulationAttemptStatus.completed ||
            attempt.status == SimulationAttemptStatus.failed;

        state = SimulationRunnerState(
          scenario: foundScenario,
          attempt: attempt,
          currentNode: currentNode,
          discoveredEvidence: data.discoveredEvidence,
          secondsElapsed: 0,
          isLoading: false,
          isCompleted: isFinished,
          isSuccess:
              currentNode.isSuccess ||
              attempt.status == SimulationAttemptStatus.completed,
          xpAwarded: attempt.xpEarned,
        );

        if (!isFinished) {
          _startTimer();
        }
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceAll('Exception: ', ''),
        );
      },
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      state = state.copyWith(secondsElapsed: state.secondsElapsed + 1);
    });
  }

  Future<void> chooseAction(String actionId) async {
    final attempt = state.attempt;
    if (attempt == null || state.isCompleted || state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final repository = _ref.read(simulationRepositoryProvider);
    final result = await repository.submitAction(attempt.id, actionId);

    result.when(
      success: (actionResult) {
        // Merge newly unlocked evidence
        final existingEv = List<Map<String, dynamic>>.from(
          state.discoveredEvidence,
        );
        for (final newEv in actionResult.unlockedEvidence) {
          if (!existingEv.any((e) => e['id'] == newEv['id'])) {
            existingEv.add(newEv);
          }
        }

        final isFinished = actionResult.isFinished;
        if (isFinished) {
          _timer?.cancel();
          // Invalidate scenarios provider so completion status & XP update in main list
          _ref.invalidate(simulationScenariosProvider);
        }

        state = state.copyWith(
          attempt: actionResult.attempt,
          currentNode: actionResult.nextNode,
          lastActionResult: actionResult,
          discoveredEvidence: existingEv,
          investigationHandoff: actionResult.investigationHandoff,
          isCompleted: isFinished,
          isSuccess: actionResult.isSuccess,
          xpAwarded: actionResult.xpAwarded,
          isLoading: false,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceAll('Exception: ', ''),
        );
      },
    );
  }

  Future<void> restartScenario() async {
    await initScenario(forceNew: true);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final simulationRunnerProvider =
    StateNotifierProvider.family<
      SimulationRunnerNotifier,
      SimulationRunnerState,
      String
    >((ref, scenarioId) {
      return SimulationRunnerNotifier(ref, scenarioId);
    });
