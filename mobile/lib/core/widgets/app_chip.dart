import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/foren_theme.dart';

class AppChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final bool isSelected;

  const AppChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.onDeleted,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final effectiveColor = color ?? theme.colorScheme.primary;

    return RawChip(
      label: Text(label),
      avatar: icon != null
          ? Icon(
              icon,
              size: 16,
              color: isSelected ? theme.scaffoldBackgroundColor : effectiveColor,
            )
          : null,
      onPressed: onTap,
      backgroundColor: isSelected ? effectiveColor : foren.surfaceRaised1,
      side: BorderSide(color: effectiveColor),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected ? theme.scaffoldBackgroundColor : effectiveColor,
      ),
      deleteIconColor: isSelected ? theme.scaffoldBackgroundColor : effectiveColor,
      onDeleted: onDeleted,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
    );
  }
}
