import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/course_remote_data_source.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/usecases/load_courses_use_case.dart';
import '../../domain/usecases/load_lesson_use_case.dart';
import '../../domain/usecases/submit_quiz_use_case.dart';

enum CourseStatus { initial, loading, refreshing, success, empty, error }

class CourseState {
  final CourseStatus status;
  final List<CourseEntity> courses;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const CourseState({
    required this.status,
    this.courses = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  factory CourseState.initial() =>
      const CourseState(status: CourseStatus.initial);

  CourseState copyWith({
    CourseStatus? status,
    List<CourseEntity>? courses,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return CourseState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ── Dependency Providers ─────────────────────────────────────────────────────

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CourseRemoteDataSource(apiClient);
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final dataSource = ref.watch(courseRemoteDataSourceProvider);
  return CourseRepositoryImpl(dataSource);
});

final loadCoursesUseCaseProvider = Provider<LoadCoursesUseCase>((ref) {
  final repo = ref.watch(courseRepositoryProvider);
  return LoadCoursesUseCase(repo);
});

final loadLessonUseCaseProvider = Provider<LoadLessonUseCase>((ref) {
  final repo = ref.watch(courseRepositoryProvider);
  return LoadLessonUseCase(repo);
});

final submitQuizUseCaseProvider = Provider<SubmitQuizUseCase>((ref) {
  final repo = ref.watch(courseRepositoryProvider);
  return SubmitQuizUseCase(repo);
});

// ── State Notifier Provider ───────────────────────────────────────────────────

class CourseNotifier extends StateNotifier<CourseState> {
  final LoadCoursesUseCase _loadCoursesUseCase;

  CourseNotifier(this._loadCoursesUseCase) : super(CourseState.initial()) {
    loadCourses();
  }

  Future<void> loadCourses() async {
    state = state.copyWith(status: CourseStatus.loading);
    final result = await _loadCoursesUseCase(
      category: state.selectedCategory,
      searchQuery: state.searchQuery,
    );

    if (!mounted) return;

    result.when(
      success: (courses) {
        state = state.copyWith(
          status: courses.isEmpty ? CourseStatus.empty : CourseStatus.success,
          courses: courses,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          status: CourseStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  Future<void> refreshCourses() async {
    state = state.copyWith(status: CourseStatus.refreshing);
    final result = await _loadCoursesUseCase(
      category: state.selectedCategory,
      searchQuery: state.searchQuery,
    );

    if (!mounted) return;

    result.when(
      success: (courses) {
        state = state.copyWith(
          status: courses.isEmpty ? CourseStatus.empty : CourseStatus.success,
          courses: courses,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          status: CourseStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  void filterCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    loadCourses();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    loadCourses();
  }
}

final courseProvider =
    StateNotifierProvider.autoDispose<CourseNotifier, CourseState>((ref) {
      final useCase = ref.watch(loadCoursesUseCaseProvider);
      return CourseNotifier(useCase);
    });
