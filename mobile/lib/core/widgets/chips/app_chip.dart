import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/foren_theme.dart';

enum AppChipType { filled, outlined, tonal }

class AppChip extends StatelessWidget {
  final String label;
  final AppChipType type;
  final bool isSelected;
  final bool isRemovable;
  final bool isEnabled;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onRemoved;

  const AppChip({
    super.key,
    required this.label,
    this.type = AppChipType.filled,
    this.isSelected = false,
    this.isRemovable = false,
    this.isEnabled = true,
    this.icon,
    this.onTap,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return RawChip(
      label: Text(label, style: _getTextStyle(theme, foren)),
      avatar: icon != null
          ? Icon(icon, size: 18, color: _getIconColor(theme, foren))
          : null,
      isEnabled: isEnabled,
      selected: isSelected,
      onSelected: isEnabled && onTap != null ? (_) => onTap!() : null,
      onDeleted: isEnabled && isRemovable ? onRemoved : null,
      deleteIcon: const Icon(Icons.close, size: 16),
      deleteIconColor: _getIconColor(theme, foren),
      backgroundColor: _getBackgroundColor(foren),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      disabledColor: foren.surfaceRaised1,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderMd,
        side: _getBorderSide(theme, foren),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      showCheckmark: false,
    );
  }

  Color _getBackgroundColor(ForenColors foren) {
    if (!isEnabled) return foren.surfaceRaised1;
    if (isSelected) return foren.missionControl.t500.withValues(alpha: 0.2);

    switch (type) {
      case AppChipType.filled:
        return foren.surfaceRaised2;
      case AppChipType.outlined:
        return Colors.transparent;
      case AppChipType.tonal:
        return foren.surfaceRaised1;
    }
  }

  BorderSide _getBorderSide(ThemeData theme, ForenColors foren) {
    if (!isEnabled) {
      return BorderSide(color: foren.borderSubtle.withValues(alpha: 0.5));
    }
    if (isSelected) {
      return BorderSide(color: theme.colorScheme.primary, width: 1.5);
    }

    switch (type) {
      case AppChipType.outlined:
        return BorderSide(color: foren.borderSubtle);
      case AppChipType.filled:
      case AppChipType.tonal:
        return BorderSide.none;
    }
  }

  TextStyle _getTextStyle(ThemeData theme, ForenColors foren) {
    Color color = theme.colorScheme.onSurface;
    if (!isEnabled) {
      color = foren.textDisabled;
    } else if (isSelected) {
      color = theme.colorScheme.primary;
    }
    return (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
      color: color,
    );
  }

  Color _getIconColor(ThemeData theme, ForenColors foren) {
    if (!isEnabled) return foren.textDisabled;
    if (isSelected) return theme.colorScheme.primary;
    return foren.textSecondary;
  }
}
