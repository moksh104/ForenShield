/// Centralized duration timeouts and intervals for networking and UI behavior.
class DurationConstants {
  DurationConstants._();

  // Network
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // UI Delays
  static const Duration splashScreenDuration = Duration(seconds: 2);
  static const Duration snackbarDuration = Duration(seconds: 4);
  static const Duration toastDuration = Duration(seconds: 3);

  // Interactions
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration buttonThrottle = Duration(milliseconds: 1000);
}
