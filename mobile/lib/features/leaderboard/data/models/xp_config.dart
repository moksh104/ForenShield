/// XP and Level configuration constants for ForenShield's progression system.
class XpConfig {
  XpConfig._();

  // ── XP Rewards ───────────────────────────────────────────────────
  static const int lessonComplete = 25;
  static const int quizPass = 50;
  static const int investigationComplete = 100;
  static const int streakBonus = 10;
  static const int achievementUnlock = 200;

  // ── Level Thresholds ─────────────────────────────────────────────
  static const List<int> levelThresholds = [0, 250, 500, 1000, 2500, 5000];

  /// Returns the current level for a given XP value (1-indexed).
  static int levelForXp(int xp) {
    for (int i = levelThresholds.length - 1; i >= 0; i--) {
      if (xp >= levelThresholds[i]) return i + 1;
    }
    return 1;
  }

  /// Returns the XP required to reach the next level.
  /// Returns null if at max level.
  static int? xpForNextLevel(int xp) {
    final level = levelForXp(xp);
    if (level >= levelThresholds.length) return null;
    return levelThresholds[level];
  }

  /// Returns the progress fraction (0.0 to 1.0) toward the next level.
  static double progressToNextLevel(int xp) {
    final level = levelForXp(xp);
    if (level >= levelThresholds.length) return 1.0;
    final currentThreshold = levelThresholds[level - 1];
    final nextThreshold = levelThresholds[level];
    final range = nextThreshold - currentThreshold;
    if (range <= 0) return 1.0;
    return ((xp - currentThreshold) / range).clamp(0.0, 1.0);
  }

  /// Returns the level title for display.
  static String levelTitle(int level) {
    switch (level) {
      case 1:
        return 'Trainee';
      case 2:
        return 'Analyst';
      case 3:
        return 'Specialist';
      case 4:
        return 'Expert';
      case 5:
        return 'Master';
      case 6:
        return 'Legend';
      default:
        return 'Trainee';
    }
  }
}
