import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../config/onboarding_animation_config.dart';

/// Cyber Academy onboarding illustration.
///
/// Concept: holographic training console — a central progress ring
/// with a terminal icon, surrounded by four floating lesson nodes.
/// Background scan lines (CustomPainter) reinforce the terminal aesthetic.
///
/// Hybrid: ~70% Flutter widgets, ~30% CustomPainter.
class AcademyIllustration extends StatefulWidget {
  final bool animate;
  const AcademyIllustration({super.key, this.animate = true});

  @override
  State<AcademyIllustration> createState() => _AcademyIllustrationState();
}

class _AcademyIllustrationState extends State<AcademyIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _scan;
  late final Animation<double> _ringProgress;
  late final Animation<double> _consoleOpacity;
  late final Animation<double> _nodesOpacity;

  /// Lesson node data: (alignment, icon, label, color)
  static const _lessons = [
    (
      Alignment(-0.72, -0.48),
      Icons.alternate_email_rounded,
      'Phishing',
      AppColors.error,
    ),
    (Alignment(0.74, -0.40), Icons.qr_code, 'QR Fraud', AppColors.accent),
    (
      Alignment(-0.68, 0.52),
      Icons.lock_rounded,
      'OTP Scams',
      AppColors.secondary,
    ),
    (
      Alignment(0.68, 0.58),
      Icons.record_voice_over_rounded,
      'Social Eng.',
      AppColors.primary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: OnboardingAnimationConfig.entryDuration,
    );
    _scan = AnimationController(
      vsync: this,
      duration: OnboardingAnimationConfig.scanLineDuration,
    )..repeat();

    _ringProgress = _entry.drive(
      Tween<double>(begin: 0.0, end: 0.68).chain(
        CurveTween(curve: const Interval(0.0, 0.72, curve: Curves.easeInOut)),
      ),
    );
    _consoleOpacity = _entry.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.42, curve: Curves.easeOut)),
      ),
    );
    _nodesOpacity = _entry.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.52, 1.0, curve: Curves.easeOut)),
      ),
    );

    if (widget.animate) {
      Future.delayed(OnboardingAnimationConfig.illustrationEntryDelay, () {
        if (mounted) _entry.forward();
      });
    } else {
      _entry.value = 1.0;
    }
  }

  @override
  void dispose() {
    _entry.dispose();
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Illustration: training console with lesson topics',
      excludeSemantics: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Scan lines
          AnimatedBuilder(
            animation: _scan,
            builder: (_, child) => CustomPaint(
              painter: _ScanLinePainter(_scan.value),
              size: Size.infinite,
            ),
          ),
          // Lesson nodes
          FadeTransition(
            opacity: _nodesOpacity,
            child: Stack(
              alignment: Alignment.center,
              children: _lessons.map((l) {
                final (alignment, icon, label, color) = l;
                return Align(
                  alignment: alignment,
                  child: _LessonNode(icon: icon, label: label, color: color),
                );
              }).toList(),
            ),
          ),
          // Central training console
          _buildConsole(),
        ],
      ),
    );
  }

  Widget _buildConsole() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Progress ring
        AnimatedBuilder(
          animation: _ringProgress,
          builder: (_, child) => SizedBox(
            width: 104,
            height: 104,
            child: CircularProgressIndicator(
              value: _ringProgress.value,
              backgroundColor: AppColors.outline,
              color: AppColors.primary,
              strokeWidth: 3.0,
            ),
          ),
        ),
        // Terminal icon
        FadeTransition(
          opacity: _consoleOpacity,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.52),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.26),
                  blurRadius: 26,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.terminal_rounded,
              color: AppColors.primary,
              size: 38,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Lesson Node ───────────────────────────────────────────────────────────────

class _LessonNode extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _LessonNode({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

// ── Scan Line Painter ─────────────────────────────────────────────────────────

/// Draws a static grid of horizontal scan lines plus a moving highlight beam.
class _ScanLinePainter extends CustomPainter {
  final double progress;
  const _ScanLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.05)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (double y = 0; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final beamY = size.height * progress;
    final beamPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.12)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, beamY), Offset(size.width, beamY), beamPaint);
  }

  @override
  bool shouldRepaint(_ScanLinePainter old) => old.progress != progress;
}
