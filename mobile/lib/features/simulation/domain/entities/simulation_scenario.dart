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
  });
}
