import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/investigation_remote_data_source.dart';
import '../../data/repositories/investigation_repository_impl.dart';
import '../../domain/entities/investigation_entity.dart';
import '../../domain/repositories/investigation_repository.dart';
import '../../domain/usecases/load_cases_use_case.dart';
import '../../domain/usecases/load_evidence_use_case.dart';
import '../../domain/usecases/submit_verdict_use_case.dart';

enum InvestigationStatus { initial, loading, refreshing, success, empty, error }

class InvestigationState {
  final InvestigationStatus status;
  final List<InvestigationEntity> cases;
  final String selectedStatusFilter;
  final String selectedPriorityFilter;
  final String searchQuery;
  final String sortBy;
  final String? errorMessage;

  const InvestigationState({
    required this.status,
    this.cases = const [],
    this.selectedStatusFilter = 'All',
    this.selectedPriorityFilter = 'All',
    this.searchQuery = '',
    this.sortBy = 'Date',
    this.errorMessage,
  });

  factory InvestigationState.initial() =>
      const InvestigationState(status: InvestigationStatus.initial);

  InvestigationState copyWith({
    InvestigationStatus? status,
    List<InvestigationEntity>? cases,
    String? selectedStatusFilter,
    String? selectedPriorityFilter,
    String? searchQuery,
    String? sortBy,
    String? errorMessage,
  }) {
    return InvestigationState(
      status: status ?? this.status,
      cases: cases ?? this.cases,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedPriorityFilter:
          selectedPriorityFilter ?? this.selectedPriorityFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ── Dependency Providers ─────────────────────────────────────────────────────

final investigationRemoteDataSourceProvider =
    Provider<InvestigationRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return InvestigationRemoteDataSource(apiClient);
    });

final investigationRepositoryProvider = Provider<InvestigationRepository>((
  ref,
) {
  final dataSource = ref.watch(investigationRemoteDataSourceProvider);
  return InvestigationRepositoryImpl(dataSource);
});

final loadCasesUseCaseProvider = Provider<LoadCasesUseCase>((ref) {
  final repo = ref.watch(investigationRepositoryProvider);
  return LoadCasesUseCase(repo);
});

final loadEvidenceUseCaseProvider = Provider<LoadEvidenceUseCase>((ref) {
  final repo = ref.watch(investigationRepositoryProvider);
  return LoadEvidenceUseCase(repo);
});

final submitVerdictUseCaseProvider = Provider<SubmitVerdictUseCase>((ref) {
  final repo = ref.watch(investigationRepositoryProvider);
  return SubmitVerdictUseCase(repo);
});

// ── State Notifier Provider ───────────────────────────────────────────────────

class InvestigationNotifier extends StateNotifier<InvestigationState> {
  final LoadCasesUseCase _loadCasesUseCase;

  InvestigationNotifier(this._loadCasesUseCase)
    : super(InvestigationState.initial()) {
    loadCases();
  }

  Future<void> loadCases() async {
    state = state.copyWith(status: InvestigationStatus.loading);
    final result = await _loadCasesUseCase(
      statusFilter: state.selectedStatusFilter,
      priorityFilter: state.selectedPriorityFilter,
      searchQuery: state.searchQuery,
      sortBy: state.sortBy,
    );

    if (!mounted) return;

    result.when(
      success: (cases) {
        state = state.copyWith(
          status: cases.isEmpty
              ? InvestigationStatus.empty
              : InvestigationStatus.success,
          cases: cases,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          status: InvestigationStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  Future<void> refreshCases() async {
    state = state.copyWith(status: InvestigationStatus.refreshing);
    final result = await _loadCasesUseCase(
      statusFilter: state.selectedStatusFilter,
      priorityFilter: state.selectedPriorityFilter,
      searchQuery: state.searchQuery,
      sortBy: state.sortBy,
    );

    if (!mounted) return;

    result.when(
      success: (cases) {
        state = state.copyWith(
          status: cases.isEmpty
              ? InvestigationStatus.empty
              : InvestigationStatus.success,
          cases: cases,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          status: InvestigationStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  void filterStatus(String status) {
    state = state.copyWith(selectedStatusFilter: status);
    loadCases();
  }

  void filterPriority(String priority) {
    state = state.copyWith(selectedPriorityFilter: priority);
    loadCases();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    loadCases();
  }
}

final investigationProvider =
    StateNotifierProvider.autoDispose<
      InvestigationNotifier,
      InvestigationState
    >((ref) {
      final useCase = ref.watch(loadCasesUseCaseProvider);
      return InvestigationNotifier(useCase);
    });
