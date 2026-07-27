import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/foren_theme.dart';

enum StatusChipState { active, pending, completed, failed, locked }

class StatusChip extends StatelessWidget {
  final StatusChipState state;

  const StatusChip({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final style = _getStyle(foren);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
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
            style: theme.textTheme.labelSmall?.copyWith(
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
      case StatusChipState.active:
        return 'ACTIVE';
      case StatusChipState.pending:
        return 'PENDING';
      case StatusChipState.completed:
        return 'COMPLETED';
      case StatusChipState.failed:
        return 'FAILED';
      case StatusChipState.locked:
        return 'LOCKED';
    }
  }

  _StatusStyle _getStyle(ForenColors foren) {
    switch (state) {
      case StatusChipState.active:
        final c = foren.info.t500;
        return _StatusStyle(
          bgColor: c.withValues(alpha: 0.15),
          borderColor: c.withValues(alpha: 0.3),
          textColor: c,
          icon: Icons.play_circle_outline,
        );
      case StatusChipState.pending:
        final c = foren.warning.t500;
        return _StatusStyle(
          bgColor: c.withValues(alpha: 0.15),
          borderColor: c.withValues(alpha: 0.3),
          textColor: c,
          icon: Icons.hourglass_empty,
        );
      case StatusChipState.completed:
        final c = foren.success.t500;
        return _StatusStyle(
          bgColor: c.withValues(alpha: 0.15),
          borderColor: c.withValues(alpha: 0.3),
          textColor: c,
          icon: Icons.check_circle_outline,
        );
      case StatusChipState.failed:
        final c = foren.critical.t500;
        return _StatusStyle(
          bgColor: c.withValues(alpha: 0.15),
          borderColor: c.withValues(alpha: 0.3),
          textColor: c,
          icon: Icons.error_outline,
        );
      case StatusChipState.locked:
        return _StatusStyle(
          bgColor: foren.surfaceRaised1,
          borderColor: foren.borderSubtle,
          textColor: foren.textDisabled,
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
