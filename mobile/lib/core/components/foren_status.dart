/// ForenShield Component Library — Status Components
/// Threat Badge / Difficulty Badge / Status Chip / XP Chip / Notification Badge
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

export '../widgets/app_avatar.dart';
export '../widgets/app_badge.dart';
export '../widgets/app_chip.dart';
export '../widgets/app_empty_state.dart';
export '../widgets/app_error_state.dart';
export '../widgets/app_success_state.dart';

enum ForenThreatLevel { critical, high, medium, low, info }

enum ForenDifficulty { beginner, intermediate, advanced, expert }

enum ForenStatus { active, inProgress, completed, locked }

/// Small internal pill used by every badge/chip in this file — keeps
/// padding/radius/type identical across the whole status family.
class _ForenPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final IconData? icon;

  const _ForenPill({
    required this.label,
    required this.bg,
    required this.fg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ForenSpace.sm,
        vertical: ForenSpace.xs,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: ForenRadius.pillBr),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: fg)),
        ],
      ),
    );
  }
}

class ForenThreatBadge extends StatelessWidget {
  final ForenThreatLevel level;
  const ForenThreatBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    final (ramp, label) = switch (level) {
      ForenThreatLevel.critical => (foren.critical, 'CRITICAL'),
      ForenThreatLevel.high => (foren.warning, 'HIGH'),
      ForenThreatLevel.medium => (foren.warning, 'MEDIUM'),
      ForenThreatLevel.low => (foren.success, 'LOW'),
      ForenThreatLevel.info => (foren.info, 'INFO'),
    };
    return _ForenPill(
      label: label,
      bg: ramp.t500.withValues(alpha: 0.16),
      fg: ramp.t500,
      icon: Icons.warning_amber_rounded,
    );
  }
}

class ForenDifficultyBadge extends StatelessWidget {
  final ForenDifficulty level;
  const ForenDifficultyBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    // Progression mirrors threat severity so difficulty reads
    // intuitively: green -> blue -> orange -> red.
    final (ramp, label) = switch (level) {
      ForenDifficulty.beginner => (foren.success, 'BEGINNER'),
      ForenDifficulty.intermediate => (foren.info, 'INTERMEDIATE'),
      ForenDifficulty.advanced => (foren.warning, 'ADVANCED'),
      ForenDifficulty.expert => (foren.critical, 'EXPERT'),
    };
    return _ForenPill(
      label: label,
      bg: ramp.t500.withValues(alpha: 0.16),
      fg: ramp.t500,
    );
  }
}

class ForenStatusChip extends StatelessWidget {
  final ForenStatus status;
  const ForenStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    final (ramp, label, icon) = switch (status) {
      ForenStatus.active => (foren.info, 'ACTIVE', Icons.radio_button_checked),
      ForenStatus.inProgress => (foren.warning, 'IN PROGRESS', Icons.autorenew),
      ForenStatus.completed => (
        foren.success,
        'COMPLETED',
        Icons.check_circle_outline,
      ),
      ForenStatus.locked => (null, 'LOCKED', Icons.lock_outline),
    };
    final fg = ramp?.t500 ?? foren.textSecondary;
    final bg = ramp != null
        ? ramp.t500.withValues(alpha: 0.16)
        : foren.surfaceRaised2;
    return _ForenPill(label: label, bg: bg, fg: fg, icon: icon);
  }
}

/// "+250 XP" style chip — always Academy amber, since XP is a
/// learning-reward concept regardless of which feature earned it.
class ForenXpChip extends StatelessWidget {
  final int amount;
  final bool showPlus;
  const ForenXpChip({super.key, required this.amount, this.showPlus = true});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    final ramp = foren.academy;
    return _ForenPill(
      label: '${showPlus ? '+' : ''}$amount XP',
      bg: ramp.t500.withValues(alpha: 0.16),
      fg: ramp.t500,
      icon: Icons.bolt,
    );
  }
}

/// Small counter badge for overlaying on icons (e.g. unread alerts).
/// Always Critical — a notification badge is inherently "needs attention."
class ForenNotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  const ForenNotificationBadge({
    super.key,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    if (count <= 0) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            decoration: BoxDecoration(
              color: foren.critical.t500,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              count > 99 ? '99+' : '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
