/// Represents the difficulty scaling of training modules and scenarios.
enum DifficultyLevel {
  beginner('Beginner', 1),
  intermediate('Intermediate', 2),
  advanced('Advanced', 3),
  expert('Expert', 4);

  final String label;
  final int multiplier; // Can be used for XP multiplication

  const DifficultyLevel(this.label, this.multiplier);

  static DifficultyLevel fromString(String level) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.name.toLowerCase() == level.toLowerCase(),
      orElse: () => DifficultyLevel.beginner,
    );
  }
}
