/// ForenShield Component Library — Dialogs
/// Mission Brief / Investigation Summary / Success Dialog / Warning Dialog
library;
import 'package:forenshield/core/theme/app_spacing.dart';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'foren_buttons.dart';
import 'foren_status.dart';

/// Shared dialog shell — consistent radius/elevation/padding for
/// every dialog variant below.
class _ForenDialogShell extends StatelessWidget {
  final Widget child;
  const _ForenDialogShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(ForenSpace.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(ForenSpace.lg),
          child: child,
        ),
      ),
    );
  }
}

/// Signature Feature 1 — the immersive entry point into a mission,
/// shown before a lesson/case is opened directly.
class ForenMissionBriefDialog extends StatelessWidget {
  final ForenThreatLevel priority;
  final String incidentSummary;
  final List<String> objectives;
  final int rewardXp;
  final VoidCallback onBegin;

  const ForenMissionBriefDialog({
    super.key,
    required this.priority,
    required this.incidentSummary,
    required this.objectives,
    required this.rewardXp,
    required this.onBegin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark
        ? foren.missionControl.t300
        : foren.missionControl.t700;

    return _ForenDialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: accent),
              const SizedBox(width: ForenSpace.sm),
              Text(
                'MISSION BRIEF',
                style: theme.textTheme.titleMedium?.copyWith(color: accent),
              ),
              const Spacer(),
              ForenThreatBadge(level: priority),
            ],
          ),
          const SizedBox(height: ForenSpace.md),
          Text(
            'Incident',
            style: theme.textTheme.labelMedium?.copyWith(
              color: foren.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(incidentSummary, style: theme.textTheme.bodyLarge),
          const SizedBox(height: ForenSpace.md),
          Text(
            'Your objective',
            style: theme.textTheme.labelMedium?.copyWith(
              color: foren.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final o in objectives)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: theme.textTheme.bodyMedium),
                  Expanded(child: Text(o, style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),
          const SizedBox(height: ForenSpace.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ForenXpChip(amount: rewardXp),
              ForenButton.primary(
                label: 'Begin Investigation',
                feature: ForenFeature.missionControl,
                onPressed: () {
                  Navigator.of(context).pop();
                  onBegin();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shown after a case is closed — recap + score + reward.
class ForenInvestigationSummaryDialog extends StatelessWidget {
  final String caseTitle;
  final List<String> findings;
  final double accuracy; // 0..1
  final int xpEarned;
  final VoidCallback onContinue;

  const ForenInvestigationSummaryDialog({
    super.key,
    required this.caseTitle,
    required this.findings,
    required this.accuracy,
    required this.xpEarned,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? foren.investigation.t300 : foren.investigation.t700;

    return _ForenDialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.fact_check_outlined,
            color: accent,
            size: ForenIconSize.hero,
          ),
          const SizedBox(height: ForenSpace.sm),
          Text('Case Closed', style: theme.textTheme.headlineSmall),
          Text(
            caseTitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: foren.textSecondary,
            ),
          ),
          const SizedBox(height: ForenSpace.md),
          Text(
            'Key findings',
            style: theme.textTheme.labelMedium?.copyWith(
              color: foren.textSecondary,
            ),
          ),
          for (final f in findings)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('•  $f', style: theme.textTheme.bodyMedium),
            ),
          const SizedBox(height: ForenSpace.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Accuracy: ${(accuracy * 100).round()}%',
                style: theme.textTheme.titleSmall,
              ),
              ForenXpChip(amount: xpEarned, showPlus: true),
            ],
          ),
          const SizedBox(height: ForenSpace.md),
          ForenButton.primary(
            label: 'Continue',
            feature: ForenFeature.investigation,
            fullWidth: true,
            onPressed: () {
              Navigator.of(context).pop();
              onContinue();
            },
          ),
        ],
      ),
    );
  }
}

class ForenSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onDismiss;

  const ForenSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel = 'Continue',
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return _ForenDialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: foren.success.t500.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: foren.success.t500,
              size: 32,
            ),
          ),
          const SizedBox(height: ForenSpace.md),
          Text(
            title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ForenSpace.xs),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: foren.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ForenSpace.lg),
          ForenButton.primary(
            label: buttonLabel,
            fullWidth: true,
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss();
            },
          ),
        ],
      ),
    );
  }
}

class ForenWarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ForenWarningDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final ramp = isDestructive ? foren.critical : foren.warning;

    return _ForenDialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ramp.t500.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: ramp.t500,
              size: 32,
            ),
          ),
          const SizedBox(height: ForenSpace.md),
          Text(
            title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ForenSpace.xs),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: foren.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ForenSpace.lg),
          Row(
            children: [
              Expanded(
                child: ForenButton.secondary(
                  label: cancelLabel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: ForenSpace.sm),
              Expanded(
                child: isDestructive
                    ? ForenButton.danger(
                        label: confirmLabel,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                      )
                    : ForenButton.primary(
                        label: confirmLabel,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
