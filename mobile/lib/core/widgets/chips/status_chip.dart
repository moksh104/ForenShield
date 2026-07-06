import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';

/// Predefined states for ForenShield investigation cases, tasks, or modules.
enum StatusChipState { active, pending, completed, failed, locked }

/// A display-only chip specifically designed to clearly communicate status.
/// 
/// Automatically handles color-coding and icons based on the [StatusChipState].
class StatusChip extends StatelessWidget {
  /// The specific state to display.
  final StatusChipState state;

  const StatusChip({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final style = _getStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: style.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 14, color: style.textColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _getLabel(),
            style: AppTypography.labelSmall.copyWith(
              color: style.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getLabel() {
    switch (state) {
      case StatusChipState.active: return 'ACTIVE';
      case StatusChipState.pending: return 'PENDING';
      case StatusChipState.completed: return 'COMPLETED';
      case StatusChipState.failed: return 'FAILED';
      case StatusChipState.locked: return 'LOCKED';
    }
  }

  _StatusStyle _getStyle() {
    switch (state) {
      case StatusChipState.active:
        return _StatusStyle(
          bgColor: AppColors.info.withValues(alpha: 0.15),
          borderColor: AppColors.info.withValues(alpha: 0.3),
          textColor: AppColors.info,
          icon: Icons.play_circle_outline,
        );
      case StatusChipState.pending:
        return _StatusStyle(
          bgColor: AppColors.warning.withValues(alpha: 0.15),
          borderColor: AppColors.warning.withValues(alpha: 0.3),
          textColor: AppColors.warning,
          icon: Icons.hourglass_empty,
        );
      case StatusChipState.completed:
        return _StatusStyle(
          bgColor: AppColors.success.withValues(alpha: 0.15),
          borderColor: AppColors.success.withValues(alpha: 0.3),
          textColor: AppColors.success,
          icon: Icons.check_circle_outline,
        );
      case StatusChipState.failed:
        return _StatusStyle(
          bgColor: AppColors.error.withValues(alpha: 0.15),
          borderColor: AppColors.error.withValues(alpha: 0.3),
          textColor: AppColors.error,
          icon: Icons.error_outline,
        );
      case StatusChipState.locked:
        return _StatusStyle(
          bgColor: AppColors.surfaceVariant,
          borderColor: AppColors.outline,
          textColor: AppColors.textDisabled,
          icon: Icons.lock_outline,
        );
    }
  }
}

class _StatusStyle {
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final IconData icon;

  _StatusStyle({
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.icon,
  });
}
