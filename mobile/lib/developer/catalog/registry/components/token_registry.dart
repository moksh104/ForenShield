import 'package:flutter/material.dart';
import '../../models/component_definition.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';

final List<ComponentDefinition> tokenComponents = [
  ComponentDefinition(
    name: 'Typography Tokens',
    category: 'Typography',
    description: 'The standardized typography scale for ForenShield.',
    purpose: 'To maintain consistent text hierarchy across the app.',
    whenToUse: 'Whenever rendering text. Avoid hardcoding font sizes.',
    codeExample: '''Text('Headline', style: AppTypography.headlineLarge)''',
    builder: (context, props) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Display Large', style: AppTypography.displayLarge),
          Text('Display Medium', style: AppTypography.displayMedium),
          Text('Headline Large', style: AppTypography.headlineLarge),
          Text('Title Large', style: AppTypography.titleLarge),
          Text('Body Large', style: AppTypography.bodyLarge),
          Text('Label Large', style: AppTypography.labelLarge),
        ],
      );
    },
  ),
  ComponentDefinition(
    name: 'Color Palette',
    category: 'Colors',
    description: 'The core semantic color palette.',
    purpose: 'To ensure brand alignment and accessible contrast.',
    whenToUse: 'When applying colors to custom painted elements or containers.',
    codeExample: '''Container(color: AppColors.primary)''',
    builder: (context, props) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          _ColorBox(color: AppColors.primary, label: 'Primary'),
          _ColorBox(color: AppColors.secondary, label: 'Secondary'),
          _ColorBox(color: AppColors.success, label: 'Success'),
          _ColorBox(color: AppColors.error, label: 'Error'),
          _ColorBox(color: AppColors.warning, label: 'Warning'),
          _ColorBox(color: AppColors.info, label: 'Info'),
          _ColorBox(color: AppColors.background, label: 'Background'),
          _ColorBox(color: AppColors.surface, label: 'Surface'),
        ],
      );
    },
  ),
  ComponentDefinition(
    name: 'Spacing Scale',
    category: 'Spacing',
    description: '8-point grid spacing constants.',
    purpose: 'To maintain vertical and horizontal rhythm.',
    whenToUse: 'In Padding, Margins, and SizedBoxes.',
    codeExample: '''Padding(padding: EdgeInsets.all(AppSpacing.md))''',
    builder: (context, props) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SpacingBox(size: AppSpacing.xxs, label: 'XXS'),
          _SpacingBox(size: AppSpacing.xs, label: 'XS'),
          _SpacingBox(size: AppSpacing.sm, label: 'SM'),
          _SpacingBox(size: AppSpacing.md, label: 'MD'),
          _SpacingBox(size: AppSpacing.lg, label: 'LG'),
          _SpacingBox(size: AppSpacing.xl, label: 'XL'),
          _SpacingBox(size: AppSpacing.xxl, label: 'XXL'),
        ],
      );
    },
  ),
  ComponentDefinition(
    name: 'Shadows & Elevation',
    category: 'Shadows',
    description: 'Standardized depth indicators.',
    purpose: 'To establish spatial hierarchy and layering.',
    whenToUse: 'On cards, floating buttons, and dialogs.',
    codeExample: '''BoxDecoration(boxShadow: AppShadows.medium)''',
    builder: (context, props) {
      return Wrap(
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        children: [
          _ShadowBox(shadows: AppShadows.subtle, label: 'Subtle'),
          _ShadowBox(shadows: AppShadows.small, label: 'Small'),
          _ShadowBox(shadows: AppShadows.medium, label: 'Medium'),
          _ShadowBox(shadows: AppShadows.large, label: 'Large'),
        ],
      );
    },
  ),
];

class _ColorBox extends StatelessWidget {
  final Color color;
  final String label;
  const _ColorBox({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: color, borderRadius: AppRadius.borderMd),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _SpacingBox extends StatelessWidget {
  final double size;
  final String label;
  const _SpacingBox({required this.size, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(label, style: AppTypography.labelSmall)),
          Container(
            height: 24,
            width: size,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('\${size.toInt()}px', style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

class _ShadowBox extends StatelessWidget {
  final List<BoxShadow> shadows;
  final String label;
  const _ShadowBox({required this.shadows, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderMd,
        boxShadow: shadows,
      ),
      alignment: Alignment.center,
      child: Text(label, style: AppTypography.labelMedium),
    );
  }
}
