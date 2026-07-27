import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/foren_theme.dart';

enum DifficultyLevel { beginner, intermediate, advanced, expert }

class DifficultyChip extends StatelessWidget {
  final DifficultyLevel level;

  const DifficultyChip({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: foren.surfaceRaised2,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: foren.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBars(foren),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _getLabel(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: foren.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getLabel() {
    switch (level) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }

  Widget _buildBars(ForenColors foren) {
    int activeBars = 1;
    Color color = foren.success.t500;

    switch (level) {
      case DifficultyLevel.beginner:
        activeBars = 1;
        color = foren.success.t500;
        break;
      case DifficultyLevel.intermediate:
        activeBars = 2;
        color = foren.info.t500;
        break;
      case DifficultyLevel.advanced:
        activeBars = 3;
        color = foren.warning.t500;
        break;
      case DifficultyLevel.expert:
        activeBars = 4;
        color = foren.critical.t500;
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
          height: 6.0 + (index * 2),
          decoration: BoxDecoration(
            color: isActive ? color : foren.surfaceRaised1,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
