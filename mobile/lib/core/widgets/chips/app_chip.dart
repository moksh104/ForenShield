import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';

/// The visual style of the [AppChip].
enum AppChipType { filled, outlined, tonal }

/// A highly reusable and interactive chip component.
/// 
/// Supports selection, deletion, icons, and three distinct visual styles.
class AppChip extends StatelessWidget {
  /// The text displayed inside the chip.
  final String label;

  /// The visual style. Defaults to [AppChipType.filled].
  final AppChipType type;

  /// Whether the chip is in a selected state.
  final bool isSelected;

  /// Whether the chip displays a close/remove icon.
  final bool isRemovable;

  /// Whether the chip can be interacted with.
  final bool isEnabled;

  /// An optional leading icon.
  final IconData? icon;

  /// Callback when the chip is tapped.
  final VoidCallback? onTap;

  /// Callback when the remove icon is tapped (only relevant if [isRemovable] is true).
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
    return RawChip(
      label: Text(label, style: _getTextStyle()),
      avatar: icon != null ? Icon(icon, size: 18, color: _getIconColor()) : null,
      isEnabled: isEnabled,
      selected: isSelected,
      onSelected: isEnabled && onTap != null ? (_) => onTap!() : null,
      onDeleted: isEnabled && isRemovable ? onRemoved : null,
      deleteIcon: const Icon(Icons.close, size: 16),
      deleteIconColor: _getIconColor(),
      backgroundColor: _getBackgroundColor(),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      disabledColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderMd,
        side: _getBorderSide(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      showCheckmark: false,
    );
  }

  Color _getBackgroundColor() {
    if (!isEnabled) return AppColors.surfaceVariant;
    if (isSelected) return AppColors.primary.withValues(alpha: 0.2);

    switch (type) {
      case AppChipType.filled:
        return AppColors.surfaceElevated;
      case AppChipType.outlined:
        return Colors.transparent;
      case AppChipType.tonal:
        return AppColors.surfaceVariant;
    }
  }

  BorderSide _getBorderSide() {
    if (!isEnabled) return BorderSide(color: AppColors.outline.withValues(alpha: 0.5));
    if (isSelected) return const BorderSide(color: AppColors.primary, width: 1.5);

    switch (type) {
      case AppChipType.outlined:
        return const BorderSide(color: AppColors.outline);
      case AppChipType.filled:
      case AppChipType.tonal:
        return BorderSide.none;
    }
  }

  TextStyle _getTextStyle() {
    Color color = AppColors.textPrimary;
    if (!isEnabled) {
      color = AppColors.textDisabled;
    } else if (isSelected) {
      color = AppColors.primary;
    }
    return AppTypography.labelMedium.copyWith(color: color);
  }

  Color _getIconColor() {
    if (!isEnabled) return AppColors.textDisabled;
    if (isSelected) return AppColors.primary;
    return AppColors.textSecondary;
  }
}
