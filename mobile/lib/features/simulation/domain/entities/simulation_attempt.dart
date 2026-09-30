enum SimulationAttemptStatus {
  inProgress,
  completed,
  failed,
  abandoned;

  static SimulationAttemptStatus fromString(String? val) {
    switch (val) {
      case 'in_progress':
        return SimulationAttemptStatus.inProgress;
      case 'completed':
        return SimulationAttemptStatus.completed;
      case 'failed':
        return SimulationAttemptStatus.failed;
      case 'abandoned':
        return SimulationAttemptStatus.abandoned;
      default:
        return SimulationAttemptStatus.inProgress;
    }
  }

  String get dbValue {
    switch (this) {
      case SimulationAttemptStatus.inProgress:
        return 'in_progress';
      case SimulationAttemptStatus.completed:
        return 'completed';
      case SimulationAttemptStatus.failed:
        return 'failed';
      case SimulationAttemptStatus.abandoned:
        return 'abandoned';
    }
  }
}

class SimulationSelectedAction {
  final String nodeId;
  final String nodeTitle;
  final String actionId;
  final String actionLabel;
  final String actionType;
  final String safety;
  final int scoreDelta;
  final String consequence;
  final List<String> evidenceUnlocked;
  final DateTime timestamp;

  const SimulationSelectedAction({
    required this.nodeId,
    required this.nodeTitle,
    required this.actionId,
    required this.actionLabel,
    required this.actionType,
    required this.safety,
    required this.scoreDelta,
    required this.consequence,
    required this.evidenceUnlocked,
    required this.timestamp,
  });

  factory SimulationSelectedAction.fromJson(Map<String, dynamic> json) {
    DateTime parseTime(dynamic val) {
      if (val == null) return DateTime.now();
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return SimulationSelectedAction(
      nodeId: (json['node_id'] ?? '').toString(),
      nodeTitle: (json['node_title'] ?? '').toString(),
      actionId: (json['action_id'] ?? '').toString(),
      actionLabel: (json['action_label'] ?? '').toString(),
      actionType: (json['action_type'] ?? 'investigate').toString(),
      safety: (json['safety'] ?? 'safe').toString(),
      scoreDelta: (json['score_delta'] as num?)?.toInt() ?? 0,
      consequence: (json['consequence'] ?? '').toString(),
      evidenceUnlocked:
          (json['evidence_unlocked'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      timestamp: parseTime(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'node_id': nodeId,
      'node_title': nodeTitle,
      'action_id': actionId,
      'action_label': actionLabel,
      'action_type': actionType,
      'safety': safety,
      'score_delta': scoreDelta,
      'consequence': consequence,
      'evidence_unlocked': evidenceUnlocked,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class SimulationAttempt {
  final String id;
  final int userId;
  final String scenarioId;
  final String currentNodeId;
  final SimulationAttemptStatus status;
  final int score;
  final int xpEarned;
  final List<SimulationSelectedAction> selectedActions;
  final List<String> discoveredEvidenceIds;
  final Map<String, dynamic> stateFlags;
  final DateTime startedAt;
  final DateTime lastActivityAt;
  final DateTime? completedAt;

  const SimulationAttempt({
    required this.id,
    required this.userId,
    required this.scenarioId,
    required this.currentNodeId,
    required this.status,
    required this.score,
    required this.xpEarned,
    this.selectedActions = const [],
    this.discoveredEvidenceIds = const [],
    this.stateFlags = const {},
    required this.startedAt,
    required this.lastActivityAt,
    this.completedAt,
  });

  factory SimulationAttempt.fromJson(Map<String, dynamic> json) {
    DateTime parseTime(dynamic val, {DateTime? fallback}) {
      if (val == null) return fallback ?? DateTime.now();
      return DateTime.tryParse(val.toString()) ?? (fallback ?? DateTime.now());
    }

    return SimulationAttempt(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      scenarioId: (json['scenario_id'] ?? '').toString(),
      currentNodeId: (json['current_node_id'] ?? '').toString(),
      status: SimulationAttemptStatus.fromString(json['status'] as String?),
      score: (json['score'] as num?)?.toInt() ?? 100,
      xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
      selectedActions:
          (json['selected_actions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    SimulationSelectedAction.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      discoveredEvidenceIds:
          (json['discovered_evidence_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      stateFlags: (json['state_flags'] as Map<String, dynamic>?) ?? const {},
      startedAt: parseTime(json['started_at']),
      lastActivityAt: parseTime(json['last_activity_at']),
      completedAt:
          json['completed_at'] != null ? parseTime(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'scenario_id': scenarioId,
      'current_node_id': currentNodeId,
      'status': status.dbValue,
      'score': score,
      'xp_earned': xpEarned,
      'selected_actions': selectedActions.map((e) => e.toJson()).toList(),
      'discovered_evidence_ids': discoveredEvidenceIds,
      'state_flags': stateFlags,
      'started_at': startedAt.toIso8601String(),
      'last_activity_at': lastActivityAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  SimulationAttempt copyWith({
    String? currentNodeId,
    SimulationAttemptStatus? status,
    int? score,
    int? xpEarned,
    List<SimulationSelectedAction>? selectedActions,
    List<String>? discoveredEvidenceIds,
    Map<String, dynamic>? stateFlags,
    DateTime? lastActivityAt,
    DateTime? completedAt,
  }) {
    return SimulationAttempt(
      id: id,
      userId: userId,
      scenarioId: scenarioId,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      status: status ?? this.status,
      score: score ?? this.score,
      xpEarned: xpEarned ?? this.xpEarned,
      selectedActions: selectedActions ?? this.selectedActions,
      discoveredEvidenceIds:
          discoveredEvidenceIds ?? this.discoveredEvidenceIds,
      stateFlags: stateFlags ?? this.stateFlags,
      startedAt: startedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
