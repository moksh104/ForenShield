import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/nvd_remote_data_source.dart';
import '../data/models/nvd_model.dart';
import '../data/repositories/nvd_repository_impl.dart';

// ── Status Enum ───────────────────────────────────────────────────────────────

/// Loading lifecycle for the NVD vulnerability statistics feed.
enum NvdStatus { initial, loading, refreshing, success, error }

// ── State ─────────────────────────────────────────────────────────────────────

/// Immutable state for the NVD live vulnerability statistics.
class NvdState {
  final NvdStatus status;

  /// Populated with live data once a fetch succeeds.
  final NvdStats? stats;

  /// Human-readable error message to display in the UI on failure.
  final String? errorMessage;

  const NvdState({required this.status, this.stats, this.errorMessage});

  factory NvdState.initial() => const NvdState(status: NvdStatus.initial);

  NvdState copyWith({
    NvdStatus? status,
    NvdStats? stats,
    String? errorMessage,
  }) {
    return NvdState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// True when live data is available, regardless of current loading status.
  bool get hasData => stats != null;
}

// ── Infrastructure Providers ──────────────────────────────────────────────────

/// Provider for [NvdRemoteDataSource], reusing the shared [apiClientProvider].
final nvdRemoteDataSourceProvider = Provider<NvdRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NvdRemoteDataSource(apiClient);
});

/// Provider for [NvdRepositoryImpl].
final nvdRepositoryProvider = Provider<NvdRepositoryImpl>((ref) {
  final dataSource = ref.watch(nvdRemoteDataSourceProvider);
  return NvdRepositoryImpl(dataSource);
});

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Manages loading, refreshing, and error states for the NVD live
/// vulnerability statistics.
///
/// Follows the same pattern as [CisaKevNotifier] in mission_control.
class NvdNotifier extends StateNotifier<NvdState> {
  final NvdRepositoryImpl _repository;

  NvdNotifier(this._repository) : super(NvdState.initial()) {
    load();
  }

  /// Initial fetch on provider creation.
  Future<void> load() async {
    state = state.copyWith(status: NvdStatus.loading);
    await _fetch();
  }

  /// Pull-to-refresh: triggers a new fetch while preserving existing data.
  Future<void> refresh() async {
    state = state.copyWith(status: NvdStatus.refreshing);
    await _fetch();
  }

  Future<void> _fetch() async {
    final result = await _repository.getNvdStats();
    if (!mounted) return;

    result.when(
      success: (nvdStats) {
        state = state.copyWith(
          status: NvdStatus.success,
          stats: nvdStats,
          errorMessage: null,
        );
      },
      failure: (exception) {
        // If prior data exists (e.g. stale cache), preserve it.
        state = state.copyWith(
          status: NvdStatus.error,
          errorMessage: state.hasData
              ? 'Unable to refresh. Showing cached data.'
              : 'Unable to load live vulnerability reports.',
        );
      },
    );
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// AutoDispose StateNotifierProvider for NVD stats.
/// Disposes when the Reports screen is no longer in the widget tree.
final nvdProvider = StateNotifierProvider.autoDispose<NvdNotifier, NvdState>((
  ref,
) {
  final repository = ref.watch(nvdRepositoryProvider);
  return NvdNotifier(repository);
});
