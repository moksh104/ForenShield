import '../models/achievement_model.dart';
import 'achievement_repository.dart';

class MockAchievementRepository implements AchievementRepository {
  static final List<AchievementModel> _mockAchievements = [
    AchievementModel(
      id: 1,
      code: 'first_blood',
      title: 'First Blood',
      description: 'Complete your first module',
      icon: '🎯',
      category: 'general',
      xpReward: 100,
      rarity: AchievementRarity.common,
      targetMetric: 'modules_completed',
      threshold: 1,
      progress: 1,
      isCompleted: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AchievementModel(
      id: 2,
      code: 'sharpshooter',
      title: 'Sharpshooter',
      description: 'Score 100% on 5 quizzes',
      icon: '🔫',
      category: 'academy',
      xpReward: 500,
      rarity: AchievementRarity.rare,
      targetMetric: 'quizzes_perfect',
      threshold: 5,
      progress: 2,
      isCompleted: false,
    ),
  ];

  @override
  Future<List<AchievementModel>> fetchAchievements(
    String category, {
    int page = 1,
    String search = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAchievements.where((a) {
      if (category != 'all' && a.category != category) return false;
      if (search.isNotEmpty &&
          !a.title.toLowerCase().contains(search.toLowerCase()))
        return false;
      return true;
    }).toList();
  }
}
