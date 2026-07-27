import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// Centralized logger for ForenShield.
///
/// Ensures no sensitive data (like JWT tokens) is logged in release mode.
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
    level: kDebugMode ? Level.trace : Level.off,
  );

  /// Redacts common sensitive information from log messages.
  /// Replaces JWT tokens with '[REDACTED_TOKEN]'.
  static String redact(String message) {
    // Regex for basic JWT format (header.payload.signature)
    final jwtRegex = RegExp(r'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+');
    return message.replaceAll(jwtRegex, '[REDACTED_TOKEN]');
  }

  // ── Short-hand aliases ──────────────────────────────────────────────────────

  static void t(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(redact(message.toString()), error: error, stackTrace: stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(redact(message.toString()), error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(redact(message.toString()), error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(redact(message.toString()), error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(redact(message.toString()), error: error, stackTrace: stackTrace);
  }

  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(redact(message.toString()), error: error, stackTrace: stackTrace);
  }

  // ── Descriptive aliases (Backward Compatibility) ───────────────────────────

  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    d(message, error, stackTrace);
  }

  static void info(String message, {dynamic error, StackTrace? stackTrace}) {
    i(message, error, stackTrace);
  }

  static void warning(String message, {dynamic error, StackTrace? stackTrace}) {
    w(message, error, stackTrace);
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    e(message, error, stackTrace);
  }
}
