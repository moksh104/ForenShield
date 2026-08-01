import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Interactive background particle effect widget.
/// Renders floating network node particles connected with subtle glowing lines.
class ParticleBackground extends StatefulWidget {
  final Widget? child;
  final int numberOfParticles;
  final Color? particleColor;
  final Duration duration;

  const ParticleBackground({
    super.key,
    this.child,
    this.numberOfParticles = 25,
    this.particleColor,
    this.duration = const Duration(seconds: 15),
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _particles = List.generate(widget.numberOfParticles, (index) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 2.5 + 1.5,
        vx: (_random.nextDouble() - 0.5) * 0.2,
        vy: (_random.nextDouble() - 0.5) * 0.2,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.particleColor ?? AppColors.primary;

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ParticlePainter(
                particles: _particles,
                progress: _controller.value,
                color: effectiveColor,
              ),
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  double radius;
  double vx;
  double vy;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.vx,
    required this.vy,
  });

  void update() {
    x += vx * 0.01;
    y += vy * 0.01;

    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    for (var i = 0; i < particles.length; i++) {
      particles[i].update();
      final p1 = Offset(particles[i].x * size.width, particles[i].y * size.height);
      canvas.drawCircle(p1, particles[i].radius, paint);

      for (var j = i + 1; j < particles.length; j++) {
        final p2 = Offset(particles[j].x * size.width, particles[j].y * size.height);
        final distance = (p1 - p2).distance;

        if (distance < 100.0) {
          linePaint.color = color.withValues(alpha: (1.0 - distance / 100.0) * 0.15);
          canvas.drawLine(p1, p2, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
