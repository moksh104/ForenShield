/// ForenShield Design System v1.0 — Typography
///
/// Single typography family: Inter. One scale. Integrated with Flutter's
/// Material 3 TextTheme and GoogleFonts.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String forenFontFamily = 'Inter';

class ForenTypography {
  ForenTypography._();

  /// Build a Material 3 TextTheme for the given base text color.
  static TextTheme buildTextTheme(Color baseColor) {
    TextStyle s(double size, double height, FontWeight weight) {
      return GoogleFonts.inter(
        color: baseColor,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
      );
    }

    return TextTheme(
      // Display
      displayLarge: s(40, 48, FontWeight.w700),
      displayMedium: s(34, 40, FontWeight.w700),
      displaySmall: s(28, 34, FontWeight.w700),

      // Headline / Heading
      headlineLarge: s(24, 32, FontWeight.w700),
      headlineMedium: s(20, 28, FontWeight.w600),
      headlineSmall: s(18, 24, FontWeight.w600),

      // Title
      titleLarge: s(18, 24, FontWeight.w600),
      titleMedium: s(16, 22, FontWeight.w600),
      titleSmall: s(14, 20, FontWeight.w600),

      // Body
      bodyLarge: s(16, 24, FontWeight.w400),
      bodyMedium: s(14, 20, FontWeight.w400),
      bodySmall: s(12, 16, FontWeight.w400),

      // Label & Caption
      labelLarge: s(13, 18, FontWeight.w600),
      labelMedium: s(12, 16, FontWeight.w600),
      labelSmall: s(11, 14, FontWeight.w600),
    );
  }
}

/// Core typography tokens and backwards-compatibility wrapper for AppTypography.
abstract class AppTypography {
  static const String fontFamily = forenFontFamily;

  // Font Weights
  static const FontWeight wLight = FontWeight.w300;
  static const FontWeight wRegular = FontWeight.w400;
  static const FontWeight wMedium = FontWeight.w500;
  static const FontWeight wSemiBold = FontWeight.w600;
  static const FontWeight wBold = FontWeight.w700;

  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40,
    fontWeight: wBold,
    fontFamily: fontFamily,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 34,
    fontWeight: wBold,
    fontFamily: fontFamily,
  );
  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: wBold,
    fontFamily: fontFamily,
  );

  // Headline Styles
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: wBold,
    fontFamily: fontFamily,
  );
  static const TextStyle headlineLarge = headline;
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );

  // Title Styles
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );
  static const TextStyle titleLarge = title;
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );

  // Subtitle Styles
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: wMedium,
    fontFamily: fontFamily,
  );

  // Body Styles
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: wRegular,
    fontFamily: fontFamily,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: wRegular,
    fontFamily: fontFamily,
  );
  static const TextStyle bodyMedium = body;
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: wRegular,
    fontFamily: fontFamily,
  );

  // Label Styles
  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );
  static const TextStyle labelLarge = label;
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: wSemiBold,
    fontFamily: fontFamily,
  );

  // Caption Styles
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: wRegular,
    fontFamily: fontFamily,
  );

  /// Generates Material 3 TextTheme integrated with Google Fonts Inter.
  static TextTheme getTextTheme({required Color textColor}) =>
      ForenTypography.buildTextTheme(textColor);
}
