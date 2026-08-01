import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Futuristic cybersecurity radar sweep widget.
class RadarSweep extends StatefulWidget {
  const RadarSweep({super.key});

  @override
  State<RadarSweep> createState() => _RadarSweepState();
}

class _RadarSweepState extends State<RadarSweep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RepaintBoundary(
          child: CustomPaint(
            painter: _RadarPainter(_controller.value * 2 * math.pi),
            child: const SizedBox.expand(),
          ),
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
    final radius = math.min(size.width, size.height) / 2;

    // Outer and Inner Concentric Radar Grid Circles
    final circlePaint = Paint()
      ..color = AppColors.logoGold.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(
        center,
        radius * (i / 4),
        circlePaint,
      );
    }

    // Crosshair Axis Lines
    final axisPaint = Paint()
      ..color = AppColors.logoTeal.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      axisPaint,
    );

    // Radar 360° Sweep Gradient Arc
    final sweepGradient = SweepGradient(
      center: Alignment.center,
      startAngle: rotation - math.pi / 2,
      endAngle: rotation,
      colors: [
        AppColors.logoGold.withValues(alpha: 0.0),
        AppColors.logoGold.withValues(alpha: 0.22),
      ],
    );

    final sweepPaint = Paint()
      ..shader = sweepGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, sweepPaint);

    // Rotating Radar Laser Sweep Line
    final linePaint = Paint()
      ..color = AppColors.logoGold.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final lineEnd = Offset(
      center.dx + radius * math.cos(rotation),
      center.dy + radius * math.sin(rotation),
    );

    canvas.drawLine(center, lineEnd, linePaint);

    // Pulsating Center Beacon Dot
    final dotPaint = Paint()
      ..color = AppColors.logoGold
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 3.5, dotPaint);

    // Outer Ring Glow Accent
    final ringGlowPaint = Paint()
      ..color = AppColors.logoBlue.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, ringGlowPaint);
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) =>
      rotation != oldDelegate.rotation;
}
