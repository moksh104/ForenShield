import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/providers.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/utils/logger.dart';
import '../../../models/user_model.dart';
import '../data/auth_repository.dart';

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

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(apiClientProvider));
});

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storage;

  AuthNotifier(this._authRepository, this._storage)
      : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await _storage.read(AppConstants.keyAccessToken);
      
      if (token != null && token.isNotEmpty) {
        final user = await _authRepository.getCurrentUser();
        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = const AuthState(isLoading: false);
      }
    } catch (e) {
      AppLogger.error('Auth check failed', error: e);
      await _storage.deleteAll();
      state = const AuthState(isLoading: false);
    }
  }

  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      // Save tokens
      await _storage.write(AppConstants.keyAccessToken, response.accessToken);
      await _storage.write(AppConstants.keyRefreshToken, response.refreshToken);
      await _storage.write(AppConstants.keyUserId, response.user.id);

      state = AuthState(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );

      AppLogger.info('Login successful');
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
      AppLogger.error('Login failed', error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AppConstants.errorGeneric,
      );
      AppLogger.error('Login failed', error: e);
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
      final response = await _authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Save tokens
      await _storage.write(AppConstants.keyAccessToken, response.accessToken);
      await _storage.write(AppConstants.keyRefreshToken, response.refreshToken);
      await _storage.write(AppConstants.keyUserId, response.user.id);

      state = AuthState(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );

      AppLogger.info('Registration successful');
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
      AppLogger.error('Registration failed', error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AppConstants.errorGeneric,
      );
      AppLogger.error('Registration failed', error: e);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      AppLogger.warning('Logout API call failed', error: e);
    }

    await _storage.deleteAll();
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
