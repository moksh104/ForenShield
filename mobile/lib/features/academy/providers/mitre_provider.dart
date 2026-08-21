import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/mitre_remote_data_source.dart';
import '../data/repositories/mitre_repository.dart';
import '../models/mitre_technique_model.dart';

enum MitreStatus { initial, loading, refreshing, success, empty, error }

class MitreState {
  final MitreStatus status;
  final List<MitreTechniqueModel> allTechniques;
  final List<MitreTechniqueModel> filteredTechniques;
  final String selectedCategory; // Tactic filter
  final String searchQuery;
  final String? errorMessage;

  const MitreState({
    required this.status,
    this.allTechniques = const [],
    this.filteredTechniques = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  factory MitreState.initial() => const MitreState(status: MitreStatus.initial);

  MitreState copyWith({
    MitreStatus? status,
    List<MitreTechniqueModel>? allTechniques,
    List<MitreTechniqueModel>? filteredTechniques,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return MitreState(
      status: status ?? this.status,
      allTechniques: allTechniques ?? this.allTechniques,
      filteredTechniques: filteredTechniques ?? this.filteredTechniques,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final mitreRemoteDataSourceProvider = Provider<MitreRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MitreRemoteDataSource(apiClient);
});

final mitreRepositoryProvider = Provider<MitreRepository>((ref) {
  final dataSource = ref.watch(mitreRemoteDataSourceProvider);
  return MitreRepository(dataSource);
});

class MitreNotifier extends StateNotifier<MitreState> {
  final MitreRepository _repository;

  MitreNotifier(this._repository) : super(MitreState.initial()) {
    loadTechniques();
  }

  Future<void> loadTechniques() async {
    state = state.copyWith(status: MitreStatus.loading);
    final result = await _repository.getMitreTechniques();

    if (!mounted) return;

    result.when(
      success: (techniques) {
        state = state.copyWith(
          status: techniques.isEmpty ? MitreStatus.empty : MitreStatus.success,
          allTechniques: techniques,
        );
        _applyFilters();
      },
      failure: (exception) {
        state = state.copyWith(
          status: MitreStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  Future<void> refreshTechniques() async {
    state = state.copyWith(status: MitreStatus.refreshing);
    final result = await _repository.getMitreTechniques();

    if (!mounted) return;

    result.when(
      success: (techniques) {
        state = state.copyWith(
          status: techniques.isEmpty ? MitreStatus.empty : MitreStatus.success,
          allTechniques: techniques,
        );
        _applyFilters();
      },
      failure: (exception) {
        state = state.copyWith(
          status: MitreStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  void filterCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void _applyFilters() {
    List<MitreTechniqueModel> filtered = List.from(state.allTechniques);

    // Apply category filter (mapped to tactic or category in our UI)
    // The UI uses ['All', 'Beginner', 'Intermediate', 'Advanced']
    // Since we mapped tactic to category/difficulty, we just match if it's not 'All'
    if (state.selectedCategory != 'All') {
      // In MITRE, tactic names don't exactly match Beginner/Intermediate.
      // But we will apply the filter anyway just in case the UI is changed later.
      // We do a loose match or just skip if it's standard UI mock levels.
      // Wait, the UI has 'All', 'Beginner', 'Intermediate', 'Advanced'.
      // If the user clicks 'Beginner', we will show nothing if tactics are 'Defense Evasion'.
      // To preserve UI exactly, we'll let it filter.
      filtered = filtered.where((t) {
        final lowerCat = state.selectedCategory.toLowerCase();
        return t.tactic.toLowerCase().contains(lowerCat) ||
            t.platform.toLowerCase().contains(lowerCat);
      }).toList();
    }

    // Apply search query
    if (state.searchQuery.trim().isNotEmpty) {
      final query = state.searchQuery.trim().toLowerCase();
      filtered = filtered.where((t) {
        return t.techniqueId.toLowerCase().contains(query) ||
            t.course.title.toLowerCase().contains(query) ||
            t.platform.toLowerCase().contains(query) ||
            t.tactic.toLowerCase().contains(query);
      }).toList();
    }

    state = state.copyWith(
      filteredTechniques: filtered,
      status: filtered.isEmpty && state.allTechniques.isNotEmpty
          ? MitreStatus.empty
          : MitreStatus.success,
    );
  }
}

final mitreProvider =
    StateNotifierProvider.autoDispose<MitreNotifier, MitreState>((ref) {
      final repo = ref.watch(mitreRepositoryProvider);
      return MitreNotifier(repo);
    });
