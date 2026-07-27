import 'dart:async';
import 'package:flutter/foundation.dart';

/// Delays execution of a function until after a specified pause in calls.
/// Highly useful for search inputs to prevent spamming backend requests.
class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({this.delay = const Duration(milliseconds: 500)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
