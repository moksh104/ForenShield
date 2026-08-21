import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasource/achievement_remote_data_source.dart';
import '../data/repositories/achievement_repository.dart';
import '../data/repositories/achievement_repository_impl.dart';
import '../data/repositories/mock_achievement_repository.dart';
import '../data/models/achievement_model.dart';

final achievementDataSourceProvider = Provider<AchievementRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return AchievementRemoteDataSource(apiClient);
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  if (ApiConfig.useMockApi) {
    return MockAchievementRepository();
  }
  final dataSource = ref.watch(achievementDataSourceProvider);
  return AchievementRepositoryImpl(dataSource);
});

class AchievementNotifierArgs {
  final String category;
  final String search;
  const AchievementNotifierArgs(this.category, this.search);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementNotifierArgs &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          search == other.search;

  @override
  int get hashCode => category.hashCode ^ search.hashCode;
}

class AchievementNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<
          List<AchievementModel>,
          AchievementNotifierArgs
        > {
  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  Future<List<AchievementModel>> build(AchievementNotifierArgs arg) async {
    _currentPage = 1;
    return await _fetchPage(_currentPage);
  }

  Future<List<AchievementModel>> _fetchPage(int page) async {
    final repo = ref.read(achievementRepositoryProvider);
    final results = await repo.fetchAchievements(
      arg.category,
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

final achievementProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      AchievementNotifier,
      List<AchievementModel>,
      AchievementNotifierArgs
    >(AchievementNotifier.new);
