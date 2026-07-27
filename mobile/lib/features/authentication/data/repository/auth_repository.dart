import '../../../../core/utils/result.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../models/auth_response_model.dart';
import '../../../../models/user_model.dart';
import '../datasource/auth_remote_data_source.dart';

/// Abstract contract interface for authentication-related operations.
abstract class AuthRepository {
  /// Authenticates a user with [email] and [password].
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  });

  /// Registers a new user with [email], [password], and [displayName].
  Future<Result<AuthResponseModel>> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Invalidates the current user session.
  Future<Result<void>> logout();

  /// Retrieves the currently authenticated user's profile.
  Future<Result<UserModel>> getCurrentUser();
}

/// Remote REST implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  /// Creates a new [AuthRepositoryImpl] with the given [_remoteDataSource].
  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    return _execute(() => _remoteDataSource.login(
      email: email,
      password: password,
    ));
  }

  @override
  Future<Result<AuthResponseModel>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return _execute(() => _remoteDataSource.register(
      email: email,
      password: password,
      displayName: displayName,
    ));
  }

  @override
  Future<Result<void>> logout() async {
    return _execute(() async {
      await _remoteDataSource.logout();
    });
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    return _execute(() => _remoteDataSource.getCurrentUser());
  }

  // ── Private Helpers ─────────────────────────────────────────────────────────

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Success(result);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('An unexpected error occurred: $e'));
    }
  }
}
