import 'package:flutter/foundation.dart';

/// A facade over third-party crash reporting tools (e.g. Firebase Crashlytics, Sentry).
class AppCrashHandler {
  AppCrashHandler._();

  /// Records an unhandled error to the crash reporting service.
  static void recordError(
    Object exception,
    StackTrace? stack, {
    bool fatal = false,
  }) {
    // Stub implementation.
    // Example: FirebaseCrashlytics.instance.recordError(exception, stack, fatal: fatal);
    if (kDebugMode) {
      debugPrint('Would log to Crashlytics (fatal: $fatal): $exception');
    }
  }

  /// Sets a custom user identifier for crash grouping.
  static void setUserIdentifier(String identifier) {
    if (kDebugMode) {
      debugPrint('Crashlytics User ID set to: $identifier');
    }
  }

  /// Leaves a breadcrumb trail for reproducing crashes.
  static void log(String message) {
    if (kDebugMode) {
      debugPrint('[Breadcrumb] $message');
    }
  }
}
