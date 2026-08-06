import 'package:forenshield/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/foren_theme.dart';

/// Fire emoji streak counter with animated glow for active streaks.
class StreakIndicator extends StatelessWidget {
  final int streak;

  const StreakIndicator({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>() ?? ForenColors.dark;

    if (streak <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: foren.warning.t500.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: foren.warning.t500.withValues(alpha: 0.4),
        ),
        boxShadow: streak >= 7
            ? [
                BoxShadow(
                  color: foren.warning.t500.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            streak >= 7 ? '🔥' : '🔸',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$streak',
            style: TextStyle(
              color: foren.warning.t300,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            'day${streak == 1 ? '' : 's'}',
            style: TextStyle(
              color: foren.warning.t500,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
