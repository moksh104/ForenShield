import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/foren_theme.dart';

enum InfoCardType { success, warning, error, info }

class InfoCard extends StatelessWidget {
  final InfoCardType type;
  final IconData icon;
  final String title;
  final String description;
  final Widget? ctaButton;

  const InfoCard({
    super.key,
    this.type = InfoCardType.info,
    required this.icon,
    required this.title,
    required this.description,
    this.ctaButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final colorContext = _getColorContext(foren, theme);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorContext.backgroundColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: colorContext.borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorContext.iconColor, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorContext.titleColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorContext.textColor,
                  ),
                ),
                if (ctaButton != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  ctaButton!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _InfoCardColors _getColorContext(ForenColors foren, ThemeData theme) {
    switch (type) {
      case InfoCardType.success:
        final c = foren.success.t500;
        return _InfoCardColors(
          backgroundColor: c.withValues(alpha: 0.1),
          borderColor: c.withValues(alpha: 0.3),
          iconColor: c,
          titleColor: c,
          textColor: theme.colorScheme.onSurface,
        );
      case InfoCardType.warning:
        final c = foren.warning.t500;
        return _InfoCardColors(
          backgroundColor: c.withValues(alpha: 0.1),
          borderColor: c.withValues(alpha: 0.3),
          iconColor: c,
          titleColor: c,
          textColor: theme.colorScheme.onSurface,
        );
      case InfoCardType.error:
        final c = foren.critical.t500;
        return _InfoCardColors(
          backgroundColor: c.withValues(alpha: 0.1),
          borderColor: c.withValues(alpha: 0.3),
          iconColor: c,
          titleColor: c,
          textColor: theme.colorScheme.onSurface,
        );
      case InfoCardType.info:
        final c = foren.info.t500;
        return _InfoCardColors(
          backgroundColor: c.withValues(alpha: 0.1),
          borderColor: c.withValues(alpha: 0.3),
          iconColor: c,
          titleColor: c,
          textColor: theme.colorScheme.onSurface,
        );
    }
  }
}

class _InfoCardColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color titleColor;
  final Color textColor;

  _InfoCardColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.titleColor,
    required this.textColor,
  });
}
