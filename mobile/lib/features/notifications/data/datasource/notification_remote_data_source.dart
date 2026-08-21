import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  const NotificationRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> fetchNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.notifications,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (unreadOnly) 'unread_only': 'true',
      },
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> markAsRead({
    int? notificationId,
    bool markAll = false,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.markAsRead,
      data: {
        // ignore: use_null_aware_elements
        if (notificationId != null) 'notification_id': notificationId,
        'mark_all': markAll,
      },
    );
    return response.data ?? {};
  }
}
