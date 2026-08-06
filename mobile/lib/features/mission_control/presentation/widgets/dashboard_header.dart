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
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

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
                color: primaryColor.withValues(alpha: 0.1),
              ),
              child: Icon(Icons.shield_rounded, size: 20, color: primaryColor),
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
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  Text(
                    'SHIELD',
                    style: TextStyle(
                      color: primaryColor,
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
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Good Morning, User Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Good morning,',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                userName.isNotEmpty ? userName : 'Samlee',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
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
                    color: isDark ? AppColors.surface : Colors.white,
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderSubtle
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: textPrimary,
                  ),
                ),
                if (count > 0)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.critical,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? theme.scaffoldBackgroundColor
                              : Colors.white,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
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
            ),
          ),
        ],
      ),
    );
  }
}
