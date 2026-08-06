import '../../../core/result.dart';
import '../../../core/network/api_exception.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/category_model.dart';
import '../models/achievement_model.dart';
import 'academy_remote_data_source.dart';

/// Repository that coordinates academy data access.
///
/// - Uses [AcademyRemoteDataSource] for network calls.
/// - Returns [Result<T>] to the caller. UI remains separated from implementation.
class AcademyRepository {
  final AcademyRemoteDataSource _remote;

  const AcademyRepository(this._remote);

  /// Fetch featured courses
  Future<Result<List<CourseModel>>> getFeaturedCourses() async {
    try {
      final list = await _remote.fetchFeaturedCourses();
      return Success(list);
    } on ApiException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(const ApiException(message: 'Unknown error', statusCode: 0, type: ApiExceptionType.unknown));
    }
  }

  /// Fetch recommended courses
  Future<Result<List<CourseModel>>> getRecommendedCourses() async {
    try {
      final list = await _remote.fetchRecommendedCourses();
      return Success(list);
    } on ApiException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(const ApiException(message: 'Unknown error', statusCode: 0, type: ApiExceptionType.unknown));
    }
  }

  /// Fetch categories
  Future<Result<List<CategoryModel>>> getCategories() async {
    try {
      final list = await _remote.fetchCategories();
      return Success(list);
    } on ApiException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(const ApiException(message: 'Unknown error', statusCode: 0, type: ApiExceptionType.unknown));
    }
  }

  /// Fetch recent lessons
  Future<Result<List<LessonModel>>> getRecentLessons() async {
    try {
      final list = await _remote.fetchRecentLessons();
      return Success(list);
    } on ApiException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(const ApiException(message: 'Unknown error', statusCode: 0, type: ApiExceptionType.unknown));
    }
  }

  /// Fetch achievements
  Future<Result<List<AchievementModel>>> getAchievements() async {
    try {
      final list = await _remote.fetchAchievements();
      return Success(list);
    } on ApiException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(const ApiException(message: 'Unknown error', statusCode: 0, type: ApiExceptionType.unknown));
    }
  }

  /// Get details for a single course
  Future<Result<CourseModel>> getCourse(String courseId) async {
    try {
      final course = await _remote.fetchCourse(courseId);
      return Success(course);
    } on ApiException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(const ApiException(message: 'Unknown error', statusCode: 0, type: ApiExceptionType.unknown));
    }
  }
}
