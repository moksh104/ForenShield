import 'package:flutter/material.dart';
import '../theme/foren_theme.dart';

/// Represents a single destination in any ForenShield navigation component.
class AppNavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;

  const AppNavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
  });
}

/// A Material 3 NavigationBar tailored for mobile viewports.
class AppNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppNavigationItem> items;

  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: foren.surfaceRaised1,
      indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: items.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon, color: foren.textSecondary),
          selectedIcon: Icon(
            item.activeIcon ?? item.icon,
            color: theme.colorScheme.primary,
          ),
          label: item.label,
        );
      }).toList(),
    );
  }
}
