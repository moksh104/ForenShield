import 'package:flutter/foundation.dart';
import 'app_crash_handler.dart';

/// Centralized error handling routing for the application.
class AppErrorHandler {
  AppErrorHandler._();

  /// Captures an unhandled Flutter error and routes it to Crashlytics or the console.
  static void onFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      AppCrashHandler.recordError(
        details.exception,
        details.stack,
        fatal: true,
      );
    }
  }

  /// Captures errors originating outside of the Flutter framework (e.g. Isolate errors).
  static void onPlatformError(Object error, StackTrace stack) {
    if (kDebugMode) {
      debugPrint('Platform Error Caught: $error');
      debugPrint(stack.toString());
    } else {
      AppCrashHandler.recordError(error, stack, fatal: true);
    }
  }
}
