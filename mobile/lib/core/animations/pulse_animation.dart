import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

/// Reusable generic PulseAnimation component with dark mode support.
/// Creates a rhythmic pulsating scale/glow effect for active indicators, alerts, or cards.
class PulseAnimation extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// The duration for one pulse loop. Defaults to [AppMotion.slow].
  final Duration? duration;

  /// The curve of the animation. Defaults to [AppMotion.bounce].
  final Curve? curve;

  /// Minimum scale ratio. Defaults to 0.95.
  final double minScale;

  /// Maximum scale ratio. Defaults to 1.05.
  final double maxScale;

  /// Optional glow shadow color.
  final Color? glowColor;

  /// Whether to enable outer glow shadow. Defaults to false.
  final bool enableGlow;

  /// Whether the animation loops automatically. Defaults to true.
  final bool autoPlay;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration,
    this.curve,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.glowColor,
    this.enableGlow = false,
    this.autoPlay = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveGlowColor = glowColor ??
        (isDark
            ? AppColors.primary.withValues(alpha: 0.35)
            : AppColors.primaryDark.withValues(alpha: 0.25));

    Widget content = child;

    if (enableGlow) {
      content = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: effectiveGlowColor,
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      );
    }

    if (!autoPlay) return content;

    return content
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: Offset(minScale, minScale),
          end: Offset(maxScale, maxScale),
          duration: duration ?? AppMotion.slow,
          curve: curve ?? AppMotion.bounce,
        );
  }
}
