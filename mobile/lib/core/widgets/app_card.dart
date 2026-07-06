import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// A standard, highly reusable card component following the ForenShield design system.
/// 
/// It acts as the foundational surface for most grouped content.
class AppCard extends StatelessWidget {
  /// The main content of the card.
  final Widget body;

  /// Optional custom header. If provided, overrides [title] and [subtitle].
  final Widget? header;

  /// Optional custom footer, displayed below the body.
  final Widget? footer;

  /// Optional icon displayed at the start of the standard header.
  final IconData? leadingIcon;

  /// Optional action widget (like an IconButton) displayed at the end of the standard header.
  final Widget? trailingAction;

  /// Standard title for the card. Used if [header] is null.
  final String? title;

  /// Standard subtitle for the card. Used if [header] is null.
  final String? subtitle;

  /// The elevation level of the card. Defaults to 1.
  final double elevation;

  /// Whether the card has a subtle outline border. Defaults to true.
  final bool hasBorder;

  /// Internal padding for the card content.
  final EdgeInsetsGeometry padding;

  /// Optional tap handler for the entire card.
  final VoidCallback? onTap;

  /// Border radius override.
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.body,
    this.header,
    this.footer,
    this.leadingIcon,
    this.trailingAction,
    this.title,
    this.subtitle,
    this.elevation = 1,
    this.hasBorder = true,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.borderMd;
    
    Widget cardContent = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header!
          else if (title != null || subtitle != null || leadingIcon != null || trailingAction != null)
            _buildStandardHeader(),
          
          if ((header != null || title != null) && body is! SizedBox) 
            const SizedBox(height: AppSpacing.md),
            
          body,
          
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            footer!,
          ]
        ],
      ),
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: cardContent,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _getSurfaceColor(),
        borderRadius: effectiveRadius,
        border: hasBorder 
            ? Border.all(color: AppColors.outline, width: 1)
            : null,
        boxShadow: _getShadows(),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: cardContent,
      ),
    );
  }

  Widget _buildStandardHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: AppColors.primary, size: 24),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(title!, style: AppTypography.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle!, style: AppTypography.bodySmall),
              ],
            ],
          ),
        ),
        if (trailingAction != null) ...[
          const SizedBox(width: AppSpacing.sm),
          trailingAction!,
        ],
      ],
    );
  }

  Color _getSurfaceColor() {
    if (elevation == 0) return AppColors.surface;
    if (elevation == 1) return AppColors.surfaceVariant;
    return AppColors.surfaceElevated;
  }

  List<BoxShadow>? _getShadows() {
    if (elevation == 0) return AppShadows.none;
    if (elevation == 1) return AppShadows.subtle;
    if (elevation == 2) return AppShadows.small;
    if (elevation == 3) return AppShadows.medium;
    return AppShadows.large;
  }
}
