import '../../../../core/utils/result.dart';
import '../entities/course_entity.dart';
import '../entities/lesson_entity.dart';
import '../entities/quiz_entity.dart';

/// Contract interface for Cyber Academy Course Repository.
abstract class CourseRepository {
  /// Fetches all courses with optional category & search filter.
  Future<Result<List<CourseEntity>>> getCourses({
    String? category,
    String? searchQuery,
  });

  /// Fetches a single course details by ID.
  Future<Result<CourseEntity>> getCourseDetail(String courseId);

  /// Fetches a single lesson by ID.
  Future<Result<LessonEntity>> getLesson(String lessonId);

  /// Marks a lesson as completed.
  Future<Result<LessonEntity>> markLessonCompleted(String lessonId);

  /// Fetches quiz for a course or lesson.
  Future<Result<QuizEntity>> getQuiz(String quizId);

  /// Submits quiz answers and returns score percentage.
  Future<Result<int>> submitQuiz({
    required String quizId,
    required Map<String, int> selectedOptions,
  });
}
