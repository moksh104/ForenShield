import 'package:flutter/material.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// An animated row of dot indicators reflecting the current onboarding page.
class OnboardingDotIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  final void Function(int index)? onDotTapped;

  const OnboardingDotIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step ${currentPage + 1} of $totalPages',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalPages, (index) => _buildDot(context, index)),
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final isActive = index == currentPage;

    final dot = AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.emphasized,
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor
            : foren.borderSubtle,
        borderRadius: AppRadius.borderPill,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );

    if (onDotTapped == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: dot,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: GestureDetector(
        onTap: () => onDotTapped!(index),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: dot,
        ),
      ),
    );
  }
}
