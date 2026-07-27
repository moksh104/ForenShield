import 'dart:async';

/// Simplifies asynchronous orchestration and delays.
extension FutureExtension<T> on Future<T> {
  /// Ensures the future executes for at least [duration].
  /// Prevents loader flashes on extremely fast network responses.
  Future<T> withMinDuration(Duration duration) async {
    final start = DateTime.now();
    final result = await this;
    final elapsed = DateTime.now().difference(start);

    if (elapsed < duration) {
      await Future.delayed(duration - elapsed);
    }

    return result;
  }
}
