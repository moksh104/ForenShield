/// ForenShield Component Library — Progress Components
/// XP Progress / Mission Progress / Circular Score / Learning Progress
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

export '../widgets/app_loading.dart';
export '../widgets/app_loading_state.dart';
export '../widgets/progress/circular_progress_card.dart';
export '../widgets/progress/linear_progress_card.dart';
export '../widgets/progress/xp_progress_bar.dart';

/// Shared linear bar used by XP / Mission / Learning progress —
/// only the accent color and optional label differ between them.
class _ForenLinearProgress extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final String? label;
  final String? trailingText;

  const _ForenLinearProgress({
    required this.value,
    required this.color,
    this.label,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || trailingText != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(label!, style: theme.textTheme.labelMedium?.copyWith(color: foren.textSecondary)),
              if (trailingText != null)
                Text(trailingText!, style: theme.textTheme.labelMedium?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: ForenSpace.xs),
        ],
        ClipRRect(
          borderRadius: ForenRadius.pillBr,
          child: LinearProgressIndicator(
            value: value.clamp(0, 1),
            minHeight: 8,
            backgroundColor: foren.surfaceRaised2,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

/// XP toward next level. Always Academy amber (XP is a learning concept).
class ForenXpProgress extends StatelessWidget {
  final int currentXp;
  final int nextLevelXp;
  const ForenXpProgress({super.key, required this.currentXp, required this.nextLevelXp});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    return _ForenLinearProgress(
      value: nextLevelXp == 0 ? 0 : currentXp / nextLevelXp,
      color: foren.academy.t500,
      label: 'XP',
      trailingText: '$currentXp / $nextLevelXp',
    );
  }
}

/// Steps completed within an active mission. Tinted with the
/// mission's owning feature (usually Mission Control cyan).
class ForenMissionProgress extends StatelessWidget {
  final int completedSteps;
  final int totalSteps;
  const ForenMissionProgress({super.key, required this.completedSteps, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    return _ForenLinearProgress(
      value: totalSteps == 0 ? 0 : completedSteps / totalSteps,
      color: foren.missionControl.t500,
      label: 'MISSION PROGRESS',
      trailingText: '$completedSteps / $totalSteps',
    );
  }
}

/// Course/lesson completion. Always Academy amber.
class ForenLearningProgress extends StatelessWidget {
  final double percent; // 0..1
  const ForenLearningProgress({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;
    return _ForenLinearProgress(
      value: percent,
      color: foren.academy.t500,
      trailingText: '${(percent * 100).round()}%',
    );
  }
}

/// Circular ring score — used for the Threat Dashboard's headline
/// metrics (Security Posture %, Investigation Accuracy %, etc).
class ForenCircularScore extends StatelessWidget {
  final double percent; // 0..1
  final String label;
  final Color? color; // defaults to a semantic ramp based on value
  final double size;

  const ForenCircularScore({
    super.key,
    required this.percent,
    required this.label,
    this.color,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final ringColor = color ??
        (percent >= 0.75
            ? foren.success.t500
            : percent >= 0.5
                ? foren.warning.t500
                : foren.critical.t500);

    return SizedBox(
      width: size,
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _RingPainter(percent: percent, color: ringColor, track: foren.surfaceRaised2),
              child: Center(
                child: Text(
                  '${(percent * 100).round()}%',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          ),
          const SizedBox(height: ForenSpace.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: foren.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  final Color color;
  final Color track;
  _RingPainter({required this.percent, required this.color, required this.track});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.09;
    final center = size.center(Offset.zero);
    final radius = (size.width - stroke) / 2;

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final sweep = 2 * math.pi * percent.clamp(0, 1);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.color != color;
}
