import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/category_model.dart';
import '../models/achievement_model.dart';

/// Remote data source responsible for calling Academy-related API endpoints.
///
/// Uses [ApiClient] (Dio) for HTTP calls and throws [ApiException] on failures.
class AcademyRemoteDataSource {
  final ApiClient _apiClient;

  const AcademyRemoteDataSource(this._apiClient);

  /// Fetch featured courses from the server
  Future<List<CourseModel>> fetchFeaturedCourses() async {
    try {
      final response = await _apiClient.get('/academy/featured');
      final data = response.data;
      if (data is List) {
        return data.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw const ApiException(message: 'Invalid response', statusCode: 500, type: ApiExceptionType.serverError);
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(message: e.message ?? 'Failed to fetch featured courses', statusCode: e.response?.statusCode ?? 0, type: ApiExceptionType.unknown);
    }
  }

  /// Fetch recommended courses
  Future<List<CourseModel>> fetchRecommendedCourses() async {
    try {
      final response = await _apiClient.get('/academy/recommended');
      final data = response.data;
      if (data is List) {
        return data.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw const ApiException(message: 'Invalid response', statusCode: 500, type: ApiExceptionType.serverError);
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(message: e.message ?? 'Failed to fetch recommended courses', statusCode: e.response?.statusCode ?? 0, type: ApiExceptionType.unknown);
    }
  }

  /// Fetch categories
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _apiClient.get('/academy/categories');
      final data = response.data;
      if (data is List) {
        return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw const ApiException(message: 'Invalid response', statusCode: 500, type: ApiExceptionType.serverError);
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(message: e.message ?? 'Failed to fetch categories', statusCode: e.response?.statusCode ?? 0, type: ApiExceptionType.unknown);
    }
  }

  /// Fetch recent lessons
  Future<List<LessonModel>> fetchRecentLessons() async {
    try {
      final response = await _apiClient.get('/academy/recent-lessons');
      final data = response.data;
      if (data is List) {
        return data.map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw const ApiException(message: 'Invalid response', statusCode: 500, type: ApiExceptionType.serverError);
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(message: e.message ?? 'Failed to fetch recent lessons', statusCode: e.response?.statusCode ?? 0, type: ApiExceptionType.unknown);
    }
  }

  /// Fetch achievements
  Future<List<AchievementModel>> fetchAchievements() async {
    try {
      final response = await _apiClient.get('/academy/achievements');
      final data = response.data;
      if (data is List) {
        return data.map((e) => AchievementModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw const ApiException(message: 'Invalid response', statusCode: 500, type: ApiExceptionType.serverError);
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(message: e.message ?? 'Failed to fetch achievements', statusCode: e.response?.statusCode ?? 0, type: ApiExceptionType.unknown);
    }
  }

  /// Fetch course details (single course)
  Future<CourseModel> fetchCourse(String courseId) async {
    try {
      final response = await _apiClient.get('/academy/courses/$courseId');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return CourseModel.fromJson(data);
      }
      throw const ApiException(message: 'Invalid response', statusCode: 500, type: ApiExceptionType.serverError);
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(message: e.message ?? 'Failed to fetch course', statusCode: e.response?.statusCode ?? 0, type: ApiExceptionType.unknown);
    }
  }
}
