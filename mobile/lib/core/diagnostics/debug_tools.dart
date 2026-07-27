import 'package:flutter/foundation.dart';

/// Utilities for developer debugging that strip out in release mode.
class DebugTools {
  DebugTools._();

  /// Logs a stylized banner to the console. Useful for separating log sections.
  static void logBanner(String message) {
    if (kDebugMode) {
      debugPrint('=========================================');
      debugPrint('== $message');
      debugPrint('=========================================');
    }
  }

  /// Dumps an object representation securely.
  static void dump(Object? obj, {String tag = 'DUMP'}) {
    if (kDebugMode) {
      debugPrint('[$tag] => $obj');
    }
  }
}
