import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Reusable cyber glow effect widget.
/// Combines AnimationController and CustomPainter to render pulsating outer
/// or inner neon glow effects around any widget.
class GlowEffect extends StatefulWidget {
  final Widget child;
  final Color? glowColor;
  final double blurRadius;
  final double spreadRadius;
  final Duration duration;
  final bool animate;
  final BorderRadius? borderRadius;

  const GlowEffect({
    super.key,
    required this.child,
    this.glowColor,
    this.blurRadius = 16.0,
    this.spreadRadius = 4.0,
    this.duration = const Duration(milliseconds: 1800),
    this.animate = true,
    this.borderRadius,
  });

  @override
  State<GlowEffect> createState() => _GlowEffectState();
}

class _GlowEffectState extends State<GlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GlowEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.glowColor ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: _GlowPainter(
            color: effectiveColor.withValues(alpha: 0.25 * _glowAnimation.value),
            blurRadius: widget.blurRadius * _glowAnimation.value,
            borderRadius: widget.borderRadius ?? AppRadius.cardRadius,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? AppRadius.cardRadius,
              boxShadow: [
                BoxShadow(
                  color: effectiveColor
                      .withValues(alpha: 0.3 * _glowAnimation.value),
                  blurRadius: widget.blurRadius * _glowAnimation.value,
                  spreadRadius: widget.spreadRadius * _glowAnimation.value,
                ),
              ],
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _GlowPainter extends CustomPainter {
  final Color color;
  final double blurRadius;
  final BorderRadius borderRadius;

  _GlowPainter({
    required this.color,
    required this.blurRadius,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, blurRadius);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.borderRadius != borderRadius;
  }
}
