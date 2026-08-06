import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../datasource/academy_remote_data_source.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/lesson_progress_model.dart';

/// Repository for the Cyber Academy feature.
///
/// Encapsulates data access via [AcademyRemoteDataSource] and maps results
/// into safe [Result] types. Free of UI, navigation, and storage concerns.
class AcademyRepository {
  final AcademyRemoteDataSource _remoteDataSource;

  /// Creates an [AcademyRepository] with the given [AcademyRemoteDataSource].
  const AcademyRepository(this._remoteDataSource);

  /// Fetches all available courses.
  Future<Result<List<CourseModel>>> getCourses() async {
    return _execute(() => _remoteDataSource.fetchCourses());
  }

  /// Fetches a single course by [courseId].
  Future<Result<CourseModel>> getCourse(String courseId) async {
    return _execute(() => _remoteDataSource.fetchCourse(courseId));
  }

  /// Fetches a single lesson by [lessonId].
  Future<Result<LessonModel>> getLesson(String lessonId) async {
    return _execute(() => _remoteDataSource.fetchLesson(lessonId));
  }

  /// Marks a lesson as completed.
  ///
  /// Returns the updated [LessonProgressModel] on success.
  Future<Result<LessonProgressModel>> markLessonComplete(
    String lessonId,
  ) async {
    return _execute(() => _remoteDataSource.completeLesson(lessonId));
  }

  /// Fetches the current user's progress across all enrolled courses.
  Future<Result<List<LessonProgressModel>>> getUserProgress() async {
    return _execute(() => _remoteDataSource.fetchUserProgress());
  }

  /// Enrolls the current user in a course by [courseId].
  Future<Result<void>> enrollInCourse(String courseId) async {
    return _execute(() => _remoteDataSource.enrollCourse(courseId));
  }

  // ── Private Helpers ─────────────────────────────────────────────────────────

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('An unexpected Academy error occurred: $e'));
    }
  }
}
