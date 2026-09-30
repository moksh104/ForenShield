import '../../domain/entities/investigation_handoff.dart';
import '../../domain/entities/simulation_attempt.dart';
import '../../domain/entities/simulation_node.dart';

class SimulationActionResult {
  final bool success;
  final SimulationAttempt attempt;
  final SimulationSelectedAction actionTaken;
  final String consequence;
  final int scoreDelta;
  final List<Map<String, dynamic>> unlockedEvidence;
  final SimulationNode nextNode;
  final bool isFinished;
  final bool isSuccess;
  final int xpAwarded;
  final InvestigationHandoff? investigationHandoff;

  const SimulationActionResult({
    required this.success,
    required this.attempt,
    required this.actionTaken,
    required this.consequence,
    required this.scoreDelta,
    this.unlockedEvidence = const [],
    required this.nextNode,
    required this.isFinished,
    required this.isSuccess,
    required this.xpAwarded,
    this.investigationHandoff,
  });

  factory SimulationActionResult.fromJson(Map<String, dynamic> json) {
    return SimulationActionResult(
      success: json['success'] as bool? ?? true,
      attempt: SimulationAttempt.fromJson(
        json['attempt'] as Map<String, dynamic>,
      ),
      actionTaken: SimulationSelectedAction.fromJson(
        json['action_taken'] as Map<String, dynamic>,
      ),
      consequence: (json['consequence'] ?? '').toString(),
      scoreDelta: (json['score_delta'] as num?)?.toInt() ?? 0,
      unlockedEvidence:
          (json['unlocked_evidence'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      nextNode: SimulationNode.fromJson(
        json['next_node'] as Map<String, dynamic>,
      ),
      isFinished: json['is_finished'] as bool? ?? false,
      isSuccess: json['is_success'] as bool? ?? false,
      xpAwarded: (json['xp_awarded'] as num?)?.toInt() ?? 0,
      investigationHandoff:
          json['investigation_handoff'] != null
              ? InvestigationHandoff.fromJson(
                json['investigation_handoff'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}

class SimulationStartResponse {
  final bool success;
  final bool resumed;
  final SimulationAttempt attempt;
  final SimulationNode currentNode;
  final List<Map<String, dynamic>> discoveredEvidence;

  const SimulationStartResponse({
    required this.success,
    required this.resumed,
    required this.attempt,
    required this.currentNode,
    this.discoveredEvidence = const [],
  });

  factory SimulationStartResponse.fromJson(Map<String, dynamic> json) {
    return SimulationStartResponse(
      success: json['success'] as bool? ?? true,
      resumed: json['resumed'] as bool? ?? false,
      attempt: SimulationAttempt.fromJson(
        json['attempt'] as Map<String, dynamic>,
      ),
      currentNode: SimulationNode.fromJson(
        json['currentNode'] as Map<String, dynamic>,
      ),
      discoveredEvidence:
          (json['discoveredEvidence'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );
  }
}
