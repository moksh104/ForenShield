import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasource/leaderboard_remote_data_source.dart';
import '../data/repositories/leaderboard_repository.dart';
import '../data/models/leaderboard_entry_model.dart';

/// Provides the [LeaderboardRemoteDataSource].
final leaderboardDataSourceProvider = Provider<LeaderboardRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaderboardRemoteDataSource(apiClient);
});

/// Provides the [LeaderboardRepository].
final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final dataSource = ref.watch(leaderboardDataSourceProvider);
  return LeaderboardRepository(dataSource);
});

class LeaderboardNotifierArgs {
  final String period;
  final String search;
  const LeaderboardNotifierArgs(this.period, this.search);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardNotifierArgs &&
          runtimeType == other.runtimeType &&
          period == other.period &&
          search == other.search;

  @override
  int get hashCode => period.hashCode ^ search.hashCode;
}

class LeaderboardNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<
          List<LeaderboardEntryModel>,
          LeaderboardNotifierArgs
        > {
  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  Future<List<LeaderboardEntryModel>> build(LeaderboardNotifierArgs arg) async {
    _currentPage = 1;
    return await _fetchPage(_currentPage);
  }

  Future<List<LeaderboardEntryModel>> _fetchPage(int page) async {
    final repo = ref.read(leaderboardRepositoryProvider);
    final results = await repo.fetchLeaderboard(
      arg.period,
      page: page,
      search: arg.search,
    );
    _hasMore = results.length == 20; // limit is 20
    return results;
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;

    state = const AsyncValue.loading();
    _currentPage++;

    try {
      final newItems = await _fetchPage(_currentPage);
      state = AsyncValue.data([...state.value ?? [], ...newItems]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    state = const AsyncValue.loading();
    try {
      final newItems = await _fetchPage(_currentPage);
      state = AsyncValue.data(newItems);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final leaderboardProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      LeaderboardNotifier,
      List<LeaderboardEntryModel>,
      LeaderboardNotifierArgs
    >(LeaderboardNotifier.new);

final profileRankProvider =
    FutureProvider.autoDispose<LeaderboardProfileResult>((ref) async {
      final repo = ref.watch(leaderboardRepositoryProvider);
      return await repo.fetchProfileRank();
    });
