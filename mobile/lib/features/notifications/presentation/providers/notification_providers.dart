import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/notification_model.dart';
import '../../data/datasource/notification_remote_data_source.dart';
import '../../data/repository/notification_repository.dart';
import '../../data/repository/notification_repository_impl.dart';
import '../../data/repository/mock_notification_repository.dart';

final notificationDataSourceProvider = Provider<NotificationRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRemoteDataSource(apiClient);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  if (ApiConfig.useMockApi) {
    return MockNotificationRepository();
  }
  final dataSource = ref.watch(notificationDataSourceProvider);
  return NotificationRepositoryImpl(dataSource);
});

class NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repo;

  NotificationNotifier(this._repo) : super(const NotificationState()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications({
    int page = 1,
    bool unreadOnly = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repo.getNotifications(
      page: page,
      unreadOnly: unreadOnly,
    );
    if (result.isSuccess) {
      final data =
          (result
                  as Success<
                    ({List<NotificationModel> notifications, int unreadCount})
                  >)
              .data;
      state = state.copyWith(
        notifications: data.notifications,
        unreadCount: data.unreadCount,
        isLoading: false,
      );
    } else {
      final ex = (result as Failure).exception;
      state = state.copyWith(isLoading: false, error: ex.toString());
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final result = await _repo.markAsRead(notificationId: notificationId);
    if (result.isSuccess) {
      final updatedList = state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      final newUnread = (state.unreadCount > 0) ? state.unreadCount - 1 : 0;
      state = state.copyWith(
        notifications: updatedList,
        unreadCount: newUnread,
      );
    }
  }

  Future<void> markAllAsRead() async {
    final result = await _repo.markAsRead(markAll: true);
    if (result.isSuccess) {
      final updatedList = state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      state = state.copyWith(notifications: updatedList, unreadCount: 0);
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await NotificationService.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await NotificationService.unsubscribeFromTopic(topic);
  }
}

final notificationStateProvider =
    StateNotifierProvider.autoDispose<NotificationNotifier, NotificationState>((
      ref,
    ) {
      final repo = ref.watch(notificationRepositoryProvider);
      return NotificationNotifier(repo);
    });

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationStateProvider).unreadCount;
});
