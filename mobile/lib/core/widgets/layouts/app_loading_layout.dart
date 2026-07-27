import 'package:flutter/material.dart';
import '../app_loading.dart';
import 'app_scaffold.dart';

/// A layout used when a screen is in a loading state.
/// Supports both full-screen scaffold replacements or localized loaders.
class AppLoadingLayout extends StatelessWidget {
  /// The message to display under the loading indicator.
  final String? message;

  /// If true, returns a full [AppScaffold] with the loader centered.
  /// If false, returns just the centered loader.
  final bool isFullScreen;

  const AppLoadingLayout({super.key, this.message, this.isFullScreen = true});

  @override
  Widget build(BuildContext context) {
    final Widget loader = Center(child: AppLoading(message: message));

    if (isFullScreen) {
      return AppScaffold(body: loader);
    }

    return loader;
  }
}
