import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import 'app_scaffold.dart';
import 'app_refresh_layout.dart';

/// The standard full-screen layout component for most app screens.
/// Integrates scrolling, padding, refresh logic, and safe areas automatically.
class AppPage extends StatelessWidget {
  /// The main scrollable (or static) content.
  final Widget body;

  /// Optional standard App Bar.
  final PreferredSizeWidget? appBar;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// General padding applied to the body content. Defaults to [AppSpacing.md].
  final EdgeInsetsGeometry padding;

  /// If true, wraps the body in a [SingleChildScrollView]. Defaults to true.
  final bool scrollable;

  /// If true, wraps the content in a [SafeArea]. Defaults to true.
  final bool safeArea;

  /// If provided, wraps the content in a pull-to-refresh layout.
  final Future<void> Function()? onRefresh;

  const AppPage({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.scrollable = true,
    this.safeArea = true,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: body);

    if (scrollable) {
      content = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: content,
      );
    }

    if (onRefresh != null) {
      content = AppRefreshLayout(onRefresh: onRefresh!, child: content);
    }

    return AppScaffold(
      appBar: appBar,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      safeArea: safeArea,
    );
  }
}
