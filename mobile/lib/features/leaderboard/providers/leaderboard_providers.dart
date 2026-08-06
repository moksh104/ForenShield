import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasource/leaderboard_remote_data_source.dart';
import '../data/repositories/leaderboard_repository.dart';

/// Provides the [LeaderboardRemoteDataSource].
final leaderboardDataSourceProvider =
    Provider<LeaderboardRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaderboardRemoteDataSource(apiClient);
});

/// Provides the [LeaderboardRepository].
final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final dataSource = ref.watch(leaderboardDataSourceProvider);
  return LeaderboardRepository(dataSource);
});

/// Fetches the leaderboard for a given period.
///
/// Usage: `ref.watch(leaderboardProvider('all'))`
final leaderboardProvider =
    FutureProvider.family<LeaderboardResult, String>((ref, period) async {
  final repo = ref.watch(leaderboardRepositoryProvider);
  return repo.fetchLeaderboard(period);
});
