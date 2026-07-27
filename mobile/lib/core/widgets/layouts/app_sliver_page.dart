import 'package:flutter/material.dart';
import 'app_scaffold.dart';
import 'app_refresh_layout.dart';

/// A layout component specifically built for CustomScrollView and Slivers.
/// Ideal for screens requiring collapsing app bars or complex list interactions.
class AppSliverPage extends StatelessWidget {
  /// The list of sliver widgets to display in the custom scroll view.
  final List<Widget> slivers;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Optional pull-to-refresh callback.
  final Future<void> Function()? onRefresh;

  /// Whether to wrap the content in a [SafeArea]. Defaults to true.
  final bool safeArea;

  const AppSliverPage({
    super.key,
    required this.slivers,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.onRefresh,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: slivers,
    );

    if (onRefresh != null) {
      content = AppRefreshLayout(onRefresh: onRefresh!, child: content);
    }

    return AppScaffold(
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      safeArea: safeArea,
    );
  }
}
