import 'package:flutter/material.dart';
import '../app_error_state.dart';
import 'app_scaffold.dart';

/// A layout used when a screen encounters a fatal error or network failure.
class AppErrorLayout extends StatelessWidget {
  /// The primary error heading.
  final String title;

  /// The descriptive context text.
  final String description;

  /// Callback triggered when the user attempts a retry.
  final VoidCallback onRetry;

  /// If true, returns a full [AppScaffold]. If false, returns a centered error state.
  final bool isFullScreen;

  const AppErrorLayout({
    super.key,
    this.title = 'An Error Occurred',
    required this.description,
    required this.onRetry,
    this.isFullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget errorContent = AppErrorState(
      title: title,
      description: description,
      onRetry: onRetry,
    );

    if (isFullScreen) {
      return AppScaffold(body: errorContent);
    }

    return errorContent;
  }
}
