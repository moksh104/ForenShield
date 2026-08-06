import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'local_notification_service.dart';

/// Top-level background message handler for FCM.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background FCM Message Title: ${message.notification?.title}');
  debugPrint('Background FCM Message Body: ${message.notification?.body}');
  debugPrint('Background FCM Message Data: ${message.data}');
}

/// Firebase Service handling FCM registration, permissions, and notification listeners.
class ForenFirebaseService {
  static Future<void> initialize() async {
    try {
      debugPrint("STEP 1: Initializing Firebase Messaging...");

      final messaging = FirebaseMessaging.instance;

      // Initialize Local Notification Plugin
      await LocalNotificationService.initialize(
        onNotificationTap: (payload) {
          debugPrint('Local Notification tapped with payload: $payload');
        },
      );

      debugPrint("STEP 2: Requesting notification permissions...");

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint("PERMISSION STATUS: ${settings.authorizationStatus}");

      debugPrint("STEP 3: Fetching FCM Registration Token...");

      final token = await messaging.getToken();

      debugPrint("================================================");
      debugPrint("FCM TOKEN: $token");
      debugPrint("================================================");

      // Handle Terminated state (app launched from a notification tap when terminated)
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint("TERMINATED STATE NOTIFICATION: ${initialMessage.notification?.title}");
        debugPrint("TERMINATED DATA: ${initialMessage.data}");
      }

      // Handle Foreground Notifications (display via LocalNotificationService)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("FOREGROUND NOTIFICATION: ${message.notification?.title}");
        final notification = message.notification;
        if (notification != null) {
          LocalNotificationService.showNotification(
            id: message.messageId.hashCode,
            title: notification.title ?? 'ForenShield Notification',
            body: notification.body ?? '',
            payload: message.data.toString(),
          );
        }
      });

      // Handle Notification Open (when app is in background and user taps notification)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("NOTIFICATION OPENED FROM BACKGROUND: ${message.notification?.title}");
        debugPrint("DATA: ${message.data}");
      });
    } catch (e, stackTrace) {
      debugPrint("FIREBASE SERVICE ERROR: $e");
      debugPrint(stackTrace.toString());
    }
  }
}
