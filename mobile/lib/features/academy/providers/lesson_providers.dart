import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/result.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/lesson_progress_model.dart';
import 'academy_providers.dart';

// ── Courses ───────────────────────────────────────────────────────────────────

/// Fetches and exposes the list of all available [CourseModel]s.
final coursesProvider = FutureProvider.autoDispose<Result<List<CourseModel>>>((
  ref,
) async {
  final repo = ref.watch(academyRepositoryProvider);
  return repo.getCourses();
});

/// Fetches and exposes a single [CourseModel] by ID.
final courseDetailProvider = FutureProvider.autoDispose
    .family<Result<CourseModel>, String>((ref, courseId) async {
      final repo = ref.watch(academyRepositoryProvider);
      return repo.getCourse(courseId);
    });

// ── Lessons ───────────────────────────────────────────────────────────────────

/// Fetches and exposes a single [LessonModel] by ID.
final lessonDetailProvider = FutureProvider.autoDispose
    .family<Result<LessonModel>, String>((ref, lessonId) async {
      final repo = ref.watch(academyRepositoryProvider);
      return repo.getLesson(lessonId);
    });

// ── Progress ──────────────────────────────────────────────────────────────────

/// Fetches and exposes the current user's full lesson progress list.
final userProgressProvider =
    FutureProvider.autoDispose<Result<List<LessonProgressModel>>>((ref) async {
      final repo = ref.watch(academyRepositoryProvider);
      return repo.getUserProgress();
    });
