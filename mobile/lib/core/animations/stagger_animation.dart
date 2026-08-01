import 'package:flutter/material.dart';
import '../theme/app_motion.dart';

/// Reusable generic StaggerAnimation component.
/// Cascades entry delays onto a list of children widgets.
class StaggerAnimation extends StatelessWidget {
  /// The list of children to stagger.
  final List<Widget> children;

  /// The time gap between each child's animation. Defaults to [AppMotion.stagger1] (50ms).
  final Duration interval;

  /// Layout axis direction. Defaults to [Axis.vertical].
  final Axis direction;

  /// Main axis size constraint. Defaults to [MainAxisSize.min].
  final MainAxisSize mainAxisSize;

  /// Cross axis alignment. Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment crossAxisAlignment;

  /// Builder function providing the constructed delay for each child index.
  final Widget Function(Widget child, Duration delay) builder;

  const StaggerAnimation({
    super.key,
    required this.children,
    this.interval = AppMotion.stagger1,
    this.direction = Axis.vertical,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final list = List.generate(children.length, (index) {
      final delay = interval * index;
      return builder(children[index], delay);
    });

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: list,
      );
    }

    return Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: list,
    );
  }
}

/// Backwards compatibility alias for Stagger
typedef Stagger = StaggerAnimation;
