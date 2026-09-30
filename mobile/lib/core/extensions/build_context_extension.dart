import 'package:flutter/material.dart';
import '../theme/foren_theme.dart';

/// Context extensions for rapid access to Theme, Media, Navigation, and
/// standardized SnackBar feedback.
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

  // ── SnackBar helpers ───────────────────────────────────────────────────────
  // All variants clear the current snackbar before showing a new one, which
  // prevents stacking when multiple errors arrive quickly.

  /// Shows a **generic** snackbar. Prefer the typed variants below.
  void showSnackBar(String message, {bool isError = false}) {
    final foren = theme.extension<ForenColors>();
    _showSnackBar(
      message,
      backgroundColor: isError
          ? (foren?.critical.t500 ?? Colors.red.shade700)
          : null,
    );
  }

  /// Shows a **red-tinted error** snackbar with a leading warning icon.
  ///
  /// Use for actionable failures (e.g., form submit error, network failure).
  void showErrorSnackBar(String message) {
    final foren = theme.extension<ForenColors>();
    final errorColor = foren?.critical.t500 ?? Colors.red.shade700;
    _showSnackBar(
      message,
      backgroundColor: errorColor,
      leading: Icons.error_outline_rounded,
    );
  }

  /// Shows a **green-tinted success** snackbar with a checkmark icon.
  ///
  /// Use for confirmations (e.g., profile saved, password changed).
  void showSuccessSnackBar(String message) {
    final foren = theme.extension<ForenColors>();
    final successColor = foren?.success.t500 ?? Colors.green.shade700;
    _showSnackBar(
      message,
      backgroundColor: successColor,
      leading: Icons.check_circle_outline_rounded,
    );
  }

  /// Shows a **blue-tinted informational** snackbar with an info icon.
  ///
  /// Use for neutral status updates (e.g., "Loading...", "Preparing export").
  void showInfoSnackBar(String message) {
    final foren = theme.extension<ForenColors>();
    final infoColor = foren?.info.t500 ?? Colors.blue.shade700;
    _showSnackBar(
      message,
      backgroundColor: infoColor,
      leading: Icons.info_outline_rounded,
    );
  }

  void _showSnackBar(
    String message, {
    Color? backgroundColor,
    IconData? leading,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: leading != null
              ? Row(
                  children: [
                    Icon(leading, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              : Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
