import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../models/auth_response_model.dart';
import '../../../models/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: e.message ?? 'Login failed',
        statusCode: e.response?.statusCode ?? 0,
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Register a new user
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'displayName': displayName,
        },
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: e.message ?? 'Registration failed',
        statusCode: e.response?.statusCode ?? 0,
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Ignore logout errors - will clear local storage anyway
    }
  }

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/auth/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: e.message ?? 'Failed to fetch user',
        statusCode: e.response?.statusCode ?? 0,
        type: ApiExceptionType.unknown,
      );
    }
  }
}
