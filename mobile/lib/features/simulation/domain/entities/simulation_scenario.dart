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
    required this.targetCommandKeyword,
    required this.hint,
    this.isCompleted = false,
  });

  factory SimulationObjective.fromJson(Map<String, dynamic> json) {
    return SimulationObjective(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetCommandKeyword: json['targetCommandKeyword'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
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

class SimulationScenario {
  final String id;
  final String title;
  final String description;
  final ScenarioCategory category;
  final ScenarioDifficulty difficulty;
  final int estimatedMinutes;
  final int xpReward;
  final List<String> initialTerminalHistory;
  final List<SimulationObjective> objectives;
  final bool isCompleted;

  const SimulationScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.xpReward,
    required this.initialTerminalHistory,
    required this.objectives,
    this.isCompleted = false,
  });

  factory SimulationScenario.fromJson(Map<String, dynamic> json) {
    return SimulationScenario(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: _parseCategory(json['category'] as String?),
      difficulty: _parseDifficulty(json['difficulty'] as String?),
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 0,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 0,
      initialTerminalHistory:
          (json['initialTerminalHistory'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      objectives:
          (json['objectives'] as List<dynamic>?)
              ?.map(
                (e) => SimulationObjective.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
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
        return ScenarioCategory.network;
    }
  }

  static ScenarioDifficulty _parseDifficulty(String? val) {
    switch (val) {
      case 'easy':
        return ScenarioDifficulty.easy;
      case 'medium':
        return ScenarioDifficulty.medium;
      case 'hard':
        return ScenarioDifficulty.hard;
      case 'critical':
        return ScenarioDifficulty.critical;
      default:
        return ScenarioDifficulty.medium;
    }
  }
}
