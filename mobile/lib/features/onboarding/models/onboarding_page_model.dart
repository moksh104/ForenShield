import 'package:equatable/equatable.dart';

/// Immutable data model representing a single onboarding page.
///
/// All onboarding content lives in the model layer — pages are
/// constructed at runtime from a list of [OnboardingPageModel] instances,
/// keeping screen widgets fully stateless and data-driven.
class OnboardingPageModel extends Equatable {
  /// Short uppercase label displayed above the headline.
  /// e.g. "CYBER ACADEMY"
  final String categoryLabel;

  /// Primary headline — short and punchy (≤ 3 words per line).
  final String headline;

  /// First supporting line. Keep ≤ 8 words.
  final String supportingLine1;

  /// Second supporting line. Keep ≤ 8 words. Empty string = single-line mode.
  final String supportingLine2;

  /// Primary CTA label on this page.
  final String primaryCta;

  /// Secondary CTA label. Empty string = no secondary CTA rendered.
  final String secondaryCta;

  /// Whether to render a skip button on this page.
  final bool showSkip;

  /// Accent color for the [categoryLabel] and decorative elements on this page.
  /// Each screen has a distinct accent to reinforce the emotional progression.
  final int accentColorValue;

  const OnboardingPageModel({
    required this.categoryLabel,
    required this.headline,
    required this.supportingLine1,
    this.supportingLine2 = '',
    required this.primaryCta,
    this.secondaryCta = '',
    this.showSkip = true,
    required this.accentColorValue,
  });

  @override
  List<Object?> get props => [
    categoryLabel,
    headline,
    supportingLine1,
    supportingLine2,
    primaryCta,
    secondaryCta,
    showSkip,
    accentColorValue,
  ];
}
