import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Clean accent focus shadow & subtle border highlight component.
/// Stripped of heavy cyberpunk neon glow in favor of modern, subtle drop shadows
/// matching Linear/Stripe design standards.
class GlowEffect extends StatelessWidget {
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
    this.blurRadius = 10.0,
    this.spreadRadius = 0.0,
    this.duration = const Duration(milliseconds: 1800),
    this.animate = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = glowColor ?? AppColors.primary;
    final effectiveRadius = borderRadius ?? AppRadius.cardRadius;

    return Container(
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.12),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
