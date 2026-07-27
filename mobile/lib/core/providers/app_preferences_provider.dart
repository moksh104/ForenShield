import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

// ── Low-level SharedPreferences Instance ──────────────────────────────────────

/// Provides the raw [SharedPreferences] instance.
///
/// Initialised once on app startup. All higher-level preference providers
/// derive from this single instance to avoid redundant I/O.
///
/// Usage in GoRouter or widgets:
/// ```dart
/// final prefs = await ref.read(sharedPreferencesProvider.future);
/// ```
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return SharedPreferences.getInstance();
});

// ── Onboarding ─────────────────────────────────────────────────────────────────

/// `true` if the user has completed onboarding at least once.
///
/// Async — resolves to `false` if SharedPreferences is unavailable.
/// The GoRouter redirect guard awaits this provider before deciding navigation.
final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool(StorageKeys.hasSeenOnboarding) ?? false;
});

// ── Onboarding Writer ──────────────────────────────────────────────────────────

/// Marks onboarding as complete and persists the flag.
///
/// Call this once from the final onboarding screen when the user taps
/// "Get Started" or "I already have an account".
///
/// ```dart
/// await ref.read(markOnboardingCompleteProvider)();
/// ```
final markOnboardingCompleteProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(StorageKeys.hasSeenOnboarding, true);
    // Invalidate so GoRouter redirect re-evaluates on next listen.
    ref.invalidate(hasSeenOnboardingProvider);
  };
});
