import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../config/onboarding_animation_config.dart';

/// Ambient drifting particle field for onboarding screen backgrounds.
///
/// 14 particles are seeded deterministically (fixed [math.Random] seed per
/// index), ensuring identical layouts across frames and devices.
/// Particles drift upward slowly and wrap around when they leave the top edge.
/// Renders nothing when [MediaQuery.disableAnimations] is true.
class BackgroundParticles extends StatefulWidget {
  const BackgroundParticles({super.key});

  @override
  State<BackgroundParticles> createState() => _BackgroundParticlesState();
}

class _BackgroundParticlesState extends State<BackgroundParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: OnboardingAnimationConfig.particleDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return const SizedBox.expand();
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => RepaintBoundary(
        child: CustomPaint(
          painter: _ParticlePainter(_controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ── Painter ───────────────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double progress;

  const _ParticlePainter(this.progress);

  // Computed once at class load — deterministic across all builds.
  static final _seeds = List<_ParticleSeed>.generate(14, (i) {
    final r = math.Random(i * 31 + 7);
    return _ParticleSeed(
      x: r.nextDouble(),
      yBase: r.nextDouble(),
      radius: 1.2 + r.nextDouble() * 1.8,
      speed: 0.025 + r.nextDouble() * 0.04,
      opacity: 0.07 + r.nextDouble() * 0.15,
      phase: r.nextDouble(),
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final s in _seeds) {
      final y = ((s.yBase - (progress * s.speed + s.phase)) % 1.0 + 1.0) % 1.0;
      paint.color = AppColors.secondary.withValues(alpha: s.opacity);
      canvas.drawCircle(
        Offset(s.x * size.width, y * size.height),
        s.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _ParticleSeed {
  final double x, yBase, radius, speed, opacity, phase;

  _ParticleSeed({
    required this.x,
    required this.yBase,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.phase,
  });
}
