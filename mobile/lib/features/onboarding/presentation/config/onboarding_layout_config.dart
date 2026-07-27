/// Single source of truth for responsive layout thresholds and sizing constraints
/// across the ForenShield onboarding flow.
class OnboardingLayoutConfig {
  OnboardingLayoutConfig._();

  // ── Desktop / Tablet Viewport Breakpoints ─────────────────────────────────

  /// Minimum width required to trigger desktop wide-layout mode.
  static const double desktopWidthThreshold = 600.0;

  /// Minimum height required to trigger desktop wide-layout mode.
  static const double desktopHeightThreshold = 650.0;

  // ── Page Viewport Proportions ─────────────────────────────────────────────

  /// Height threshold distinguishing compact (short/landscape) from regular viewports.
  static const double compactHeightThreshold = 550.0;

  /// Illustration height ratio on compact viewports (< 550px).
  static const double compactIllustrationRatio = 0.35;

  /// Illustration height ratio on regular viewports (>= 550px).
  static const double regularIllustrationRatio = 0.50;

  // ── Illustration Sizing Bounds ─────────────────────────────────────────────

  /// Absolute minimum height for illustration zone.
  static const double minIllustrationHeight = 120.0;

  /// Maximum height for illustration zone on compact viewports.
  static const double maxCompactIllustrationHeight = 200.0;

  /// Minimum height bound for regular viewports.
  static const double minRegularIllustrationHeight = 180.0;

  /// Absolute maximum height for illustration zone on regular viewports.
  static const double maxRegularIllustrationHeight = 360.0;

  /// Computes dynamic illustration height based on total available constraints height.
  static double computeIllustrationHeight(double totalHeight) {
    if (totalHeight < compactHeightThreshold) {
      return (totalHeight * compactIllustrationRatio).clamp(
        minIllustrationHeight,
        maxCompactIllustrationHeight,
      );
    }
    return (totalHeight * regularIllustrationRatio).clamp(
      minRegularIllustrationHeight,
      maxRegularIllustrationHeight,
    );
  }
}
