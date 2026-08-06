import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasource/achievement_remote_data_source.dart';
import '../data/repositories/achievement_repository.dart';

/// Provides the [AchievementRemoteDataSource].
final achievementDataSourceProvider =
    Provider<AchievementRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AchievementRemoteDataSource(apiClient);
});

/// Provides the [AchievementRepository].
final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  final dataSource = ref.watch(achievementDataSourceProvider);
  return AchievementRepository(dataSource);
});

/// Fetches all achievements for the authenticated user.
final achievementsProvider =
    FutureProvider<AchievementResult>((ref) async {
  final repo = ref.watch(achievementRepositoryProvider);
  return repo.fetchAchievements();
});
