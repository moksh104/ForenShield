import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';

/// Clean dashboard header: ForenShield logo (left) + Search + Notification bell (right).
/// Matches exact white-theme design spec.
class DashboardHeader extends ConsumerWidget {
  final String userName;
  final String avatarUrl;
  final String rankTitle;
  final int unreadNotifications;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.rankTitle,
    this.unreadNotifications = 0,
    this.onNotificationTap,
    this.onSearchTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riverpodUnread = ref.watch(unreadNotificationCountProvider);
    final count = riverpodUnread > 0 ? riverpodUnread : unreadNotifications;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Shield Logo Mark
          Image.asset(
            'assets/logos/app_logo.png',
            width: 38,
            height: 38,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Icon(Icons.shield_rounded, size: 20, color: colorScheme.primary),
            ),
          ),
          const SizedBox(width: 10),

          // Brand Name + Tagline
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'FOREN',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  Text(
                    'SHIELD',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                'LEARN · INVESTIGATE · DEFEND',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Good Morning, User Greeting
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Good morning,',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userName.isNotEmpty ? userName : 'Samlee',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Outfit',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Notification Bell
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface,
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (count > 0)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onError,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
