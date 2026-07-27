import 'package:flutter/material.dart';
import '../theme/app_motion.dart';

/// A utility component that cascades entry delays onto a list of children.
/// Used to create sweeping, staggered list entries without manual delay management.
class Stagger extends StatelessWidget {
  /// The list of animated children to stagger.
  final List<Widget> children;

  /// The time gap between each child's animation. Defaults to [AppMotion.stagger1] (50ms).
  final Duration interval;

  /// Builder function that provides the constructed delay for each child index.
  final Widget Function(Widget child, Duration delay) builder;

  const Stagger({
    super.key,
    required this.children,
    this.interval = AppMotion.stagger1,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(children.length, (index) {
        final delay = interval * index;
        return builder(children[index], delay);
      }),
    );
  }
}
