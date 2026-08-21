import '../../../../core/utils/result.dart';
import '../models/notification_model.dart';

abstract class NotificationRepository {
  Future<Result<({List<NotificationModel> notifications, int unreadCount})>>
  getNotifications({int page = 1, int limit = 20, bool unreadOnly = false});

  Future<Result<bool>> markAsRead({int? notificationId, bool markAll = false});
}
