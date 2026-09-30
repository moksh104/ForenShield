enum SimulationActionSafety { safe, caution, critical }

enum SimulationNodeType {
  incidentStart,
  investigation,
  decision,
  consequence,
  containment,
  resolution,
  failure;

  static SimulationNodeType fromString(String? val) {
    switch (val) {
      case 'incident_start':
        return SimulationNodeType.incidentStart;
      case 'investigation':
        return SimulationNodeType.investigation;
      case 'decision':
        return SimulationNodeType.decision;
      case 'consequence':
        return SimulationNodeType.consequence;
      case 'containment':
        return SimulationNodeType.containment;
      case 'resolution':
        return SimulationNodeType.resolution;
      case 'failure':
        return SimulationNodeType.failure;
      default:
        return SimulationNodeType.investigation;
    }
  }
}

class SimulationAction {
  final String id;
  final String label;
  final String description;
  final String actionType; // investigate, contain, escalate, remediate, ignore
  final SimulationActionSafety safety;
  final int scoreDelta;
  final String consequenceSummary;
  final List<String> unlocksEvidenceIds;
  final String nextNodeId;

  const SimulationAction({
    required this.id,
    required this.label,
    required this.description,
    required this.actionType,
    required this.safety,
    required this.scoreDelta,
    required this.consequenceSummary,
    required this.unlocksEvidenceIds,
    required this.nextNodeId,
  });

  factory SimulationAction.fromJson(Map<String, dynamic> json) {
    SimulationActionSafety parseSafety(String? s) {
      switch (s) {
        case 'safe':
          return SimulationActionSafety.safe;
        case 'caution':
          return SimulationActionSafety.caution;
        case 'critical':
          return SimulationActionSafety.critical;
        default:
          return SimulationActionSafety.safe;
      }
    }

    return SimulationAction(
      id: (json['id'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      actionType: (json['action_type'] ?? 'investigate').toString(),
      safety: parseSafety(json['safety'] as String?),
      scoreDelta: (json['score_delta'] as num?)?.toInt() ?? 0,
      consequenceSummary: (json['consequence_summary'] ?? '').toString(),
      unlocksEvidenceIds:
          (json['unlocks_evidence_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      nextNodeId: (json['next_node_id'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'action_type': actionType,
      'safety': safety.name,
      'score_delta': scoreDelta,
      'consequence_summary': consequenceSummary,
      'unlocks_evidence_ids': unlocksEvidenceIds,
      'next_node_id': nextNodeId,
    };
  }
}

class SimulationNode {
  final String id;
  final SimulationNodeType type;
  final String title;
  final String narrative;
  final Map<String, dynamic> contextData;
  final List<SimulationAction> availableActions;
  final List<String> evidenceUnlockedOnEnter;
  final bool isTerminal;
  final bool isSuccess;

  const SimulationNode({
    required this.id,
    required this.type,
    required this.title,
    required this.narrative,
    this.contextData = const {},
    this.availableActions = const [],
    this.evidenceUnlockedOnEnter = const [],
    this.isTerminal = false,
    this.isSuccess = false,
  });

  factory SimulationNode.fromJson(Map<String, dynamic> json) {
    return SimulationNode(
      id: (json['id'] ?? '').toString(),
      type: SimulationNodeType.fromString(json['type'] as String?),
      title: (json['title'] ?? '').toString(),
      narrative: (json['narrative'] ?? '').toString(),
      contextData: (json['context_data'] as Map<String, dynamic>?) ?? const {},
      availableActions:
          (json['available_actions'] as List<dynamic>?)
              ?.map((e) => SimulationAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      evidenceUnlockedOnEnter:
          (json['evidence_unlocked_on_enter'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isTerminal: json['is_terminal'] as bool? ?? false,
      isSuccess: json['is_success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'narrative': narrative,
      'context_data': contextData,
      'available_actions': availableActions.map((e) => e.toJson()).toList(),
      'evidence_unlocked_on_enter': evidenceUnlockedOnEnter,
      'is_terminal': isTerminal,
      'is_success': isSuccess,
    };
  }
}
