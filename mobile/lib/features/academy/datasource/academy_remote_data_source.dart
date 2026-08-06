import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/lesson_progress_model.dart';

/// Remote data source for Academy endpoints.
///
/// Handles direct communication with the ForenShield API and parses
/// responses into Academy domain models.
/// Contains no business logic.
class AcademyRemoteDataSource {
  final ApiClient _apiClient;

  /// Creates an [AcademyRemoteDataSource] with the given [ApiClient].
  const AcademyRemoteDataSource(this._apiClient);

  /// Fetches all available courses from the API.
  Future<List<CourseModel>> fetchCourses() async {
    final response = await _apiClient.get<List<dynamic>>(ApiEndpoints.lessons);
    final data = response.data;
    if (data == null) return [];
    return data
        .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single course by its [courseId].
  Future<CourseModel> fetchCourse(String courseId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.lessons}/$courseId',
    );
    if (response.data == null) {
      throw StateError('No data returned for course $courseId');
    }
    return CourseModel.fromJson(response.data!);
  }

  /// Fetches a single lesson by its [lessonId].
  Future<LessonModel> fetchLesson(String lessonId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.lesson(lessonId),
    );
    if (response.data == null) {
      throw StateError('No data returned for lesson $lessonId');
    }
    return LessonModel.fromJson(response.data!);
  }

  /// Marks a lesson as completed on the server.
  ///
  /// Returns the updated [LessonProgressModel].
  Future<LessonProgressModel> completeLesson(String lessonId) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '${ApiEndpoints.lesson(lessonId)}/complete',
    );
    if (response.data == null) {
      throw StateError('No data returned for lesson completion $lessonId');
    }
    return LessonProgressModel.fromJson(response.data!);
  }

  /// Fetches the current user's progress across all enrolled courses.
  Future<List<LessonProgressModel>> fetchUserProgress() async {
    final response = await _apiClient.get<List<dynamic>>(
      '${ApiEndpoints.lessons}/progress',
    );
    final data = response.data;
    if (data == null) return [];
    return data
        .map((e) => LessonProgressModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Enrolls the current user in a course by [courseId].
  Future<void> enrollCourse(String courseId) async {
    await _apiClient.post<void>('${ApiEndpoints.lessons}/$courseId/enroll');
  }
}
