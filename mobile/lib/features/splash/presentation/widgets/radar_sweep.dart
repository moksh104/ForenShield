import 'package:flutter/material.dart';
import 'dart:math' as math;

class RadarSweep extends StatefulWidget {
  const RadarSweep({super.key});

  @override
  State<RadarSweep> createState() => _RadarSweepState();
}

class _RadarSweepState extends State<RadarSweep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    // Start after a delay and run once
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _RadarPainter(_rotationAnimation.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double rotation;

  _RadarPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Radar circles
    final circlePaint = Paint()
      ..color = const Color(0xFF0F766E).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius * (i / 3),
        circlePaint,
      );
    }

    // Radar sweep gradient
    final gradient = SweepGradient(
      colors: [
        const Color(0xFFC98A2E).withValues(alpha: 0),
        const Color(0xFFC98A2E).withValues(alpha: 0.15),
        const Color(0xFFC98A2E).withValues(alpha: 0),
      ],
      stops: const [0.0, 0.5, 1.0],
      transform: GradientRotation(rotation),
    );

    final sweepPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, sweepPaint);

    // Radar line
    final linePaint = Paint()
      ..color = const Color(0xFFC98A2E).withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    final lineEnd = Offset(
      center.dx + radius * math.cos(rotation - math.pi / 2),
      center.dy + radius * math.sin(rotation - math.pi / 2),
    );

    canvas.drawLine(center, lineEnd, linePaint);

    // Center dot
    final dotPaint = Paint()
      ..color = const Color(0xFFC98A2E).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 3, dotPaint);
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) =>
      rotation != oldDelegate.rotation;
}
