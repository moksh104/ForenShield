enum ScenarioDifficulty { easy, medium, hard, critical }

enum ScenarioCategory { network, malware, webSec, dfir }

class SimulationObjective {
  final String id;
  final String title;
  final String description;
  final String targetCommandKeyword;
  final String hint;
  final bool isCompleted;

  const SimulationObjective({
    required this.id,
    required this.title,
    required this.description,
    this.targetCommandKeyword = '',
    this.hint = '',
    this.isCompleted = false,
  });

  factory SimulationObjective.fromJson(Map<String, dynamic> json) {
    return SimulationObjective(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      targetCommandKeyword: (json['targetCommandKeyword'] ?? '').toString(),
      hint: (json['hint'] ?? '').toString(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetCommandKeyword': targetCommandKeyword,
      'hint': hint,
      'isCompleted': isCompleted,
    };
  }

  SimulationObjective copyWith({bool? isCompleted}) {
    return SimulationObjective(
      id: id,
      title: title,
      description: description,
      targetCommandKeyword: targetCommandKeyword,
      hint: hint,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class SimulationActiveAttempt {
  final String attemptId;
  final String currentNodeId;
  final int score;
  final String status;

  const SimulationActiveAttempt({
    required this.attemptId,
    required this.currentNodeId,
    required this.score,
    required this.status,
  });

  factory SimulationActiveAttempt.fromJson(Map<String, dynamic> json) {
    return SimulationActiveAttempt(
      attemptId: (json['attemptId'] ?? '').toString(),
      currentNodeId: (json['currentNodeId'] ?? '').toString(),
      score: (json['score'] as num?)?.toInt() ?? 100,
      status: (json['status'] ?? 'in_progress').toString(),
    );
  }
}

class SimulationScenario {
  final String id;
  final String title;
  final String description;
  final ScenarioCategory category;
  final ScenarioDifficulty difficulty;
  final int estimatedMinutes;
  final int xpReward;
  final int passingScore;
  final String entryNodeId;
  final String? investigationCaseId;
  final List<String> initialTerminalHistory;
  final List<SimulationObjective> objectives;
  final bool isCompleted;
  final SimulationActiveAttempt? activeAttempt;

  const SimulationScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.xpReward,
    this.passingScore = 70,
    this.entryNodeId = 'node_start',
    this.investigationCaseId,
    required this.initialTerminalHistory,
    required this.objectives,
    this.isCompleted = false,
    this.activeAttempt,
  });

  factory SimulationScenario.fromJson(Map<String, dynamic> json) {
    return SimulationScenario(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: _parseCategory(json['category'] as String?),
      difficulty: _parseDifficulty(json['difficulty'] as String?),
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 10,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 100,
      passingScore: (json['passingScore'] as num?)?.toInt() ?? 70,
      entryNodeId: (json['entryNodeId'] ?? 'node_start').toString(),
      investigationCaseId: json['investigationCaseId']?.toString(),
      initialTerminalHistory:
          (json['initialTerminalHistory'] is List)
              ? (json['initialTerminalHistory'] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList()
              : const [],
      objectives:
          (json['objectives'] as List<dynamic>?)
              ?.map(
                (e) => SimulationObjective.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      activeAttempt:
          json['activeAttempt'] != null
              ? SimulationActiveAttempt.fromJson(
                json['activeAttempt'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  static ScenarioCategory _parseCategory(String? val) {
    switch (val) {
      case 'network':
        return ScenarioCategory.network;
      case 'webSec':
        return ScenarioCategory.webSec;
      case 'dfir':
        return ScenarioCategory.dfir;
      case 'malware':
        return ScenarioCategory.malware;
      default:
        return ScenarioCategory.webSec;
    }
  }

  static ScenarioDifficulty _parseDifficulty(String? val) {
    switch (val) {
      case 'easy':
      case 'beginner':
        return ScenarioDifficulty.easy;
      case 'medium':
      case 'intermediate':
        return ScenarioDifficulty.medium;
      case 'hard':
      case 'advanced':
        return ScenarioDifficulty.hard;
      case 'critical':
        return ScenarioDifficulty.critical;
      default:
        return ScenarioDifficulty.medium;
    }
  }
}
