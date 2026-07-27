import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interface for push and local notifications management.
abstract class NotificationService {
  /// Initializes notification handlers and settings.
  Future<void> initialize();

  /// Retrieves the device token for push notifications.
  Future<String?> getToken();

  /// Subscribes the user to a specific notification topic.
  Future<void> subscribeToTopic(String topic);

  /// Unsubscribes the user from a specific notification topic.
  Future<void> unsubscribeFromTopic(String topic);

  /// Displays a local notification on the device.
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  });
}

/// Default mock implementation for dependency injection.
class DefaultNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}

  @override
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {}
}

/// Riverpod provider for dependency injection.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return DefaultNotificationService();
});
