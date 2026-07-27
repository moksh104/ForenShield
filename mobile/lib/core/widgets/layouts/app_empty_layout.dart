import 'package:flutter/material.dart';
import '../app_empty_state.dart';
import 'app_scaffold.dart';

/// A layout used to display empty lists or lack of data.
class AppEmptyLayout extends StatelessWidget {
  /// The primary heading.
  final String title;

  /// The descriptive context text.
  final String description;

  /// Custom icon to display instead of the default.
  final IconData? icon;

  /// Action button to resolve the empty state.
  final Widget? actionButton;

  /// If true, returns a full [AppScaffold]. If false, returns a centered empty state.
  final bool isFullScreen;

  const AppEmptyLayout({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.actionButton,
    this.isFullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget emptyContent = AppEmptyState(
      title: title,
      description: description,
      icon: icon ?? Icons.inbox_outlined,
      actionButton: actionButton,
    );

    if (isFullScreen) {
      return AppScaffold(body: emptyContent);
    }

    return emptyContent;
  }
}
