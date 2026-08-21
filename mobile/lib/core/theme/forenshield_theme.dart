/// ForenShield Design System — ThemeData & Component Theme Configuration
library;

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'foren_theme.dart';

export 'app_tokens.dart';
export 'foren_theme.dart';

/// Primary ForenShield Material 3 theme configuration class.
abstract class ForenShieldTheme {
  /// Dark theme — secondary experience.
  static ThemeData get darkTheme => ForenTheme.dark;

  /// Light theme — full parity secondary experience.
  static ThemeData get lightTheme => ForenTheme.light;

  /// Configures Material 3 [ColorScheme] for dark mode.
  static ColorScheme get darkColorScheme => ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    tertiary: AppColors.accent,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    outline: AppColors.outline,
    outlineVariant: AppColors.borderSubtle,
  );

  /// Configures Material 3 [ColorScheme] for light mode.
  static ColorScheme get lightColorScheme => ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.primaryDark,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryDark,
    onSecondary: Colors.white,
    tertiary: AppColors.accent,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    outline: AppColors.borderDefault,
    outlineVariant: AppColors.borderSubtle,
  );

  /// Configures Material 3 [TextTheme].
  static TextTheme getTextTheme(Color textColor) =>
      AppTypography.getTextTheme(textColor: textColor);

  /// Configures [CardThemeData].
  static CardThemeData getCardTheme(ColorScheme colorScheme) => CardThemeData(
    color: colorScheme.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
    margin: EdgeInsets.zero,
  );

  /// Configures [DialogThemeData].
  static DialogThemeData getDialogTheme(ColorScheme colorScheme) =>
      DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
        elevation: 8,
      );

  /// Configures [InputDecorationTheme].
  ///
  /// Derives fill and border colors from the given [colorScheme] so that
  /// both light and dark modes render correctly.
  static InputDecorationTheme getInputDecorationTheme(ColorScheme colorScheme) {
    // Theme-aware fill: use surfaceContainerHighest for M3 parity,
    // falling back to a subtle surface tint.
    final fillColor = colorScheme.brightness == Brightness.dark
        ? AppColors.surfaceHighlight
        : AppColors.lightSurface;
    final borderColor = colorScheme.brightness == Brightness.dark
        ? AppColors.borderDefault
        : AppColors.lightBorderDefault;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: AppSpacing.buttonPadding,
      border: OutlineInputBorder(
        borderRadius: AppRadius.buttonRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.buttonRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.buttonRadius,
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.buttonRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textDisabled,
      ),
    );
  }

  /// Configures [NavigationBarThemeData].
  static NavigationBarThemeData getNavigationBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) => NavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
    elevation: 0,
    labelTextStyle: WidgetStateProperty.all(textTheme.labelSmall),
  );

  /// Configures [AppBarThemeData].
  static AppBarTheme getAppBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) => AppBarTheme(
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: textTheme.headlineSmall,
  );
}
