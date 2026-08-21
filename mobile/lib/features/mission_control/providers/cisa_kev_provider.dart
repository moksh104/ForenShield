import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/cisa_kev_remote_data_source.dart';
import '../data/repositories/cisa_kev_repository_impl.dart';
import '../domain/entities/cisa_kev_entity.dart';
import '../domain/repositories/cisa_kev_repository.dart';

// ── Status Enum ───────────────────────────────────────────────────────────────

/// Lifecycle status for the CISA KEV feed loading state.
enum CisaKevStatus { initial, loading, refreshing, success, error }

// ── State ─────────────────────────────────────────────────────────────────────

/// Immutable state for the CISA KEV live threat feed.
class CisaKevState {
  final CisaKevStatus status;

  /// The list of KEV entries when loading succeeds.
  final List<CisaKevEntry> entries;

  /// Human-readable error message shown in the UI on failure.
  final String? errorMessage;

  const CisaKevState({
    required this.status,
    this.entries = const [],
    this.errorMessage,
  });

  factory CisaKevState.initial() =>
      const CisaKevState(status: CisaKevStatus.initial);

  CisaKevState copyWith({
    CisaKevStatus? status,
    List<CisaKevEntry>? entries,
    String? errorMessage,
  }) {
    return CisaKevState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// True when there is displayable data, regardless of loading status.
  bool get hasData => entries.isNotEmpty;
}

// ── Providers ─────────────────────────────────────────────────────────────────

/// Provider for the CISA KEV remote data source.
/// Reuses the shared [apiClientProvider] — no duplicate Dio instance.
final cisaKevRemoteDataSourceProvider = Provider<CisaKevRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return CisaKevRemoteDataSource(apiClient);
});

/// Provider for the CISA KEV repository.
final cisaKevRepositoryProvider = Provider<CisaKevRepository>((ref) {
  final dataSource = ref.watch(cisaKevRemoteDataSourceProvider);
  return CisaKevRepositoryImpl(dataSource);
});

// ── Notifier ──────────────────────────────────────────────────────────────────

/// State notifier that manages loading, refreshing, and error states for the
/// CISA KEV live threat intelligence feed.
class CisaKevNotifier extends StateNotifier<CisaKevState> {
  final CisaKevRepository _repository;

  CisaKevNotifier(this._repository) : super(CisaKevState.initial()) {
    load();
  }

  /// Initial load of the KEV feed.
  Future<void> load() async {
    state = state.copyWith(status: CisaKevStatus.loading);
    await _fetch();
  }

  /// Pull-to-refresh: triggers a fresh fetch.
  Future<void> refresh() async {
    state = state.copyWith(status: CisaKevStatus.refreshing);
    await _fetch();
  }

  Future<void> _fetch() async {
    final result = await _repository.getKevFeed();
    if (!mounted) return;

    result.when(
      success: (entries) {
        state = state.copyWith(
          status: CisaKevStatus.success,
          entries: entries,
          errorMessage: null,
        );
      },
      failure: (exception) {
        // If we already have data from a prior load, preserve it and mark error
        // so the UI can show a banner rather than wiping the list.
        state = state.copyWith(
          status: CisaKevStatus.error,
          errorMessage: state.hasData
              ? 'Unable to load live threat intelligence. Showing cached data.'
              : 'No live threat data available.',
        );
      },
    );
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Main autoDispose StateNotifierProvider for the CISA KEV feed.
/// Automatically disposes when the widget tree no longer watches it.
final cisaKevProvider =
    StateNotifierProvider.autoDispose<CisaKevNotifier, CisaKevState>((ref) {
      final repository = ref.watch(cisaKevRepositoryProvider);
      return CisaKevNotifier(repository);
    });
