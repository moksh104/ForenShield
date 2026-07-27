import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

/// A standardized Pull-To-Refresh layout wrapper.
/// Follows the ForenShield color scheme and Material 3 design parameters.
class AppRefreshLayout extends StatelessWidget {
  /// The scrollable child widget. Must contain a Scrollable (like ListView or SingleChildScrollView).
  final Widget child;

  /// The asynchronous callback invoked when a refresh is triggered.
  final Future<void> Function() onRefresh;

  const AppRefreshLayout({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceElevated,
      strokeWidth: 2.5,
      child: child,
    );
  }
}
