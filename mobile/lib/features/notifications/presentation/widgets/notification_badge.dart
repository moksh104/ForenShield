import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../providers/notification_providers.dart';

/// Reusable Notification Bell Icon Button with an unread badge counter.
class NotificationBadgeIconButton extends ConsumerWidget {
  final Color? iconColor;

  const NotificationBadgeIconButton({
    super.key,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: iconColor ?? theme.colorScheme.onSurface,
          ),
          tooltip: 'Notifications',
          onPressed: () {
            context.push(RouteConstants.notifications);
          },
        ),
        if (unreadCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: foren.danger.t500,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
