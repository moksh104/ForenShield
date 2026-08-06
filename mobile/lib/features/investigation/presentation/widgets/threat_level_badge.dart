import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/foren_theme.dart';

/// Reusable threat-level indicator badge with severity color coding and monospace styling.
class ThreatLevelBadge extends StatelessWidget {
  final String priority;

  const ThreatLevelBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final color = _getPriorityColor(foren, priority);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.borderRadiusXs,
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            priority.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(ForenColors foren, String prio) {
    switch (prio.toLowerCase()) {
      case 'critical':
        return foren.critical.t500;
      case 'high':
        return foren.warning.t500;
      case 'medium':
        return foren.investigation.t500;
      case 'low':
      default:
        return foren.textSecondary;
    }
  }
}
