import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_motion.dart';

/// Direction enum for slide transitions.
enum SlideDirection { up, down, left, right }

/// Reusable generic SlideAnimation component.
/// Uses flutter_animate with AppMotion duration and curve tokens.
class SlideAnimation extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// The duration of the slide. Defaults to [AppMotion.normal].
  final Duration? duration;

  /// The delay before the animation starts. Defaults to [Duration.zero].
  final Duration? delay;

  /// The curve of the animation. Defaults to [AppMotion.slide].
  final Curve? curve;

  /// The offset distance to slide from. Defaults to 30.0.
  final double offset;

  /// Direction of the entry slide. Defaults to [SlideDirection.up].
  final SlideDirection direction;

  /// Whether to cross-fade while sliding. Defaults to true.
  final bool fade;

  const SlideAnimation({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
    this.offset = 30.0,
    this.direction = SlideDirection.up,
    this.fade = true,
  });

  @override
  Widget build(BuildContext context) {
    double beginX = 0;
    double beginY = 0;

    switch (direction) {
      case SlideDirection.up:
        beginY = offset;
        break;
      case SlideDirection.down:
        beginY = -offset;
        break;
      case SlideDirection.left:
        beginX = offset;
        break;
      case SlideDirection.right:
        beginX = -offset;
        break;
    }

    var animation = child
        .animate(delay: delay)
        .move(
          begin: Offset(beginX, beginY),
          end: Offset.zero,
          duration: duration ?? AppMotion.normal,
          curve: curve ?? AppMotion.slide,
        );

    if (fade) {
      animation = animation.fadeIn(
        duration: duration ?? AppMotion.normal,
        curve: curve ?? AppMotion.fade,
      );
    }

    return animation;
  }
}

/// Backwards compatibility alias for SlideUp
typedef SlideUp = SlideAnimation;
