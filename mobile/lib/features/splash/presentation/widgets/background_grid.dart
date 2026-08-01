import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Animated cybersecurity background grid painter with parallax & node dot accents.
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
      duration: const Duration(seconds: 22),
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
            painter: _GridPainter(_controller.value),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final double animationValue;

  _GridPainter(this.animationValue);

  static const _gridSpacing = 44.0;
  static const _dotRadius = 1.5;
  static const _numMapLines = 10;
  static const _randomSeed = 42;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.logoTeal.withValues(alpha: 0.04)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.logoGold.withValues(alpha: 0.08)
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

    // Horizontal lines with parallax shift
    for (double y = -_gridSpacing; y < size.height + _gridSpacing; y += _gridSpacing) {
      final adjustedY = (y + offsetY) % (size.height + _gridSpacing);
      canvas.drawLine(
        Offset(0, adjustedY),
        Offset(size.width, adjustedY),
        paint,
      );
    }

    // Subtle dots at grid intersections
    for (double x = 0; x < size.width; x += _gridSpacing * 2) {
      for (double y = 0; y < size.height; y += _gridSpacing * 2) {
        final adjustedY = (y + offsetY) % (size.height + _gridSpacing);
        canvas.drawCircle(Offset(x, adjustedY), _dotRadius, dotPaint);
      }
    }

    // Cyber network vector lines (subtle diagonal node connections)
    final mapPaint = Paint()
      ..color = AppColors.logoTeal.withValues(alpha: 0.03)
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
