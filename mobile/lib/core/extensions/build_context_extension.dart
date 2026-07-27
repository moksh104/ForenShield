import 'package:flutter/material.dart';

/// Context extensions for rapid access to Theme, Media, and Navigation capabilities.
extension BuildContextExtension on BuildContext {
  /// The current theme data.
  ThemeData get theme => Theme.of(this);

  /// The current text theme.
  TextTheme get textTheme => theme.textTheme;

  /// The current color scheme.
  ColorScheme get colors => theme.colorScheme;

  /// The current media query data.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// The current screen width.
  double get screenWidth => mediaQuery.size.width;

  /// The current screen height.
  double get screenHeight => mediaQuery.size.height;

  /// Indicates whether the keyboard is currently open.
  bool get isKeyboardOpen => mediaQuery.viewInsets.bottom > 0;

  /// Safely pops the current navigation context if possible.
  void safePop() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  /// Clears current snackbars and displays a new one.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade700 : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
