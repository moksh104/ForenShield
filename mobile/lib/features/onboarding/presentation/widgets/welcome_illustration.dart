import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../config/onboarding_animation_config.dart';

/// Welcome screen illustration composed of:
/// - Center shield (Flutter widget, animated scale + fade)
/// - Radar pulse rings (CustomPainter, looping)
/// - Connection lines from nodes to center (CustomPainter)
/// - Four floating evidence nodes (Flutter widgets, fading in)
///
/// Hybrid: ~70% widget tree, ~30% CustomPainter.
/// Pass [animate] = false to show the final state immediately.
class WelcomeIllustration extends StatefulWidget {
  final bool animate;
  const WelcomeIllustration({super.key, this.animate = true});

  @override
  State<WelcomeIllustration> createState() => _WelcomeIllustrationState();
}

class _WelcomeIllustrationState extends State<WelcomeIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _radar;
  late final Animation<double> _shieldScale;
  late final Animation<double> _shieldOpacity;
  late final Animation<double> _nodesOpacity;

  /// Node data: (alignment, icon, label, color)
  static const _nodes = [
    (Alignment(-0.68, -0.52), Icons.wifi_rounded, 'Network', AppColors.secondary),
    (Alignment(0.72, -0.44), Icons.mail_rounded, 'Email', AppColors.primary),
    (Alignment(-0.62, 0.56), Icons.bug_report_rounded, 'Malware', AppColors.error),
    (Alignment(0.62, 0.60), Icons.phone_android_rounded, 'Device', AppColors.accent),
  ];

  @override
  void initState() {
    super.initState();

    _entry = AnimationController(vsync: this, duration: OnboardingAnimationConfig.entryDuration);
    _radar = AnimationController(
      vsync: this,
      duration: OnboardingAnimationConfig.radarDuration,
    )..repeat();

    _shieldScale = _entry.drive(
      Tween<double>(begin: 0.72, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.60, curve: Curves.elasticOut)),
      ),
    );
    _shieldOpacity = _entry.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.40, curve: Curves.easeOut)),
      ),
    );
    _nodesOpacity = _entry.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.55, 1.0, curve: Curves.easeOut)),
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
    _radar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Security illustration: central shield surrounded by evidence nodes',
      excludeSemantics: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Radar rings ──────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _radar,
            builder: (_, child) => CustomPaint(
              painter: _RadarPainter(_radar.value),
              size: Size.infinite,
            ),
          ),
          // ── Connection lines (fades with nodes) ──────────────────────────
          FadeTransition(
            opacity: _nodesOpacity,
            child: const CustomPaint(
              painter: _ConnectionPainter(),
              size: Size.infinite,
            ),
          ),
          // ── Evidence nodes ───────────────────────────────────────────────
          FadeTransition(
            opacity: _nodesOpacity,
            child: Stack(
              alignment: Alignment.center,
              children: _nodes.map((n) {
                final (alignment, icon, label, color) = n;
                return Align(
                  alignment: alignment,
                  child: _EvidenceNode(icon: icon, label: label, color: color),
                );
              }).toList(),
            ),
          ),
          // ── Center shield ────────────────────────────────────────────────
          ScaleTransition(
            scale: _shieldScale,
            child: FadeTransition(
              opacity: _shieldOpacity,
              child: _buildShield(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShield() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 28,
            spreadRadius: 6,
          ),
        ],
      ),
      child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 44),
    );
  }
}

// ── Evidence Node ─────────────────────────────────────────────────────────────

class _EvidenceNode extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _EvidenceNode({
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
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

// ── Painters ──────────────────────────────────────────────────────────────────

/// Three expanding radar rings that loop at staggered phases.
class _RadarPainter extends CustomPainter {
  final double progress;
  const _RadarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.shortestSide * 0.44;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var i = 0; i < 3; i++) {
      final phase = (progress + i / 3.0) % 1.0;
      paint.color = AppColors.secondary.withValues(alpha: (1.0 - phase) * 0.28);
      canvas.drawCircle(center, maxR * phase, paint);
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) => old.progress != progress;
}

/// Faint lines from center to each evidence node position.
class _ConnectionPainter extends CustomPainter {
  const _ConnectionPainter();

  static const _alignments = [
    Alignment(-0.68, -0.52),
    Alignment(0.72, -0.44),
    Alignment(-0.62, 0.56),
    Alignment(0.62, 0.60),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.14)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (final a in _alignments) {
      canvas.drawLine(
        center,
        Offset(center.dx + a.x * size.width / 2, center.dy + a.y * size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConnectionPainter _) => false;
}
