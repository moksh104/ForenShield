import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/foren_theme.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({required this.label, this.onTap});
}

class AppBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final Widget? separator;

  const AppBreadcrumb({super.key, required this.items, this.separator});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    final effectiveSeparator =
        separator ??
        Icon(
          Icons.chevron_right,
          size: 16,
          color: foren.textDisabled,
        );

    final List<Widget> children = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      final textStyle = theme.textTheme.labelMedium?.copyWith(
        color: isLast ? theme.colorScheme.onSurface : foren.textSecondary,
        fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
      );

      Widget child = Text(item.label, style: textStyle);

      if (item.onTap != null && !isLast) {
        child = InkWell(
          onTap: item.onTap,
          borderRadius: AppRadius.borderRadiusSm,
          focusColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          hoverColor: theme.colorScheme.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            child: child,
          ),
        );
      } else {
        child = Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: child,
        );
      }

      children.add(child);

      if (!isLast) {
        children.add(effectiveSeparator);
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      children: children,
    );
  }
}
