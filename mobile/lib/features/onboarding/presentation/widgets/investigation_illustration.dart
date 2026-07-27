import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../config/onboarding_animation_config.dart';

/// Screen 3 illustration — digital evidence investigation board.
///
/// Central evidence board (amber glow, rounded rectangle) surrounded by four
/// typed evidence nodes. Amber ripple rings + a drawing timeline convey urgency.
/// Connection lines appear after the board, then evidence nodes snap in.
class InvestigationIllustration extends StatefulWidget {
  final bool animate;
  const InvestigationIllustration({super.key, this.animate = true});

  @override
  State<InvestigationIllustration> createState() => _InvestigationIllustrationState();
}

class _InvestigationIllustrationState extends State<InvestigationIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _ripple;
  late final Animation<double> _boardScale;
  late final Animation<double> _boardOpacity;
  late final Animation<double> _connectionsOpacity;
  late final Animation<double> _nodesOpacity;
  late final Animation<double> _timelineProgress;

  static const _evidence = [
    (Alignment(-0.72, -0.46), Icons.email_rounded, 'Email', AppColors.secondary),
    (Alignment(0.74, -0.38), Icons.chat_rounded, 'Chat Logs', AppColors.primary),
    (Alignment(-0.66, 0.52), Icons.language_rounded, 'Browser', AppColors.error),
    (Alignment(0.68, 0.56), Icons.payments_rounded, 'Transactions', AppColors.success),
  ];

  // Collapses the repeated Tween + CurveTween + Interval pattern.
  Animation<double> _interval(double from, double to, Curve curve) =>
      _entry.drive(Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Interval(from, to, curve: curve)),
      ));

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(vsync: this, duration: OnboardingAnimationConfig.entryDuration);
    _ripple = AnimationController(vsync: this, duration: OnboardingAnimationConfig.radarDuration)
      ..repeat();

    _boardOpacity = _interval(0.0, 0.38, Curves.easeOut);
    _connectionsOpacity = _interval(0.35, 0.65, Curves.easeOut);
    _nodesOpacity = _interval(0.55, 0.85, Curves.easeOut);
    _timelineProgress = _interval(0.72, 1.0, Curves.easeInOut);
    _boardScale = _entry.drive(
      Tween<double>(begin: 0.70, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.50, curve: Curves.elasticOut)),
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
    _ripple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Evidence board with email, chat, browser and transaction nodes',
      excludeSemantics: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Amber ripple rings
          AnimatedBuilder(
            animation: _ripple,
            builder: (_, child) => CustomPaint(
              painter: _RipplePainter(_ripple.value),
              size: Size.infinite,
            ),
          ),
          // Connection lines + timeline (single painter, two animation inputs)
          AnimatedBuilder(
            animation: _entry,
            builder: (_, child) => CustomPaint(
              painter: _BoardBackgroundPainter(
                connectionsOpacity: _connectionsOpacity.value,
                timelineProgress: _timelineProgress.value,
              ),
              size: Size.infinite,
            ),
          ),
          // Evidence nodes
          FadeTransition(
            opacity: _nodesOpacity,
            child: Stack(
              alignment: Alignment.center,
              children: _evidence.map((e) {
                final (alignment, icon, label, color) = e;
                return Align(
                  alignment: alignment,
                  child: _EvidenceCard(icon: icon, label: label, color: color),
                );
              }).toList(),
            ),
          ),
          // Central board
          ScaleTransition(
            scale: _boardScale,
            child: FadeTransition(
              opacity: _boardOpacity,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.borderLg,
                  color: AppColors.accent.withValues(alpha: 0.11),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.55), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.26),
                      blurRadius: 26,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.manage_search_rounded, color: AppColors.accent, size: 44),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Evidence Card ─────────────────────────────────────────────────────────────

class _EvidenceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _EvidenceCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
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

// ── Painters ──────────────────────────────────────────────────────────────────

class _RipplePainter extends CustomPainter {
  final double progress;
  const _RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.shortestSide * 0.42;
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2;
    for (var i = 0; i < 3; i++) {
      final phase = (progress + i / 3.0) % 1.0;
      p.color = AppColors.accent.withValues(alpha: (1.0 - phase) * 0.22);
      canvas.drawCircle(center, maxR * phase, p);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.progress != progress;
}

/// Draws connection lines from board center to evidence nodes,
/// and a drawing timeline bar near the bottom of the illustration.
class _BoardBackgroundPainter extends CustomPainter {
  final double connectionsOpacity;
  final double timelineProgress;

  const _BoardBackgroundPainter({
    required this.connectionsOpacity,
    required this.timelineProgress,
  });

  static const _alignments = [
    Alignment(-0.72, -0.46),
    Alignment(0.74, -0.38),
    Alignment(-0.66, 0.52),
    Alignment(0.68, 0.56),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (connectionsOpacity > 0) {
      final lp = Paint()
        ..color = AppColors.accent.withValues(alpha: 0.16 * connectionsOpacity)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;
      for (final a in _alignments) {
        canvas.drawLine(center,
            Offset(center.dx + a.x * size.width / 2, center.dy + a.y * size.height / 2), lp);
      }
    }

    if (timelineProgress > 0) {
      final y = size.height * 0.82;
      final sx = size.width * 0.12;
      final ex = size.width * 0.88;

      canvas.drawLine(Offset(sx, y), Offset(ex, y),
          Paint()..color = AppColors.outline..strokeWidth = 1.5..style = PaintingStyle.stroke);

      canvas.drawLine(
        Offset(sx, y),
        Offset(sx + (ex - sx) * timelineProgress, y),
        Paint()..color = AppColors.accent.withValues(alpha: 0.8)..strokeWidth = 2.5..style = PaintingStyle.stroke,
      );

      for (var i = 0; i <= 4; i++) {
        final x = sx + (ex - sx) * (i / 4);
        canvas.drawLine(Offset(x, y - 4), Offset(x, y + 4),
            Paint()
              ..color = (i / 4 <= timelineProgress) ? AppColors.accent : AppColors.outline
              ..strokeWidth = 1.5..style = PaintingStyle.stroke);
      }
    }
  }

  @override
  bool shouldRepaint(_BoardBackgroundPainter old) =>
      old.connectionsOpacity != connectionsOpacity || old.timelineProgress != timelineProgress;
}
