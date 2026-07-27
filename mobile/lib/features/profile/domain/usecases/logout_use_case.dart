import '../../../authentication/providers/auth_state_provider.dart';

/// UseCase to perform user logout.
class LogoutUseCase {
  final AuthStateNotifier _authStateNotifier;

  const LogoutUseCase(this._authStateNotifier);

  Future<void> call() async {
    await _authStateNotifier.logout();
  }
}
