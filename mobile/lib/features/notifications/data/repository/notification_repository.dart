import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/utils/result.dart';
import '../models/notification_model.dart';

/// Repository handling notifications API requests and state persistence.
class NotificationRepository {
  final Dio _dio;

  NotificationRepository({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  Future<Map<String, String>> _headers() async {
    final token = await StorageService().getAccessToken();
    return {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Fetches notifications list and unread count from the backend.
  Future<Result<({List<NotificationModel> notifications, int unreadCount})>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.notifications,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (unreadOnly) 'unread_only': 'true',
        },
        options: Options(headers: await _headers()),
      );

      if (response.statusCode == 200 && response.data['notifications'] != null) {
        final List raw = response.data['notifications'];
        final notifications = raw.map((item) => NotificationModel.fromJson(item)).toList();
        final unreadCount = (response.data['unread_count'] as int?) ?? 0;
        return Success((notifications: notifications, unreadCount: unreadCount));
      }
      return Failure(Exception('Failed to fetch notifications'));
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Marks a specific notification or all notifications as read.
  Future<Result<bool>> markAsRead({int? notificationId, bool markAll = false}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.markAsRead,
        data: {
          if (notificationId != null) 'notification_id': notificationId,
          'mark_all': markAll,
        },
        options: Options(headers: await _headers()),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return const Success(true);
      }
      return Failure(Exception('Failed to mark notification as read'));
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
