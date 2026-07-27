import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../models/auth_response_model.dart';
import '../../../../models/user_model.dart';

/// Remote data source for authentication endpoints.
/// 
/// Handles network communication via [ApiClient] and safely parses API responses
/// into domain models.
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  /// Creates a new [AuthRemoteDataSource] with the given [_apiClient].
  AuthRemoteDataSource(this._apiClient);

  /// Authenticates a user with [email] and [password].
  /// 
  /// Returns an [AuthResponseModel] containing tokens and the user profile.
  /// Throws an [ApiException] if the response payload is malformed.
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    
    return _parseAuthResponse(response.data);
  }

  /// Registers a new user with [email], [password], and [displayName].
  /// 
  /// Returns an [AuthResponseModel] containing tokens and the user profile.
  /// Throws an [ApiException] if the response payload is malformed.
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'displayName': displayName,
      },
    );
    
    return _parseAuthResponse(response.data);
  }

  /// Invalidates the current user session on the server.
  /// 
  /// Throws an [ApiException] if the server returns an unexpected error.
  Future<void> logout() async {
    final response = await _apiClient.post<dynamic>(ApiEndpoints.logout);
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw const ApiException('Logout failed due to an unexpected server response.');
    }
  }

  /// Retrieves the currently authenticated user's profile.
  /// 
  /// Returns a [UserModel].
  /// Throws an [ApiException] if the response payload is malformed.
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.currentUser);
    final data = _validateData(response.data);
    return UserModel.fromJson(data);
  }

  // ── Private Helpers ─────────────────────────────────────────────────────────

  AuthResponseModel _parseAuthResponse(Map<String, dynamic>? data) {
    final map = _validateData(data);
    return AuthResponseModel.fromJson(map);
  }

  Map<String, dynamic> _validateData(Map<String, dynamic>? data) {
    if (data == null) {
      throw const ApiException('Invalid response format: Payload is null.');
    }
    return data;
  }
}
