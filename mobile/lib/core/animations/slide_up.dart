import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_motion.dart';

/// A reusable slide-up animation, often paired with a fade effect.
/// Ideal for bottom sheets, cards, or list items entering the screen.
class SlideUp extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// The duration of the slide. Defaults to [AppMotion.normal].
  final Duration? duration;

  /// The delay before the animation starts. Defaults to [Duration.zero].
  final Duration? delay;

  /// The curve of the animation. Defaults to [AppMotion.decelerate] (Material standard for entering).
  final Curve? curve;

  /// The vertical offset to start from. Defaults to 30.0.
  final double offset;

  /// Whether to cross-fade while sliding. Defaults to true.
  final bool fade;

  const SlideUp({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
    this.offset = 30.0,
    this.fade = true,
  });

  @override
  Widget build(BuildContext context) {
    var animation = child
        .animate(delay: delay)
        .moveY(
          begin: offset,
          end: 0,
          duration: duration ?? AppMotion.normal,
          curve: curve ?? AppMotion.decelerate,
        );

    if (fade) {
      animation = animation.fadeIn(
        duration: duration ?? AppMotion.normal,
        curve: curve ?? AppMotion.decelerate,
      );
    }

    return animation;
  }
}
