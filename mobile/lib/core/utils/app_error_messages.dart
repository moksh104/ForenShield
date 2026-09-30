import '../exceptions/app_exceptions.dart';

/// Context hint used by [AppErrorMessages.from] to produce messages that
/// match what the user was actually trying to do.
enum AppErrorContext {
  general,
  login,
  register,
  forgotPassword,
  otp,
  profileLoad,
  profileSave,
  passwordChange,
  deleteAccount,
  missionControl,
  academy,
  investigation,
  mitre,
  simulation,
  logout,
}

/// Centralized converter from any [Object] error into a safe, human-friendly
/// UI string.
///
/// **Rule**: NOTHING from this class may ever expose internal class names,
/// HTTP status codes, stack traces, JWT text, SQL errors, or any other
/// developer-facing diagnostic.
///
/// Usage:
/// ```dart
/// errorMessage: AppErrorMessages.from(
///   exception,
///   context: AppErrorContext.missionControl,
/// ),
/// ```
class AppErrorMessages {
  AppErrorMessages._();

  /// Returns a user-friendly message for [error].
  ///
  /// Decision tree:
  /// 1. If [error] is a known [AppException] subtype, its [userMessage] is
  ///    usually already correct — but we layer contextual overrides on top
  ///    where needed (e.g. UnauthorizedException during login vs. mid-session).
  /// 2. For unknown/unexpected exception types we return a safe generic
  ///    message that never leaks implementation detail.
  static String from(
    Object error, {
    AppErrorContext context = AppErrorContext.general,
  }) {
    // ── 1. Known AppException hierarchy ──────────────────────────────────────
    if (error is NetworkException) {
      return 'We couldn\'t reach the server. Check your connection and try again.';
    }

    if (error is TimeoutException) {
      return 'The connection is taking longer than expected. Please try again.';
    }

    if (error is UnauthorizedException) {
      // Login screen gets a credentials-specific message.
      if (context == AppErrorContext.login) {
        return 'The email or password doesn\'t match our records.';
      }
      if (context == AppErrorContext.otp) {
        return 'That code doesn\'t look right. Please check it and try again.';
      }
      // All other authenticated flows get the session-expired message.
      return 'Your session has expired. Please sign in again.';
    }

    if (error is ForbiddenException) {
      return 'You don\'t have permission to access this content.';
    }

    if (error is NotFoundException) {
      return 'We couldn\'t find that information right now.';
    }

    if (error is ConflictException) {
      if (context == AppErrorContext.register) {
        return 'An account with this email already exists.';
      }
      return error.userMessage.isNotEmpty
          ? error.userMessage
          : 'A conflict occurred. Please try again.';
    }

    if (error is ValidationException) {
      if (context == AppErrorContext.otp) {
        return 'That code doesn\'t look right. Please check it and try again.';
      }
      return error.userMessage.isNotEmpty
          ? error.userMessage
          : 'Please check your input and try again.';
    }

    if (error is SerializationException) {
      return 'We received an unexpected response. Please try again.';
    }

    if (error is ServerException) {
      return 'Something went wrong on our side. Please try again in a moment.';
    }

    if (error is ApiException) {
      // ApiException covers unmapped HTTP status codes.
      return 'Something went wrong on our side. Please try again in a moment.';
    }

    // Any other AppException subtype — fall back to its own userMessage.
    if (error is AppException) {
      final msg = error.userMessage;
      if (msg.isNotEmpty) return msg;
    }

    // ── 2. Contextual safe fallbacks for unknown exceptions ───────────────────
    return _contextualFallback(context);
  }

  /// Returns a context-specific fallback for completely unknown exceptions,
  /// so that users still receive a meaningful message even for unanticipated
  /// failure types.
  static String _contextualFallback(AppErrorContext context) {
    switch (context) {
      case AppErrorContext.login:
        return 'The email or password doesn\'t match our records.';
      case AppErrorContext.register:
        return 'We couldn\'t create your account right now. Please try again.';
      case AppErrorContext.forgotPassword:
        return 'We couldn\'t send a recovery code right now. Please try again.';
      case AppErrorContext.otp:
        return 'That code doesn\'t look right. Please check it and try again.';
      case AppErrorContext.profileLoad:
        return 'We couldn\'t load your profile right now. Please try again.';
      case AppErrorContext.profileSave:
        return 'We couldn\'t save your changes. Please try again.';
      case AppErrorContext.passwordChange:
        return 'We couldn\'t change your password right now. Please try again.';
      case AppErrorContext.deleteAccount:
        return 'We couldn\'t delete your account right now. Please try again.';
      case AppErrorContext.missionControl:
        return 'Mission Control is temporarily unavailable. Please try again.';
      case AppErrorContext.academy:
        return 'Courses couldn\'t be loaded right now. Please try again.';
      case AppErrorContext.investigation:
        return 'Investigation data couldn\'t be loaded right now. Please try again.';
      case AppErrorContext.mitre:
        return 'Threat intelligence couldn\'t be loaded right now. Please try again.';
      case AppErrorContext.simulation:
        return 'Simulation data couldn\'t be loaded right now. Please try again.';
      case AppErrorContext.logout:
        return 'We couldn\'t sign you out right now. Please try again.';
      case AppErrorContext.general:
        return 'Something went wrong on our side. Please try again in a moment.';
    }
  }
}
