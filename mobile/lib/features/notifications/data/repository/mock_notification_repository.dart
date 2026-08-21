import '../../../../core/utils/result.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  static final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: 1,
      userId: 1,
      title: '🚨 Threat Detected',
      message: 'Anomalous network traffic detected on Gateway Node #4.',
      type: 'alert',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      id: 2,
      userId: 1,
      title: '📚 New Course Available',
      message: 'Digital Forensics & Incident Response course is now unlocked.',
      type: 'academy',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  Future<Result<({List<NotificationModel> notifications, int unreadCount})>>
  getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final list = unreadOnly
        ? _mockNotifications.where((n) => !n.isRead).toList()
        : _mockNotifications;

    final unreadCount = _mockNotifications.where((n) => !n.isRead).length;

    return Success((notifications: list, unreadCount: unreadCount));
  }

  @override
  Future<Result<bool>> markAsRead({
    int? notificationId,
    bool markAll = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < _mockNotifications.length; i++) {
      if (markAll || _mockNotifications[i].id == notificationId) {
        _mockNotifications[i] = _mockNotifications[i].copyWith(isRead: true);
      }
    }
    return const Success(true);
  }
}
