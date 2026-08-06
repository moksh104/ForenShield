import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state_model.dart';
import 'auth_state_provider.dart';

/// A derived provider exposing the current auth status as a stable enum.
final authStatusProvider = Provider<AuthStatus>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState.isLoading) {
    return AuthStatus.loading;
  }

  final user = authState.asData?.value;
  if (user != null) {
    return AuthStatus.authenticated;
  }

  return AuthStatus.unauthenticated;
});
