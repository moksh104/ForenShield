import '../../../../core/utils/result.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';
import '../datasource/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  const NotificationRepositoryImpl(this._dataSource);

  @override
  Future<Result<({List<NotificationModel> notifications, int unreadCount})>>
  getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final data = await _dataSource.fetchNotifications(
        page: page,
        limit: limit,
        unreadOnly: unreadOnly,
      );

      final rawList = data['notifications'] as List<dynamic>? ?? [];
      final notifications = rawList
          .map(
            (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      final unreadCount = (data['unread_count'] as int?) ?? 0;

      return Success((notifications: notifications, unreadCount: unreadCount));
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> markAsRead({
    int? notificationId,
    bool markAll = false,
  }) async {
    try {
      final data = await _dataSource.markAsRead(
        notificationId: notificationId,
        markAll: markAll,
      );

      if (data['success'] == true) {
        return const Success(true);
      }
      return Failure(Exception('Failed to mark notification as read'));
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
