import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/settings_model.dart';
import 'device_management_provider.dart';

class LoginHistoryNotifier
    extends AutoDisposeAsyncNotifier<List<LoginHistoryModel>> {
  int _currentPage = 1;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  @override
  Future<List<LoginHistoryModel>> build() async {
    _currentPage = 1;
    return await _fetchPage(_currentPage);
  }

  Future<List<LoginHistoryModel>> _fetchPage(int page) async {
    final service = ref.read(settingsApiServiceProvider);
    final results = await service.getLoginHistory(page: page);
    _hasMore = results.length == 20; // assuming limit is 20
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

final loginHistoryProvider =
    AutoDisposeAsyncNotifierProvider<
      LoginHistoryNotifier,
      List<LoginHistoryModel>
    >(LoginHistoryNotifier.new);
