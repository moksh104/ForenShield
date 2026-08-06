import '../datasource/achievement_remote_data_source.dart';
import '../models/achievement_model.dart';

/// Repository wrapping [AchievementRemoteDataSource] with error handling.
class AchievementRepository {
  final AchievementRemoteDataSource _dataSource;

  const AchievementRepository(this._dataSource);

  /// Fetches all user achievements.
  Future<AchievementResult> fetchAchievements() async {
    try {
      final data = await _dataSource.fetchAchievements();

      final rawList = data['achievements'] as List<dynamic>? ?? [];
      final achievements = rawList
          .map((e) =>
              AchievementModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return AchievementResult(
        achievements: achievements,
        total: (data['total'] as int?) ?? achievements.length,
        unlockedCount: (data['unlocked_count'] as int?) ?? 0,
        totalXpEarned: (data['total_xp_earned'] as int?) ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Value object for achievement query results.
class AchievementResult {
  final List<AchievementModel> achievements;
  final int total;
  final int unlockedCount;
  final int totalXpEarned;

  const AchievementResult({
    required this.achievements,
    required this.total,
    required this.unlockedCount,
    required this.totalXpEarned,
  });
}
