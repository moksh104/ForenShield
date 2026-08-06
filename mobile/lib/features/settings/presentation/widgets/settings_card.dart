import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Reusable M3 styled settings container card.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SettingsCard({
    super.key,
    required this.children,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.md),
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: foren.borderDefault,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
