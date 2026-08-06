import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/notifications/presentation/providers/notification_providers.dart';
import '../services/local_notification_service.dart';

/// Production-ready helper to display heads-up notifications and trigger Riverpod badge refreshes.
class NotificationTriggerHelper {
  NotificationTriggerHelper._();

  /// Displays local notification banner and refreshes unread badge counter.
  static Future<void> notifyAndRefresh(
    WidgetRef ref, {
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // 1. Display local notification banner
    await LocalNotificationService.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );

    // 2. Refresh Riverpod notification state & unread badge counter
    ref.read(notificationStateProvider.notifier).fetchNotifications();
  }
}
