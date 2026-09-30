/// Result returned by the server after a verdict submission.
class VerdictResult {
  final int score;
  final bool isCorrect;
  final int xpEarned;
  final int bonusXp;
  final bool wasDuplicate;
  final List<String> newAchievements;

  const VerdictResult({
    required this.score,
    required this.isCorrect,
    required this.xpEarned,
    required this.bonusXp,
    required this.wasDuplicate,
    required this.newAchievements,
  });

  factory VerdictResult.fromJson(Map<String, dynamic> json) {
    return VerdictResult(
      score: (json['score'] as num?)?.toInt() ?? 0,
      isCorrect: json['is_correct'] as bool? ?? false,
      xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
      bonusXp: (json['bonus_xp'] as num?)?.toInt() ?? 0,
      wasDuplicate: json['was_duplicate'] as bool? ?? false,
      newAchievements:
          (json['new_achievements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
