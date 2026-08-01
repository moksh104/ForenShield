import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

/// Reusable generic FloatingAnimation component with dark mode support.
/// Creates a continuous floating/bobbing vertical effect for illustrations or badges.
class FloatingAnimation extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// Duration of one floating cycle. Defaults to [AppMotion.slower] (800ms).
  final Duration? duration;

  /// Curve of the animation. Defaults to [AppMotion.slide].
  final Curve? curve;

  /// Vertical float displacement distance in pixels. Defaults to 8.0.
  final double distance;

  /// Whether to render a dynamic soft floor shadow beneath the floating element. Defaults to false.
  final bool enableShadow;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.duration,
    this.curve,
    this.distance = 8.0,
    this.enableShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : AppColors.borderDefault.withValues(alpha: 0.3);

    Widget content = child;

    if (enableShadow) {
      content = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      );
    }

    return content
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: -distance / 2,
          end: distance / 2,
          duration: duration ?? AppMotion.slower,
          curve: curve ?? AppMotion.slide,
        );
  }
}
