/// ForenShield Design System v1.0 — Typography (Phase 2 UI Optimization)
///
/// Typography architecture:
/// Uses 'Outfit' for headings (Display, Headline, Title)
/// Uses 'Inter' for body text, subtitles, labels, and captions.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String forenFontFamily = 'Inter';
const String forenDisplayFontFamily = 'Outfit';

class ForenTypography {
  ForenTypography._();

  /// Build a Material 3 TextTheme for the given base text color.
  /// Headings -> Outfit
  /// Body text -> Inter
  static TextTheme buildTextTheme(Color baseColor) {
    TextStyle headingStyle(
      double size,
      double height,
      FontWeight weight, {
      double letterSpacing = 0.0,
    }) {
      return GoogleFonts.outfit(
        color: baseColor,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
      );
    }

    TextStyle bodyStyle(double size, double height, FontWeight weight) {
      return GoogleFonts.inter(
        color: baseColor,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
      );
    }

    return TextTheme(
      // Display (Headings -> Outfit)
      displayLarge: headingStyle(40, 48, FontWeight.w700, letterSpacing: -0.5),
      displayMedium: headingStyle(34, 40, FontWeight.w700, letterSpacing: -0.5),
      displaySmall: headingStyle(28, 34, FontWeight.w700, letterSpacing: -0.3),

      // Headline (Headings -> Outfit)
      headlineLarge: headingStyle(24, 32, FontWeight.w700),
      headlineMedium: headingStyle(20, 28, FontWeight.w600),
      headlineSmall: headingStyle(18, 24, FontWeight.w600),

      // Title (Headings -> Outfit)
      titleLarge: headingStyle(18, 24, FontWeight.w600),
      titleMedium: headingStyle(16, 22, FontWeight.w600),
      titleSmall: headingStyle(14, 20, FontWeight.w600),

      // Body (Body text -> Inter)
      bodyLarge: bodyStyle(16, 24, FontWeight.w400),
      bodyMedium: bodyStyle(14, 20, FontWeight.w400),
      bodySmall: bodyStyle(12, 16, FontWeight.w400),

      // Label & Caption (Body text -> Inter)
      labelLarge: bodyStyle(
        13,
        18,
        FontWeight.w600,
      ).copyWith(letterSpacing: 0.2),
      labelMedium: bodyStyle(
        12,
        16,
        FontWeight.w600,
      ).copyWith(letterSpacing: 0.2),
      labelSmall: bodyStyle(
        11,
        14,
        FontWeight.w600,
      ).copyWith(letterSpacing: 0.2),
    );
  }
}

/// Core typography tokens and backwards-compatibility wrapper for AppTypography.
abstract class AppTypography {
  static const String fontFamily = forenFontFamily;
  static const String displayFontFamily = forenDisplayFontFamily;

  // Font Weights
  static const FontWeight wLight = FontWeight.w300;
  static const FontWeight wRegular = FontWeight.w400;
  static const FontWeight wMedium = FontWeight.w500;
  static const FontWeight wSemiBold = FontWeight.w600;
  static const FontWeight wBold = FontWeight.w700;

  // Display Styles (Outfit -> Headings)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40,
    fontWeight: wBold,
    fontFamily: forenDisplayFontFamily,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 34,
    fontWeight: wBold,
    fontFamily: forenDisplayFontFamily,
  );
  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: wBold,
    fontFamily: forenDisplayFontFamily,
  );

  // Headline Styles (Outfit -> Headings)
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: wBold,
    fontFamily: forenDisplayFontFamily,
  );
  static const TextStyle headlineLarge = headline;
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: wSemiBold,
    fontFamily: forenDisplayFontFamily,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: wSemiBold,
    fontFamily: forenDisplayFontFamily,
  );

  // Title Styles (Outfit -> Headings)
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: wSemiBold,
    fontFamily: forenDisplayFontFamily,
  );
  static const TextStyle titleLarge = title;
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: wSemiBold,
    fontFamily: forenDisplayFontFamily,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: wSemiBold,
    fontFamily: forenDisplayFontFamily,
  );

  // Subtitle Styles (Inter -> Body Text)
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: wMedium,
    fontFamily: fontFamily,
  );

  // Body Styles (Inter -> Body Text)
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

  // Label Styles (Inter -> Body Text)
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

  // Caption Styles (Inter -> Body Text)
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: wRegular,
    fontFamily: fontFamily,
  );

  /// Generates Material 3 TextTheme integrated with Google Fonts Outfit (headings) & Inter (body).
  static TextTheme getTextTheme({required Color textColor}) =>
      ForenTypography.buildTextTheme(textColor);
}
