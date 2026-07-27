import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';
import 'app_card.dart';

/// A structural component used to group related widgets into a distinct section.
class SectionCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? actionButton;
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
      header: _buildHeader(context),
      body: child,
    );
  }

  Widget? _buildHeader(BuildContext context) {
    if (title == null && subtitle == null && actionButton == null) {
      return null;
    }

    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

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
                  Text(title!, style: theme.textTheme.headlineSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foren.textSecondary,
                    ),
                  ),
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
