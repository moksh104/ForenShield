import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/result.dart';
import '../data/academy_repository.dart';
import '../models/achievement_model.dart';
import '../models/course_model.dart';
import '../models/category_model.dart';
import '../models/lesson_model.dart';
import 'academy_providers.dart';

/// State for the Academy dashboard. Pure data holder (no UI logic).
class AcademyDashboardState {
  /// Optional course the user should continue learning
  final CourseModel? continueLearning;

  final List<CourseModel> featuredCourses;
  final List<CategoryModel> categories;
  final List<CourseModel> recommendedCourses;
  final List<LessonModel> recentLessons;
  final List<AchievementModel> achievements;

  const AcademyDashboardState({
    this.continueLearning,
    this.featuredCourses = const [],
    this.categories = const [],
    this.recommendedCourses = const [],
    this.recentLessons = const [],
    this.achievements = const [],
  });

  /// Convenience empty state
  static const AcademyDashboardState empty = AcademyDashboardState();

  AcademyDashboardState copyWith({
    CourseModel? continueLearning,
    List<CourseModel>? featuredCourses,
    List<CategoryModel>? categories,
    List<CourseModel>? recommendedCourses,
    List<LessonModel>? recentLessons,
    List<AchievementModel>? achievements,
  }) {
    return AcademyDashboardState(
      continueLearning: continueLearning ?? this.continueLearning,
      featuredCourses: featuredCourses ?? this.featuredCourses,
      categories: categories ?? this.categories,
      recommendedCourses: recommendedCourses ?? this.recommendedCourses,
      recentLessons: recentLessons ?? this.recentLessons,
      achievements: achievements ?? this.achievements,
    );
  }

  /// Computed helper: whether the dashboard is empty (no items and no continueLearning)
  bool get isEmpty => continueLearning == null && featuredCourses.isEmpty && categories.isEmpty && recommendedCourses.isEmpty && recentLessons.isEmpty && achievements.isEmpty;
}

/// AsyncNotifier that loads and refreshes the Academy dashboard.
///
/// Responsibilities:
///  - load dashboard (build)
///  - refresh
///  - load continue learning (from recent lessons)
///  - error handling and empty state
///
/// The notifier uses [AcademyRepository] and the [Result<T>] wrappers. UI should consume the provider's AsyncValue
/// and render loading/error/data states accordingly. This class contains no UI logic.
class AcademyDashboardNotifier extends AsyncNotifier<AcademyDashboardState> {
  late final AcademyRepository _repository;

  @override
  Future<AcademyDashboardState> build() async {
    // Obtain repository via provider
    _repository = ref.read(academyRepositoryProvider);
    // Load dashboard once when notifier is created
    return await _loadDashboard();
  }

  /// Public method to refresh the entire dashboard.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final data = await _loadDashboard();
      state = AsyncValue.data(data);
    } on ApiException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(ApiException(message: e.toString(), statusCode: 0, type: ApiExceptionType.unknown), StackTrace.current);
    }
  }

  /// Loads only the "continue learning" section by inspecting recent lessons.
  /// Updates the dashboard state in-place when possible.
  Future<void> loadContinueLearning() async {
    // Keep UI responsive by not wiping out existing data
    final current = state.value ?? AcademyDashboardState.empty;
    // Optionally show a lightweight loading overlay in UI by setting loading state; here we keep existing data
    // Fetch recent lessons
    final recentResult = await _repository.getRecentLessons();
    if (recentResult is Failure) {
      // propagate error state
      state = AsyncValue.error(recentResult.error, StackTrace.current);
      return;
    }

    final recent = (recentResult as Success<List<LessonModel>>).value;
    // Choose the first recent lesson as continue learning candidate
    CourseModel? continueCourse;
    if (recent.isNotEmpty) {
      // We try to fetch course details for the first lesson - best effort; ignore if it fails
      final first = recent.first;
      final courseResult = await _repository.getCourse(first.courseId);
      if (courseResult is Success<CourseModel>) {
        continueCourse = (courseResult as Success<CourseModel>).value;
      }
    }

    final updated = current.copyWith(continueLearning: continueCourse, recentLessons: recent);
    state = AsyncValue.data(updated);
  }

  /// Private helper to load all dashboard sections. Throws [ApiException] on first failure.
  Future<AcademyDashboardState> _loadDashboard() async {
    // Fire requests in parallel to reduce latency
    final featuredFuture = _repository.getFeaturedCourses();
    final recommendedFuture = _repository.getRecommendedCourses();
    final categoriesFuture = _repository.getCategories();
    final recentFuture = _repository.getRecentLessons();
    final achievementsFuture = _repository.getAchievements();

    final results = await Future.wait([featuredFuture, recommendedFuture, categoriesFuture, recentFuture, achievementsFuture]);

    // results order: featured, recommended, categories, recent, achievements
    // Check for failures
    for (final r in results) {
      if (r is Failure) {
        // Propagate the first ApiException encountered
        throw (r as Failure).error;
      }
    }

    final featured = (results[0] as Success<List<CourseModel>>).value;
    final recommended = (results[1] as Success<List<CourseModel>>).value;
    final categories = (results[2] as Success<List<CategoryModel>>).value;
    final recent = (results[3] as Success<List<LessonModel>>).value;
    final achievements = (results[4] as Success<List<AchievementModel>>).value;

    CourseModel? continueCourse;
    if (recent.isNotEmpty) {
      // best-effort fetch course details for the first recent lesson; allow failure without failing entire dashboard
      try {
        final courseRes = await _repository.getCourse(recent.first.courseId);
        if (courseRes is Success<CourseModel>) {
          continueCourse = (courseRes as Success<CourseModel>).value;
        }
      } catch (_) {
        // ignore - continue without a continueLearning course
      }
    }

    final state = AcademyDashboardState(
      continueLearning: continueCourse,
      featuredCourses: featured,
      categories: categories,
      recommendedCourses: recommended,
      recentLessons: recent,
      achievements: achievements,
    );

    return state;
  }
}

/// Provider for the academy dashboard AsyncNotifier
final academyDashboardProvider = AsyncNotifierProvider<AcademyDashboardNotifier, AcademyDashboardState>(() {
  return AcademyDashboardNotifier();
});
