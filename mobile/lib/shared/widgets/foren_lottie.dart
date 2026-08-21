import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Reusable ForenShield Lottie widget that safely loads Lottie animations
/// and gracefully falls back to a Material 3 themed widget if the asset is missing.
class ForenLottie extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final bool repeat;
  final bool animate;
  final BoxFit? fit;
  final String? semanticLabel;
  final Widget? fallbackWidget;
  final IconData? fallbackIcon;

  const ForenLottie({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.repeat = true,
    this.animate = true,
    this.fit,
    this.semanticLabel,
    this.fallbackWidget,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      repeat: repeat,
      animate: animate,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallback(context);
      },
    );
  }

  Widget _buildFallback(BuildContext context) {
    if (fallbackWidget != null) {
      return fallbackWidget!;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final w = width ?? 100.0;
    final h = height ?? 100.0;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Center(
        child: Icon(
          fallbackIcon ?? Icons.animation_outlined,
          size: (w < h ? w : h) * 0.4,
          color: colorScheme.primary,
          semanticLabel: semanticLabel ?? 'Animation unavailable',
        ),
      ),
    );
  }
}
