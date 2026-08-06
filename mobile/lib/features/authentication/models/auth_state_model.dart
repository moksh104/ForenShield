import '../../../models/user_model.dart';

/// Global authentication state for the application.
///
/// Used by the router guard and authentication provider to represent the
/// user's current session status with an explicit enum.
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

class AuthStateModel {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthStateModel({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  const AuthStateModel.initial()
      : status = AuthStatus.initial,
        user = null,
        error = null;

  const AuthStateModel.authenticated(this.user)
      : status = AuthStatus.authenticated,
        error = null;

  const AuthStateModel.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        error = null;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  AuthStateModel copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
  }) {
    return AuthStateModel(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}
