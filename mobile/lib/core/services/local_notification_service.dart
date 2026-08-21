import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Production-ready service for rendering local heads-up notifications.
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'This channel is used for important ForenShield security alerts and notifications.';

  /// Initialize notification channels, permissions, and tap handlers.
  static Future<void> initialize({
    void Function(String? payload)? onNotificationTap,
  }) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    try {
      final dynamic plugin = _localNotifications;
      await plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          if (onNotificationTap != null) {
            onNotificationTap(response.payload);
          }
        },
      );
    } catch (_) {
      try {
        final dynamic plugin = _localNotifications;
        await plugin.initialize(
          settings: initSettings,
          onDidReceiveNotificationResponse: (response) {
            if (onNotificationTap != null) {
              onNotificationTap(response.payload);
            }
          },
        );
      } catch (e) {
        debugPrint('LocalNotificationService initialize error: $e');
      }
    }

    // Register High Importance Notification Channel for Android
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      playSound: true,
    );

    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(androidChannel);
      await androidImplementation.requestNotificationsPermission();
    }
  }

  /// Displays a heads-up local notification.
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      final dynamic plugin = _localNotifications;
      await plugin.show(id, title, body, details, payload: payload);
    } catch (_) {
      try {
        final dynamic plugin = _localNotifications;
        await plugin.show(
          id: id,
          title: title,
          body: body,
          notificationDetails: details,
          payload: payload,
        );
      } catch (e) {
        debugPrint('LocalNotificationService showNotification error: $e');
      }
    }
  }
}
