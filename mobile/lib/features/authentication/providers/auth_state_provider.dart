import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/utils/result.dart';
import '../../../models/auth_response_model.dart';
import '../../../models/user_model.dart';
import '../data/repository/auth_repository.dart';
import 'auth_providers.dart';

/// Provides the current authentication state and exposes methods to manage it.
final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, UserModel?>(() {
  return AuthStateNotifier();
});

/// A robust state notifier that manages the user's authentication lifecycle.
///
/// Acts as the single source of truth for the router and the rest of the application
/// regarding who is currently logged in.
class AuthStateNotifier extends AsyncNotifier<UserModel?> {
  late final AuthRepository _repo;
  late final StorageService _storage;

  @override
  Future<UserModel?> build() async {
    _repo = ref.read(authRepositoryProvider);
    _storage = ref.read(storageServiceProvider);
    
    if (await _storage.isLoggedIn()) {
      final result = await _repo.getCurrentUser();
      
      if (result.isSuccess) {
        return (result as Success<UserModel>).data;
      } else {
        // If restoring the session fails (e.g., token invalid or expired),
        // we must clear the local session to prevent the app from getting stuck.
        await _storage.clearSession();
        return null;
      }
    }
    
    return null;
  }

  /// Refreshes the currently authenticated user's profile from the backend.
  /// 
  /// Updates the provider state with the fresh [UserModel] if successful.
  Future<Result<void>> refreshUser() async {
    if (state.value == null) return const Success(null);

    final result = await _repo.getCurrentUser();
    
    if (result.isSuccess) {
      state = AsyncValue.data((result as Success<UserModel>).data);
      return const Success(null);
    } else {
      return Failure((result as Failure<UserModel>).exception);
    }
  }

  /// Attempts to log the user in using [email] and [password].
  /// 
  /// Updates the provider state and securely persists tokens on success.
  Future<Result<void>> login(String email, String password) async {
    final previousState = state.value;
    state = const AsyncValue.loading();
    
    final result = await _repo.login(email: email, password: password);
    
    if (result.isSuccess) {
      final response = (result as Success<AuthResponseModel>).data;
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);
      
      state = AsyncValue.data(response.user);
      return const Success(null);
    } else {
      // Revert to the previous state instead of strictly nulling it out
      state = AsyncValue.data(previousState);
      return Failure((result as Failure<AuthResponseModel>).exception);
    }
  }

  /// Attempts to register a new user using [email], [password], and [displayName].
  /// 
  /// Updates the provider state and securely persists tokens on success.
  Future<Result<void>> register(String email, String password, String displayName) async {
    final previousState = state.value;
    state = const AsyncValue.loading();
    
    final result = await _repo.register(
      email: email, 
      password: password, 
      displayName: displayName,
    );
    
    if (result.isSuccess) {
      final response = (result as Success<AuthResponseModel>).data;
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);
      
      state = AsyncValue.data(response.user);
      return const Success(null);
    } else {
      // Revert to the previous state instead of strictly nulling it out
      state = AsyncValue.data(previousState);
      return Failure((result as Failure<AuthResponseModel>).exception);
    }
  }

  /// Logs the user out.
  /// 
  /// Invokes the remote logout endpoint and guarantees local session cleanup
  /// regardless of the remote outcome.
  Future<void> logout() async {
    state = const AsyncValue.loading();
    
    // Fire the remote logout, but we don't strictly care if it fails due to network issues
    await _repo.logout();
    
    // Always clear the local session to guarantee logout finishes locally
    await _storage.clearSession();
    
    state = const AsyncValue.data(null);
  }
}
