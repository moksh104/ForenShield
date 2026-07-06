import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'app_card.dart';

/// A structural component used to group related widgets into a distinct section.
/// 
/// Built on top of [AppCard], it provides a standardized title/action area
/// suitable for high-level page sections.
class SectionCard extends StatelessWidget {
  /// The main content of the section.
  final Widget child;

  /// The title of the section.
  final String? title;

  /// An optional subtitle or description for the section.
  final String? subtitle;

  /// An optional action button (like "View All" or "Edit") displayed in the top right.
  final Widget? actionButton;

  /// Override for internal padding.
  final EdgeInsetsGeometry padding;

  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.actionButton,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: 0,
      hasBorder: false,
      padding: padding,
      header: _buildHeader(),
      body: child,
    );
  }

  Widget? _buildHeader() {
    if (title == null && subtitle == null && actionButton == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(title!, style: AppTypography.headlineSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle!, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
          if (actionButton != null) ...[
            const SizedBox(width: AppSpacing.md),
            actionButton!,
          ],
        ],
      ),
    );
  }
}
