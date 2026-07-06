import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

/// A card component that applies a frosted glass effect to its background.
/// 
/// Used for overlapping UI elements to maintain context of what's behind them.
class GlassCard extends StatelessWidget {
  /// The content of the card.
  final Widget child;

  /// The amount of gaussian blur to apply to the background.
  final double blur;

  /// The opacity of the surface color overlay.
  final double opacity;

  /// Whether to show a subtle outline border.
  final bool hasBorder;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// Border radius override.
  final BorderRadius? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.hasBorder = true,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.borderMd;

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: opacity),
            borderRadius: effectiveRadius,
            border: hasBorder 
                ? Border.all(color: AppColors.outline.withValues(alpha: opacity + 0.1), width: 1)
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
