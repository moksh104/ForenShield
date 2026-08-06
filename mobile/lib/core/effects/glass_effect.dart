import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Clean enterprise surface card container.
/// Refactored from heavy glassmorphic blur to a crisp, high-clarity container
/// with soft borders and neutral elevation.
class GlassEffect extends StatelessWidget {
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
    this.blurX = 0.0,
    this.blurY = 0.0,
    this.color,
    this.opacity = 1.0,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.animateGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.cardRadius;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        color ?? (isDark ? AppColors.surface : AppColors.lightSurface);
    final borderColor =
        border ??
        Border.all(
          color: isDark ? AppColors.borderSubtle : AppColors.lightBorderDefault,
          width: 1.0,
        );

    final finalColor = opacity == 1.0
        ? baseColor
        : baseColor.withValues(alpha: (baseColor.a * opacity).clamp(0.0, 1.0));

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: finalColor,
        borderRadius: effectiveRadius,
        border: borderColor,
      ),
      child: child,
    );
  }
}
