import 'package:flutter/material.dart';
import 'foren_theme.dart';

export 'app_tokens.dart';
export 'app_typography.dart';
export 'foren_theme.dart';

/// Legacy alias class delegating to [ForenTheme] for backwards compatibility.
abstract class AppTheme {
  /// Dark theme — primary experience (SOC control-room feel).
  static ThemeData get darkTheme => ForenTheme.dark;

  /// Light theme — full parity secondary experience.
  static ThemeData get lightTheme => ForenTheme.light;
}
