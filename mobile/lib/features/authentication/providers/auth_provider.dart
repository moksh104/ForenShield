import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/logger/app_logger.dart';
import '../../../models/user_model.dart';
import '../data/repository/auth_repository.dart';
import 'auth_providers.dart';

/// Auth state
class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storage;

  AuthNotifier(this._authRepository, this._storage) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await _storage.getAccessToken();

      if (token != null && token.isNotEmpty) {
        final result = await _authRepository.getCurrentUser();
        result.when(
          success: (user) {
            state = AuthState(
              user: user,
              isAuthenticated: true,
              isLoading: false,
            );
          },
          failure: (exception) {
            AppLogger.error('Auth restore failed', error: exception);
            state = const AuthState(isLoading: false);
          },
        );
      } else {
        state = const AuthState(isLoading: false);
      }
    } catch (e) {
      AppLogger.error('Auth check failed', error: e);
      await _storage.clearSession();
      state = const AuthState(isLoading: false);
    }
  }

  /// Login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      result.when(
        success: (response) async {
          await _storage.saveAccessToken(response.accessToken);
          await _storage.saveRefreshToken(response.refreshToken);
          await _storage.write(StorageKeys.userId, response.user.id);

          state = AuthState(
            user: response.user,
            isAuthenticated: true,
            isLoading: false,
          );

          AppLogger.info('Login successful');
        },
        failure: (exception) {
          final message = exception is AppException
              ? exception.userMessage
              : AppConstants.errorGeneric;
          state = state.copyWith(isLoading: false, error: message);
          AppLogger.error('Login failed', error: exception);
        },
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: AppConstants.errorGeneric,
      );
      AppLogger.error('Login failed', error: e, stackTrace: stackTrace);
    }
  }

  /// Register
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );

      result.when(
        success: (response) async {
          await _storage.saveAccessToken(response.accessToken);
          await _storage.saveRefreshToken(response.refreshToken);
          await _storage.write(StorageKeys.userId, response.user.id);

          state = AuthState(
            user: response.user,
            isAuthenticated: true,
            isLoading: false,
          );

          AppLogger.info('Registration successful');
        },
        failure: (exception) {
          final message = exception is AppException
              ? exception.userMessage
              : AppConstants.errorGeneric;
          state = state.copyWith(isLoading: false, error: message);
          AppLogger.error('Registration failed', error: exception);
        },
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: AppConstants.errorGeneric,
      );
      AppLogger.error('Registration failed', error: e, stackTrace: stackTrace);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      AppLogger.warning('Logout API call failed', error: e);
    }

    await _storage.clearSession();
    state = const AuthState();
    AppLogger.info('Logout successful');
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth state notifier provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    ref.read(storageServiceProvider),
  );
});
