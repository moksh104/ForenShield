import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interface for analytics operations.
/// Allows swapping out external SDKs (Firebase, Mixpanel, etc.)
/// without altering core business logic.
abstract class AnalyticsService {
  /// Logs a custom event with optional parameters.
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});

  /// Associates the current session with a specific user ID.
  Future<void> setUserId(String? userId);

  /// Sets a persistent user property.
  Future<void> setUserProperty(String name, String value);

  /// Logs a screen view manually.
  Future<void> logScreenView(String screenName, {String? screenClass});
}

/// Dummy implementation for testing and development.
/// To be replaced by an actual SDK implementation (e.g., FirebaseAnalyticsService).
class DefaultAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty(String name, String value) async {}

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) async {}
}

/// Riverpod provider for dependency injection.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return DefaultAnalyticsService();
});
