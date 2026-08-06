import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../models/auth_response_model.dart';
import '../../../models/user_model.dart';

/// Defines a contract for authentication operations.
abstract class AuthService {
  /// Authenticates a user with [email] and [password] via `POST /login.php`.
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Registers a new user via `POST /register.php`.
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Invalidates the user session via `POST /logout.php`.
  Future<void> logout({String? refreshToken});

  /// Fetches the authenticated user profile via `GET /current_user.php`.
  Future<UserModel> getCurrentUser();
}

/// Concrete Dio-based HTTP implementation of [AuthService].
class ApiAuthService implements AuthService {
  final ApiClient _apiClient;

  ApiAuthService(this._apiClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Invalid server response format.');
      }

      if (data.containsKey('error') && data['error'] != null) {
        throw Exception(data['error'].toString());
      }

      return AuthResponseModel.fromJson(data);
    } on DioException catch (e) {
      if (e.error != null) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {
          'full_name': displayName,
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Invalid server response format.');
      }

      if (data.containsKey('error') && data['error'] != null) {
        throw Exception(data['error'].toString());
      }

      return AuthResponseModel.fromJson(data);
    } on DioException catch (e) {
      if (e.error != null) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<void> logout({String? refreshToken}) async {
    await _apiClient.post<dynamic>(
      ApiEndpoints.logout,
      data: refreshToken != null ? {'refreshToken': refreshToken} : null,
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.currentUser,
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Invalid server response format.');
    }

    return UserModel.fromJson(data);
  }
}
