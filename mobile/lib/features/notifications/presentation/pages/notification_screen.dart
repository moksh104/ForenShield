import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../providers/notification_providers.dart';

/// Clean Material 3 Notification Screen listing security alerts and activity notifications.
class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool _unreadOnly = false;

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
      case 'threat':
        return Icons.warning_amber_rounded;
      case 'academy':
      case 'course':
        return Icons.school_outlined;
      case 'investigation':
      case 'lab':
      case 'case':
        return Icons.security_rounded;
      case 'report':
        return Icons.insert_drive_file_outlined;
      case 'achievement':
      case 'xp':
        return Icons.emoji_events_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getTypeColor(String type, ForenColors foren) {
    switch (type.toLowerCase()) {
      case 'alert':
      case 'threat':
        return foren.critical.t500;
      case 'academy':
      case 'course':
        return foren.academy.t500;
      case 'investigation':
      case 'lab':
      case 'case':
        return foren.investigation.t500;
      case 'report':
        return foren.info.t500;
      case 'achievement':
      case 'xp':
        return foren.success.t500;
      default:
        return foren.missionControl.t500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final state = ref.watch(notificationStateProvider);
    final notifier = ref.read(notificationStateProvider.notifier);

    final filteredList = _unreadOnly
        ? state.notifications.where((n) => !n.isRead).toList()
        : state.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
        actions: [
          if (state.unreadCount > 0)
            TextButton.icon(
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Mark all read'),
              onPressed: () => notifier.markAllAsRead(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: !_unreadOnly,
                  onSelected: (val) {
                    setState(() => _unreadOnly = false);
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: Text('Unread (${state.unreadCount})'),
                  selected: _unreadOnly,
                  onSelected: (val) {
                    setState(() => _unreadOnly = true);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Notifications List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  notifier.fetchNotifications(unreadOnly: _unreadOnly),
              child: state.isLoading && state.notifications.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 64,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                _unreadOnly
                                    ? 'No unread notifications'
                                    : 'No notifications yet',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Security alerts and updates will appear here.',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: filteredList.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (ctx, index) {
                        final notification = filteredList[index];
                        final typeColor = _getTypeColor(
                          notification.type,
                          foren,
                        );
                        final icon = _getTypeIcon(notification.type);

                        return Material(
                          color: notification.isRead
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              if (!notification.isRead) {
                                notifier.markAsRead(notification.id);
                              }
                              _navigateForType(context, notification.type);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: typeColor.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: typeColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notification.title,
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                  fontWeight:
                                                      notification.isRead
                                                      ? FontWeight.w500
                                                      : FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            if (!notification.isRead)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: foren.critical.t500,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          notification.message,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.8),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _formatTime(notification.createdAt),
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.5),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateForType(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'alert':
      case 'threat':
        context.go(RouteConstants.missionControl);
        break;
      case 'academy':
      case 'course':
        context.go(RouteConstants.academy);
        break;
      case 'investigation':
      case 'lab':
      case 'case':
        context.go(RouteConstants.investigation);
        break;
      case 'report':
        context.go(RouteConstants.reports);
        break;
      case 'achievement':
      case 'xp':
        context.go(RouteConstants.profile);
        break;
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
