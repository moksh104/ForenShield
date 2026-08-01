import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Premium glassmorphism effect container widget.
/// Combines BackdropFilter for gaussian blur, translucency gradient,
/// and subtle border highlights for dark/light themes.
class GlassEffect extends StatefulWidget {
  final Widget child;
  final double blurX;
  final double blurY;
  final Color? color;
  final double opacity;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool animateGlow;

  const GlassEffect({
    super.key,
    required this.child,
    this.blurX = 12.0,
    this.blurY = 12.0,
    this.color,
    this.opacity = 0.12,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.animateGlow = false,
  });

  @override
  State<GlassEffect> createState() => _GlassEffectState();
}

class _GlassEffectState extends State<GlassEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    if (widget.animateGlow) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GlassEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateGlow != oldWidget.animateGlow) {
      if (widget.animateGlow) {
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
    final effectiveRadius = widget.borderRadius ?? AppRadius.cardRadius;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.color ??
        (isDark ? AppColors.surface : AppColors.lightSurface);
    final borderColor = widget.border ??
        Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : AppColors.borderSubtle,
          width: 1.0,
        );

    return Container(
      margin: widget.margin,
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurX,
            sigmaY: widget.blurY,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: baseColor.withValues(alpha: widget.opacity),
                  borderRadius: effectiveRadius,
                  border: borderColor,
                ),
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}
