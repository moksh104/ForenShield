import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../core/logger/app_logger.dart';
import 'route_constants.dart';
import 'router_notifier.dart';

/// A production-grade navigation guard that manages the application's routing logic.
///
/// Intercepts all navigation events and enforces:
/// 1. The Onboarding flow (ensures new users complete onboarding).
/// 2. Protected Routes (Dashboard, Mission Control, Cyber Academy, Reports,
///    Investigation Lab, Simulation Lab).
/// 3. Redirection of unauthenticated users to the Login screen.
class AuthGuard {
  AuthGuard._();

  /// Evaluates current state provided by [notifier] and returns a redirect location if necessary.
  ///
  /// Returning `null` means no redirect is required and navigation should proceed.
  static String? redirect(
    BuildContext context,
    GoRouterState state,
    RouterNotifier notifier,
  ) {
    final location = state.matchedLocation;

    // 1. Never redirect away from the internal developer tool catalog.
    if (_isInternalRoute(location)) return null;

    final isSplash = _isSplashRoute(location);
    final isOnboarding = _isOnboardingRoute(location);
    final isAuthRoute = _isAuthRoute(location);
    final isProtectedRoute = _isProtectedRoute(location);

    final hasSeenOnboardingAsync = notifier.hasSeenOnboarding;
    final authState = notifier.authState;

    // 2. Allow SplashScreen to display and perform its session-aware completion navigation.
    if (isSplash) {
      return null;
    }

    // 3. For all other routes, wait for critical state to initialize.
    if (hasSeenOnboardingAsync.isLoading || authState.isLoading) {
      return RouteConstants.splash;
    }

    final hasSeenOnboarding = hasSeenOnboardingAsync.value ?? false;
    final isLoggedIn = authState.value != null;

    AppLogger.d(
      '[AuthGuard] Redirect evaluation -> Location: "$location" | '
      'isLoggedIn: $isLoggedIn | hasSeenOnboarding: $hasSeenOnboarding | '
      'user: ${authState.value?.email}',
    );

    // 4. Enforce Authentication Flow for Authenticated Users
    if (isLoggedIn) {
      if (isOnboarding || isAuthRoute) {
        AppLogger.d(
          '[AuthGuard] Authenticated user on non-protected page "$location". Redirecting to Home (Mission Control).',
        );
        return RouteConstants.missionControl;
      }
      return null;
    }

    // 5. Enforce Onboarding Flow for Unauthenticated Users
    if (!hasSeenOnboarding) {
      if (!isOnboarding) {
        AppLogger.d(
          '[AuthGuard] Unauthenticated user needs onboarding. Redirecting to Onboarding.',
        );
        return RouteConstants.onboarding;
      }
      return null;
    }

    // 6. Unauthenticated users accessing protected routes must be redirected to login.
    if (isProtectedRoute || !isAuthRoute) {
      AppLogger.d(
        '[AuthGuard] Unauthenticated user attempting to access protected route "$location". Redirecting to Login.',
      );
      return RouteConstants.login;
    }

    return null;
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
        location == RouteConstants.otp ||
        location == RouteConstants.forgotPassword ||
        location == RouteConstants.forgotPasswordSuccess;
  }

  /// Returns whether a location requires an authenticated user session.
  ///
  /// Protected domains:
  /// - Dashboard (`/dashboard`)
  /// - Mission Control (`/mission-control`)
  /// - Cyber Academy (`/academy`)
  /// - Reports (`/reports`)
  /// - Investigation Lab (`/investigation`)
  /// - Simulation Lab (`/simulation`)
  /// - Profile & Settings
  static bool _isProtectedRoute(String location) {
    return location.startsWith(RouteConstants.dashboard) ||
        location.startsWith(RouteConstants.missionControl) ||
        location.startsWith(RouteConstants.academy) ||
        location.startsWith(RouteConstants.reports) ||
        location.startsWith(RouteConstants.investigation) ||
        location.startsWith(RouteConstants.simulation) ||
        location.startsWith(RouteConstants.profile) ||
        location == RouteConstants.settings;
  }
}
