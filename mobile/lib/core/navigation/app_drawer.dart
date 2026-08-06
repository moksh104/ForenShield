import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';
import 'app_navigation_bar.dart';

/// A Material 3 NavigationDrawer for standard mobile hamburger menus.
class AppDrawer extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppNavigationItem> items;

  const AppDrawer({
    super.key,
    this.header,
    this.footer,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        onDestinationSelected(index);
        Navigator.of(context).pop();
      },
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
      children: [
        // ignore: use_null_aware_elements
        if (header != null) header!,
        const SizedBox(height: AppSpacing.md),
        ...items.map((item) {
          final index = items.indexOf(item);
          final isSelected = index == selectedIndex;
          return NavigationDrawerDestination(
            icon: Icon(
              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : foren.textSecondary,
            ),
            label: Text(
              item.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          );
        }),
        if (footer != null) ...[
          const SizedBox(height: AppSpacing.md),
          Divider(color: foren.borderSubtle),
          const SizedBox(height: AppSpacing.sm),
          footer!,
        ],
      ],
    );
  }
}
