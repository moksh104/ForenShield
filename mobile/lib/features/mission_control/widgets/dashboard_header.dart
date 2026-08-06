import 'package:flutter/material.dart';

/// Dashboard header displaying a greeting and user avatar.
///
/// Accepts optional [userName] for the greeting and [onNotificationTap]
/// for the notification bell action. Fully decoupled from providers.
class DashboardHeader extends StatelessWidget {
  final String userName;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const DashboardHeader({
    super.key,
    this.userName = 'Agent',
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final greeting = _greeting(now.hour);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _NotificationButton(
            count: notificationCount,
            onTap: onNotificationTap,
          ),
          const SizedBox(width: 10),
          _AvatarButton(userName: userName, onTap: onAvatarTap),
        ],
      ),
    );
  }

  static String _greeting(int hour) {
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}

class _NotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const _NotificationButton({required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: count > 0 ? '$count unread notifications' : 'Notifications',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            if (count > 0)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onError,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  final String userName;
  final VoidCallback? onTap;

  const _AvatarButton({required this.userName, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = userName.isNotEmpty
        ? userName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'A';

    return Semantics(
      label: 'Profile',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: Text(
              initials,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
