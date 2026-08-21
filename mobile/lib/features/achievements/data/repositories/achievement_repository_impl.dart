import '../datasource/achievement_remote_data_source.dart';
import '../models/achievement_model.dart';
import 'achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementRemoteDataSource _dataSource;

  const AchievementRepositoryImpl(this._dataSource);

  @override
  Future<List<AchievementModel>> fetchAchievements(
    String category, {
    int page = 1,
    String search = '',
  }) async {
    try {
      final data = await _dataSource.fetchAchievements(
        category,
        page: page,
        search: search,
      );

      final rawEntries = data['achievements'] as List<dynamic>? ?? [];
      return rawEntries
          .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
