import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/mission_control_entity.dart';

/// Notifications list section for Mission Control.
class NotificationTileSection extends StatelessWidget {
  final List<DashboardNotification> notifications;

  const NotificationTileSection({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: foren.borderSubtle.withValues(alpha: 0.4),
          ),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: foren.borderSubtle.withValues(alpha: 0.2),
            indent: 52,
          ),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return _NotificationRow(item: item);
          },
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final DashboardNotification item;

  const _NotificationRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final typeColor = _getTypeColor(foren, theme, item.type);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTypeIcon(item.type),
              color: typeColor,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 12,
                          fontWeight: item.isUnread
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      item.timestamp,
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.message,
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(ForenColors foren, ThemeData theme, String type) {
    switch (type.toLowerCase()) {
      case 'warning':
      case 'alert':
        return foren.warning.t500;
      case 'error':
        return foren.critical.t500;
      case 'success':
        return foren.success.t500;
      case 'info':
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'warning':
      case 'alert':
        return Icons.warning_amber;
      case 'error':
        return Icons.error_outline;
      case 'success':
        return Icons.check_circle_outline;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }
}
