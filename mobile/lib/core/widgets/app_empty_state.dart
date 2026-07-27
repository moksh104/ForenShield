import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';

/// A reusable empty state widget for situations where no data is available.
class AppEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final Widget? illustration;
  final IconData? icon;
  final Widget? actionButton;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.illustration,
    this.icon = Icons.inbox_outlined,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildVisual(foren),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foren.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionButton != null) ...[
                const SizedBox(height: AppSpacing.xl),
                actionButton!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisual(ForenColors foren) {
    if (illustration != null) {
      return illustration!;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: foren.surfaceRaised1,
      ),
      child: Icon(icon, size: 64, color: foren.textDisabled),
    );
  }
}
