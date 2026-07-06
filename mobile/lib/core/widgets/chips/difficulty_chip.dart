import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';

/// Predefined difficulty levels for cases and modules.
enum DifficultyLevel { beginner, intermediate, advanced, expert }

/// A semantic chip that visually communicates the difficulty level of an activity.
class DifficultyChip extends StatelessWidget {
  /// The difficulty level to display.
  final DifficultyLevel level;

  const DifficultyChip({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBars(),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _getLabel(),
            style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _getLabel() {
    switch (level) {
      case DifficultyLevel.beginner: return 'Beginner';
      case DifficultyLevel.intermediate: return 'Intermediate';
      case DifficultyLevel.advanced: return 'Advanced';
      case DifficultyLevel.expert: return 'Expert';
    }
  }

  Widget _buildBars() {
    int activeBars = 1;
    Color color = AppColors.success;

    switch (level) {
      case DifficultyLevel.beginner:
        activeBars = 1;
        color = AppColors.success;
        break;
      case DifficultyLevel.intermediate:
        activeBars = 2;
        color = AppColors.info;
        break;
      case DifficultyLevel.advanced:
        activeBars = 3;
        color = AppColors.warning;
        break;
      case DifficultyLevel.expert:
        activeBars = 4;
        color = AppColors.error;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        final isActive = index < activeBars;
        return Container(
          margin: const EdgeInsets.only(right: 2),
          width: 4,
          height: 6.0 + (index * 2), // Ascending heights
          decoration: BoxDecoration(
            color: isActive ? color : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
