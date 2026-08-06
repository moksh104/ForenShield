import '../../../../core/network/api_client.dart';
import '../../../../models/auth_response_model.dart';
import '../../../../models/user_model.dart';
import '../../services/auth_service.dart';

/// Remote data source for authentication endpoints.
///
/// Uses [AuthService] for executing Dio REST API network calls.
class AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSource(ApiClient apiClient)
      : _authService = ApiAuthService(apiClient);

  /// Authenticates a user with [email] and [password].
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    return _authService.login(email: email, password: password);
  }

  /// Registers a new user with [email], [password], and [displayName].
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return _authService.register(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  /// Placeholder for forgot password feature.
  Future<bool> forgotPassword({required String email}) async {
    return false;
  }

  /// Placeholder for 2FA OTP verification.
  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    throw UnimplementedError();
  }

  /// Invalidates the user session on the server.
  Future<void> logout({String? refreshToken}) async {
    await _authService.logout(refreshToken: refreshToken);
  }

  /// Retrieves the currently authenticated user profile.
  Future<UserModel> getCurrentUser() async {
    return _authService.getCurrentUser();
  }
}
