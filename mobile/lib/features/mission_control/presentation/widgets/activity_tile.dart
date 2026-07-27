import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/mission_control_entity.dart';

/// Recent Activity Timeline Section.
class ActivityTileSection extends StatelessWidget {
  final List<DashboardActivity> activities;

  const ActivityTileSection({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
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
          itemCount: activities.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: foren.borderSubtle.withValues(alpha: 0.2),
            indent: 52,
          ),
          itemBuilder: (context, index) {
            final item = activities[index];
            return _ActivityRow(item: item);
          },
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final DashboardActivity item;

  const _ActivityRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final typeColor = _getTypeColor(foren, theme, item.type);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(
              _getIcon(item.iconName),
              color: typeColor,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: foren.textDisabled,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.timestamp,
            style: TextStyle(
              color: foren.textDisabled,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(ForenColors foren, ThemeData theme, String type) {
    switch (type.toLowerCase()) {
      case 'academy':
        return foren.academy.t500;
      case 'investigation':
        return foren.investigation.t500;
      case 'achievement':
        return foren.warning.t500;
      case 'simulation':
        return foren.simulation.t500;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'check_circle':
        return Icons.check_circle_outline;
      case 'folder_open':
        return Icons.folder_open_outlined;
      case 'military_tech':
        return Icons.military_tech_outlined;
      case 'shield':
        return Icons.shield_outlined;
      default:
        return Icons.bolt_outlined;
    }
  }
}
