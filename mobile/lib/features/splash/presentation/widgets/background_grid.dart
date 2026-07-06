import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundGrid extends StatefulWidget {
  const BackgroundGrid({super.key});

  @override
  State<BackgroundGrid> createState() => _BackgroundGridState();
}

class _BackgroundGridState extends State<BackgroundGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
        return CustomPaint(
          painter: _GridPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final double animationValue;

  _GridPainter(this.animationValue);

  static const _gridSpacing = 40.0;
  static const _dotRadius = 1.5;
  static const _numMapLines = 8;
  static const _randomSeed = 42;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F766E).withValues(alpha: 0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFFC98A2E).withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final offsetY = animationValue * _gridSpacing;

    // Vertical lines
    for (double x = 0; x < size.width; x += _gridSpacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines with parallax
    for (double y = -_gridSpacing; y < size.height + _gridSpacing; y += _gridSpacing) {
      final adjustedY = (y + offsetY) % (size.height + _gridSpacing);
      canvas.drawLine(
        Offset(0, adjustedY),
        Offset(size.width, adjustedY),
        paint,
      );
    }

    // Subtle dots at intersections
    for (double x = 0; x < size.width; x += _gridSpacing * 2) {
      for (double y = 0; y < size.height; y += _gridSpacing * 2) {
        final adjustedY = (y + offsetY) % (size.height + _gridSpacing);
        canvas.drawCircle(Offset(x, adjustedY), _dotRadius, dotPaint);
      }
    }

    // Investigation map lines (subtle diagonal connections)
    final mapPaint = Paint()
      ..color = const Color(0xFF0F766E).withValues(alpha: 0.02)
      ..strokeWidth = 0.5;

    final random = math.Random(_randomSeed);
    for (int i = 0; i < _numMapLines; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = random.nextDouble() * size.width;
      final y2 = random.nextDouble() * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), mapPaint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
