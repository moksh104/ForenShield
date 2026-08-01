import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable radar & laser sweep scanner effect widget.
/// Renders animated radar sweep arcs and grid lines over security metrics or loading states.
class ScannerEffect extends StatefulWidget {
  final Widget? child;
  final double size;
  final Color? color;
  final Duration duration;

  const ScannerEffect({
    super.key,
    this.child,
    this.size = 200.0,
    this.color,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<ScannerEffect> createState() => _ScannerEffectState();
}

class _ScannerEffectState extends State<ScannerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ScannerPainter(
              progress: _controller.value,
              color: effectiveColor,
            ),
            child: widget.child != null ? Center(child: widget.child) : null,
          );
        },
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScannerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Grid circles
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, gridPaint);
    canvas.drawCircle(center, radius * 0.66, gridPaint);
    canvas.drawCircle(center, radius * 0.33, gridPaint);

    // Crosshair lines
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      gridPaint,
    );

    // Sweep arc
    final angle = progress * 2 * math.pi;
    final sweepGradient = SweepGradient(
      center: Alignment.center,
      startAngle: angle - math.pi / 3,
      endAngle: angle,
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.35),
      ],
    );

    final sweepPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, sweepPaint);

    // Sweep line
    final lineX = center.dx + radius * math.cos(angle);
    final lineY = center.dy + radius * math.sin(angle);
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(center, Offset(lineX, lineY), linePaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
