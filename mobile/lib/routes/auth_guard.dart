import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'route_constants.dart';
import 'router_notifier.dart';

/// A production-grade navigation guard that manages the application's routing logic.
///
/// Intercepts all navigation events and enforces:
/// 1. The Onboarding flow (ensures new users complete onboarding).
/// 2. The Authentication flow (protects private routes and redirects logged-in users).
///
/// Consumes state supplied by [RouterNotifier] without making Riverpod `ref.read` or
/// `ref.watch` calls inside the redirect callback.
class AuthGuard {
  AuthGuard._();

  /// Evaluates the current state provided by [notifier] and returns a redirect location if necessary.
  ///
  /// Returning `null` means no redirect is required and navigation should proceed.
  static String? redirect(
    BuildContext context,
    GoRouterState state,
    RouterNotifier notifier,
  ) {
    final location = state.matchedLocation;

    // Never redirect away from the internal developer tool catalog.
    if (_isInternalRoute(location)) return null;

    final isSplash = _isSplashRoute(location);
    final isOnboarding = _isOnboardingRoute(location);
    final isAuthRoute = _isAuthRoute(location);

    final hasSeenOnboardingAsync = notifier.hasSeenOnboarding;
    final authState = notifier.authState;

    // 1. Wait for critical state to initialize.
    // Keep user on Splash screen until both onboarding and auth states have finished loading.
    if (hasSeenOnboardingAsync.isLoading || authState.isLoading) {
      return isSplash ? null : RouteConstants.splash;
    }

    final hasSeenOnboarding = hasSeenOnboardingAsync.value ?? false;
    final isLoggedIn = authState.value != null;

    // 2. Enforce Onboarding Flow
    if (!hasSeenOnboarding) {
      if (!isOnboarding && !isSplash) return RouteConstants.onboarding;
      if (isSplash) return RouteConstants.onboarding;
      return null;
    }

    // 3. Enforce Authentication Flow
    if (isLoggedIn) {
      // Authenticated users shouldn't see splash, onboarding, or auth screens.
      if (isSplash || isOnboarding || isAuthRoute) {
        return RouteConstants.missionControl; // Default authenticated route
      }
      return null;
    } else {
      // Unauthenticated users trying to access protected routes go to login.
      if (!isAuthRoute && !isSplash && !isOnboarding) {
        return RouteConstants.login;
      }
      // If they are on splash or onboarding (and already saw onboarding), send them to login.
      if (isSplash || isOnboarding) {
        return RouteConstants.login;
      }
      return null;
    }
  }

  // ── Private Route Classifiers ───────────────────────────────────────────────

  static bool _isInternalRoute(String location) {
    return location.startsWith(RouteConstants.catalog);
  }

  static bool _isSplashRoute(String location) {
    return location == RouteConstants.splash;
  }

  static bool _isOnboardingRoute(String location) {
    return location == RouteConstants.onboarding;
  }

  static bool _isAuthRoute(String location) {
    return location == RouteConstants.login ||
        location == RouteConstants.register ||
        location == RouteConstants.forgotPassword ||
        location == RouteConstants.forgotPasswordSuccess;
  }
}
