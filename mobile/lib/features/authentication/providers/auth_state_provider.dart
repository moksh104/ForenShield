import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/utils/result.dart';
import '../../../models/auth_response_model.dart';
import '../../../models/user_model.dart';
import '../data/repository/auth_repository.dart';
import '../services/token_service.dart';
import 'auth_providers.dart';

/// Provides the current authentication state and exposes methods to manage it.
final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, UserModel?>(
  () {
    return AuthStateNotifier();
  },
);

/// A robust state notifier that manages the user's authentication lifecycle.
class AuthStateNotifier extends AsyncNotifier<UserModel?> {
  late final AuthRepository _repo;
  late final StorageService _storage;
  late final TokenService _tokenService;

  @override
  Future<UserModel?> build() async {
    AppLogger.d('[AuthStateNotifier] Initializing auth state from storage...');
    _repo = ref.read(authRepositoryProvider);
    _storage = ref.read(storageServiceProvider);
    _tokenService = TokenService();

    if (await _tokenService.isLoggedIn()) {
      final storedUser = await _tokenService.getUser();
      if (storedUser != null) {
        AppLogger.d(
          '[AuthStateNotifier] Found saved user in storage: ${storedUser.email}',
        );
        return storedUser;
      }

      AppLogger.d(
        '[AuthStateNotifier] Access token exists. Fetching current user profile...',
      );
      final result = await _repo.getCurrentUser();

      if (result.isSuccess) {
        final user = (result as Success<UserModel>).data;
        await _tokenService.saveUser(user);
        AppLogger.d(
          '[AuthStateNotifier] Current user profile fetched successfully: ${user.email}',
        );
        return user;
      } else {
        AppLogger.w(
          '[AuthStateNotifier] Fetching current user failed. Clearing session.',
        );
        await _tokenService.removeToken();
        await _storage.clearSession();
        return null;
      }
    }

    AppLogger.d('[AuthStateNotifier] No active session found.');
    return null;
  }

  /// Refreshes the currently authenticated user's profile from the backend.
  Future<Result<void>> refreshUser() async {
    if (state.value == null) return const Success(null);

    final result = await _repo.getCurrentUser();

    if (result.isSuccess) {
      final user = (result as Success<UserModel>).data;
      await _tokenService.saveUser(user);
      state = AsyncValue.data(user);
      return const Success(null);
    } else {
      return Failure((result as Failure<UserModel>).exception);
    }
  }

  /// Attempts to log the user in using [email] and [password].
  ///
  /// Updates provider state and securely persists accessToken, refreshToken, and user object via FlutterSecureStorage.
  Future<Result<void>> login(String email, String password) async {
    AppLogger.d('[AuthStateNotifier] Initiating login for email: $email');

    final result = await _repo.login(email: email, password: password);

    if (result.isSuccess) {
      final response = (result as Success<AuthResponseModel>).data;
      AppLogger.d(
        '[AuthStateNotifier] Login API call succeeded! Storing tokens and user data...',
      );

      // Store accessToken, refreshToken, and user object via flutter_secure_storage
      await _tokenService.saveToken(response.accessToken);
      await _tokenService.saveRefreshToken(response.refreshToken);
      await _tokenService.saveUser(response.user);

      // Also persist to StorageService
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);

      // Save FCM Registration Token to backend
      await NotificationService.saveToken(response.user.id);

      AppLogger.d(
        '[AuthStateNotifier] Tokens stored successfully. Updating Riverpod state to user: ${response.user.email}',
      );
      state = AsyncValue.data(response.user);
      return const Success(null);
    } else {
      final ex = (result as Failure<AuthResponseModel>).exception;
      AppLogger.e('[AuthStateNotifier] Login failed with error: $ex');
      return Failure(ex);
    }
  }

  /// Attempts to register a new user using [email], [password], and [displayName].
  Future<Result<void>> register(
    String email,
    String password,
    String displayName,
  ) async {
    AppLogger.d(
      '[AuthStateNotifier] Initiating registration for email: $email',
    );

    final result = await _repo.register(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (result.isSuccess) {
      final response = (result as Success<AuthResponseModel>).data;
      AppLogger.d(
        '[AuthStateNotifier] Registration succeeded! Storing tokens...',
      );
      await _tokenService.saveToken(response.accessToken);
      await _tokenService.saveRefreshToken(response.refreshToken);
      await _tokenService.saveUser(response.user);

      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);

      // Save FCM Registration Token to backend
      await NotificationService.saveToken(response.user.id);

      state = AsyncValue.data(response.user);
      return const Success(null);
    } else {
      final ex = (result as Failure<AuthResponseModel>).exception;
      AppLogger.e('[AuthStateNotifier] Registration failed: $ex');
      return Failure(ex);
    }
  }

  /// Verifies a 6-digit OTP code via backend.
  Future<Result<void>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    AppLogger.d('[AuthStateNotifier] Verifying OTP for email: $email');

    final result = await _repo.verifyOtp(email: email, otpCode: otpCode);

    if (result.isSuccess) {
      final response = (result as Success<AuthResponseModel>).data;
      AppLogger.d(
        '[AuthStateNotifier] OTP verification succeeded! Storing tokens...',
      );
      await _tokenService.saveToken(response.accessToken);
      await _tokenService.saveRefreshToken(response.refreshToken);
      await _tokenService.saveUser(response.user);

      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);

      state = AsyncValue.data(response.user);
      return const Success(null);
    } else {
      final ex = (result as Failure<AuthResponseModel>).exception;
      AppLogger.e('[AuthStateNotifier] OTP verification failed: $ex');
      return Failure(ex);
    }
  }

  /// Logs the user out.
  Future<void> logout() async {
    state = const AsyncValue.loading();

    final refreshToken =
        await _tokenService.getRefreshToken() ??
        await _storage.getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _repo.logout(refreshToken: refreshToken);
    }

    await _tokenService.removeToken();
    await _storage.clearSession();

    state = const AsyncValue.data(null);
  }

  /// Manually sets authenticated state given an [AuthResponseModel].
  Future<void> authenticateWithResponse(AuthResponseModel response) async {
    await _tokenService.saveToken(response.accessToken);
    await _tokenService.saveRefreshToken(response.refreshToken);
    await _tokenService.saveUser(response.user);
    await _storage.saveAccessToken(response.accessToken);
    await _storage.saveRefreshToken(response.refreshToken);
    state = AsyncValue.data(response.user);
  }
}
