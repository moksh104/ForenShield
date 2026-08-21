import '../models/achievement_model.dart';

abstract class AchievementRepository {
  Future<List<AchievementModel>> fetchAchievements(
    String category, {
    int page = 1,
    String search = '',
  });
}
