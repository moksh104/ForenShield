import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/app_preferences_provider.dart';
import '../features/authentication/providers/auth_state_provider.dart';
import '../models/user_model.dart';

/// Manages routing state changes without recreating [GoRouter] instances.
///
/// Listens to [hasSeenOnboardingProvider] and [authStateProvider] using [ref.listen]
/// and caches their latest [AsyncValue] states. Calls [notifyListeners] whenever either
/// provider emits a new value, triggering GoRouter redirection callbacks safely without
/// calling `ref.read` or `ref.watch` inside [AuthGuard.redirect].
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AsyncValue<bool> _hasSeenOnboarding = const AsyncValue.loading();
  AsyncValue<UserModel?> _authState = const AsyncValue.loading();

  AsyncValue<bool> get hasSeenOnboarding => _hasSeenOnboarding;
  AsyncValue<UserModel?> get authState => _authState;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<bool>>(
      hasSeenOnboardingProvider,
      (_, next) {
        _hasSeenOnboarding = next;
        notifyListeners();
      },
      fireImmediately: true,
    );

    _ref.listen<AsyncValue<UserModel?>>(
      authStateProvider,
      (_, next) {
        _authState = next;
        notifyListeners();
      },
      fireImmediately: true,
    );
  }
}

/// Provider for [RouterNotifier].
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
