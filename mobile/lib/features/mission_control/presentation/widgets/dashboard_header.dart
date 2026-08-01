import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Command center dashboard header displaying user avatar, rank badge, greeting, date, and time with glassmorphism & glow effects.
class DashboardHeader extends StatefulWidget {
  final String userName;
  final String avatarUrl;
  final String rankTitle;
  final int unreadNotifications;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.rankTitle,
    this.unreadNotifications = 0,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  bool _isAvatarHovered = false;
  bool _isNotifHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final now = DateTime.now();
    final dateStr = DateFormat('EEE, MMM d, yyyy').format(now);
    final timeStr = DateFormat('HH:mm').format(now);
    final greeting = _getGreeting(now.hour);

    final initials = widget.userName.isNotEmpty
        ? widget.userName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'A';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Date/Time + Notifications + Avatar
          Row(
            children: [
              // Date & Time Glass Badge
              GlassEffect(
                blurX: 12.0,
                blurY: 12.0,
                opacity: 0.12,
                borderRadius: AppRadius.borderRadiusSm,
                border: Border.all(
                  color: foren.borderSubtle.withValues(alpha: 0.4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    GlowEffect(
                      glowColor: primaryColor,
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
                      animate: true,
                      borderRadius: BorderRadius.circular(6),
                      child: Icon(
                        Icons.schedule_outlined,
                        size: 13,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$dateStr · $timeStr UTC',
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Notification Bell Button
              MouseRegion(
                onEnter: (_) => setState(() => _isNotifHovered = true),
                onExit: (_) => setState(() => _isNotifHovered = false),
                child: InkWell(
                  onTap: widget.onNotificationTap,
                  borderRadius: AppRadius.borderRadiusMd,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 40,
                    height: 40,
                    transform: Matrix4.translationValues(0, _isNotifHovered ? -2 : 0, 0),
                    child: GlassEffect(
                      blurX: 12.0,
                      blurY: 12.0,
                      opacity: _isNotifHovered ? 0.22 : 0.12,
                      borderRadius: AppRadius.borderRadiusMd,
                      border: Border.all(
                        color: _isNotifHovered
                            ? primaryColor.withValues(alpha: 0.6)
                            : foren.borderSubtle.withValues(alpha: 0.4),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            size: 20,
                            color: _isNotifHovered
                                ? primaryColor
                                : theme.colorScheme.onSurface,
                          ),
                          if (widget.unreadNotifications > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: GlowEffect(
                                glowColor: foren.critical.t500,
                                blurRadius: 6,
                                spreadRadius: 1,
                                animate: true,
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: foren.critical.t500,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // User Avatar Button with Glow Effect & Hover
              MouseRegion(
                onEnter: (_) => setState(() => _isAvatarHovered = true),
                onExit: (_) => setState(() => _isAvatarHovered = false),
                child: InkWell(
                  onTap: widget.onProfileTap,
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    transform: Matrix4.translationValues(0, _isAvatarHovered ? -2 : 0, 0),
                    child: GlowEffect(
                      glowColor: primaryColor,
                      blurRadius: _isAvatarHovered ? 14.0 : 8.0,
                      spreadRadius: _isAvatarHovered ? 2.0 : 0.0,
                      animate: true,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, foren.investigation.t500],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: theme.scaffoldBackgroundColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Greeting & Rank Badge Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
              // Rank Badge with GlassEffect & Glow
              GlowEffect(
                glowColor: primaryColor,
                blurRadius: 8.0,
                spreadRadius: 1.0,
                animate: true,
                borderRadius: AppRadius.borderRadiusSm,
                child: GlassEffect(
                  blurX: 12.0,
                  blurY: 12.0,
                  opacity: 0.15,
                  borderRadius: AppRadius.borderRadiusSm,
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.military_tech,
                        color: primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.rankTitle,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _getGreeting(int hour) {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
