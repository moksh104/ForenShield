import 'dart:async';
import 'package:flutter/foundation.dart';

/// Limits the execution of a function to once every specified interval.
/// Ideal for button presses or scroll listeners.
class Throttle {
  final Duration delay;
  bool _isReady = true;
  Timer? _timer;

  Throttle({this.delay = const Duration(seconds: 1)});

  void run(VoidCallback action) {
    if (_isReady) {
      action();
      _isReady = false;
      _timer = Timer(delay, () {
        _isReady = true;
      });
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
