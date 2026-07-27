import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/foren_theme.dart';

enum AppBadgeStatus { success, warning, error, info, normal }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeStatus status;
  final bool outlined;

  const AppBadge({
    super.key,
    required this.label,
    this.status = AppBadgeStatus.normal,
    this.outlined = false,
  });

  Color _getStatusColor(ForenColors foren, ColorScheme cs) {
    switch (status) {
      case AppBadgeStatus.success:
        return foren.success.t500;
      case AppBadgeStatus.warning:
        return foren.warning.t500;
      case AppBadgeStatus.error:
        return foren.critical.t500;
      case AppBadgeStatus.info:
        return foren.info.t500;
      case AppBadgeStatus.normal:
        return cs.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final color = _getStatusColor(foren, theme.colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.15),
        border: outlined ? Border.all(color: color) : null,
        borderRadius: AppRadius.borderRadiusSm,
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
