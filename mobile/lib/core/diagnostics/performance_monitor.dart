import 'package:flutter/foundation.dart';

/// Traces method execution time to help identify UI thread blockers.
class PerformanceMonitor {
  PerformanceMonitor._();

  static final Map<String, Stopwatch> _watches = {};

  /// Starts tracking a metric with the given [tag].
  static void start(String tag) {
    if (!kDebugMode) return;
    _watches[tag] = Stopwatch()..start();
  }

  /// Stops tracking and prints the elapsed milliseconds for [tag].
  static void stop(String tag) {
    if (!kDebugMode) return;

    final stopwatch = _watches.remove(tag);
    if (stopwatch != null) {
      stopwatch.stop();
      debugPrint(
        '[Performance] $tag completed in ${stopwatch.elapsedMilliseconds} ms',
      );
    }
  }

  /// Wraps an async function and automatically times it.
  static Future<T> trace<T>(String tag, Future<T> Function() action) async {
    start(tag);
    try {
      return await action();
    } finally {
      stop(tag);
    }
  }
}
