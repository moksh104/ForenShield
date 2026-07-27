import 'package:flutter/material.dart';

/// Wrappers that reduce boilerplate when nesting widgets in layout modifiers.
extension WidgetExtension on Widget {
  /// Wraps the widget in a uniform [EdgeInsets.all] Padding.
  Widget paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// Wraps the widget in symmetric Padding.
  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Wraps the widget in a SliverToBoxAdapter for use inside CustomScrollViews.
  Widget toSliver() {
    return SliverToBoxAdapter(child: this);
  }

  /// Conditionally displays the widget. If [condition] is false, returns a [SizedBox.shrink].
  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }
}
