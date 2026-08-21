import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../constants/api_endpoints.dart';
import '../logger/app_logger.dart';
import '../storage/storage_service.dart';

/// Notification data model.
class ForenNotification {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  ForenNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory ForenNotification.fromJson(Map<String, dynamic> json) {
    return ForenNotification(
      id: (json['id'] is int) ? json['id'] : int.parse(json['id'].toString()),
      userId: (json['user_id'] is int)
          ? json['user_id']
          : int.parse(json['user_id'].toString()),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      isRead:
          json['is_read'] == true ||
          json['is_read'] == 1 ||
          json['is_read'] == '1',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// Production-ready Notification Service for FCM token sync, topic management, and notifications API.
class NotificationService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Retrieves the current device's FCM registration token.
  static Future<String?> retrieveToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('NotificationService: Retrieved FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('NotificationService: Error retrieving FCM Token: $e');
      return null;
    }
  }

  /// Saves the device's FCM token to the server.
  static Future<bool> saveToken(dynamic userId) async {
    try {
      final token = await retrieveToken();
      if (token == null || token.isEmpty) return false;

      final accessToken = await StorageService().getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint(
          'NotificationService: Access token missing for FCM token save.',
        );
        return false;
      }

      final response = await _dio.post(
        ApiEndpoints.saveFcmToken,
        data: {'user_id': userId, 'fcm_token': token},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        debugPrint(
          'NotificationService: FCM token saved successfully for user $userId.',
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('NotificationService: Failed to save FCM token: $e');
      return false;
    }
  }

  /// Fetches notifications for the authenticated user.
  static Future<List<ForenNotification>> fetchNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final accessToken = await StorageService().getAccessToken();
      if (accessToken == null || accessToken.isEmpty) return [];

      final response = await _dio.get(
        ApiEndpoints.notifications,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (unreadOnly) 'unread_only': 'true',
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 &&
          response.data['notifications'] != null) {
        final List raw = response.data['notifications'];
        return raw.map((item) => ForenNotification.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('NotificationService: Error fetching notifications: $e');
      return [];
    }
  }

  /// Marks a specific notification (or all) as read.
  static Future<bool> markAsRead({
    int? notificationId,
    bool markAll = false,
  }) async {
    try {
      final accessToken = await StorageService().getAccessToken();
      if (accessToken == null || accessToken.isEmpty) return false;

      final response = await _dio.put(
        ApiEndpoints.notifications,
        data: {
          // ignore: use_null_aware_elements
          if (notificationId != null) 'notification_id': notificationId,
          'mark_all': markAll,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      debugPrint('NotificationService: Error marking notification as read: $e');
      return false;
    }
  }

  /// Subscribes to an FCM topic.
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      AppLogger.i('NotificationService: Subscribed to topic "$topic"');
    } catch (e) {
      AppLogger.e(
        'NotificationService: Error subscribing to topic "$topic": $e',
      );
    }
  }

  /// Unsubscribes from an FCM topic.
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      AppLogger.i('NotificationService: Unsubscribed from topic "$topic"');
    } catch (e) {
      AppLogger.e(
        'NotificationService: Error unsubscribing from topic "$topic": $e',
      );
    }
  }
}
