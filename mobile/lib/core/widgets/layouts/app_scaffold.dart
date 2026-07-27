import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/design_tokens.dart';

/// The foundational Material Scaffold wrapper for ForenShield.
/// Ensures consistent background colors, safe area behavior, and system overlay styles.
class AppScaffold extends StatelessWidget {
  /// The primary content of the scaffold.
  final Widget body;

  /// Optional standard app bar.
  final PreferredSizeWidget? appBar;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Location for the FAB.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional background color override. Defaults to [AppColors.background].
  final Color? backgroundColor;

  /// Whether to wrap the body in a [SafeArea]. Defaults to true.
  final bool safeArea;

  /// Whether the body should resize when the keyboard appears. Defaults to true.
  final bool resizeToAvoidBottomInset;

  /// The system UI overlay style (status bar color, etc).
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.safeArea = true,
    this.resizeToAvoidBottomInset = true,
    this.systemUiOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (safeArea) {
      content = SafeArea(child: content);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle ?? SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: backgroundColor ?? AppColors.background,
        appBar: appBar,
        body: content,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
