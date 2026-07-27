import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

/// Implementation of [CourseRepository].
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remoteDataSource;

  const CourseRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<CourseEntity>>> getCourses({
    String? category,
    String? searchQuery,
  }) async {
    try {
      final courses = await _remoteDataSource.getCourses(
        category: category,
        searchQuery: searchQuery,
      );
      return Success(courses);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load courses: $e'));
    }
  }

  @override
  Future<Result<CourseEntity>> getCourseDetail(String courseId) async {
    try {
      final course = await _remoteDataSource.getCourseDetail(courseId);
      return Success(course);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load course details: $e'));
    }
  }

  @override
  Future<Result<LessonEntity>> getLesson(String lessonId) async {
    try {
      final lesson = await _remoteDataSource.getLesson(lessonId);
      return Success(lesson);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load lesson: $e'));
    }
  }

  @override
  Future<Result<LessonEntity>> markLessonCompleted(String lessonId) async {
    try {
      final lesson = await _remoteDataSource.getLesson(lessonId);
      final updated = lesson.copyWith(isCompleted: true);
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to mark lesson completed: $e'));
    }
  }

  @override
  Future<Result<QuizEntity>> getQuiz(String quizId) async {
    try {
      final course = await _remoteDataSource.getCourseDetail('crs_1');
      if (course.quiz != null) {
        return Success(course.quiz!);
      }
      return Failure(const NotFoundException('Quiz not found'));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load quiz: $e'));
    }
  }

  @override
  Future<Result<int>> submitQuiz({
    required String quizId,
    required Map<String, int> selectedOptions,
  }) async {
    try {
      final score = await _remoteDataSource.submitQuiz(
        quizId: quizId,
        selectedOptions: selectedOptions,
      );
      return Success(score);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to submit quiz: $e'));
    }
  }
}
