import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/catalog_filter_provider.dart';
import '../../registry/catalog_registry.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Renders the category filter list. Used as a NavigationRail on Desktop and Drawer on Mobile.
class CatalogSidebar extends ConsumerWidget {
  const CatalogSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final activeCategory = ref.watch(catalogCategoryFilterProvider);
    final categories =
        CatalogRegistry.components.map((c) => c.category).toSet().toList()
          ..sort();

    return SizedBox(
      width: 250,
      child: Material(
        color: theme.colorScheme.surface,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(Icons.developer_mode, color: primaryColor),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Catalog', style: theme.textTheme.titleMedium),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'All Components',
                style: activeCategory == null
                    ? theme.textTheme.labelLarge?.copyWith(color: primaryColor)
                    : theme.textTheme.labelLarge,
              ),
              selected: activeCategory == null,
              selectedTileColor: primaryColor.withValues(alpha: 0.1),
              onTap: () {
                ref.read(catalogCategoryFilterProvider.notifier).state = null;
                if (Scaffold.of(context).isDrawerOpen) {
                  Navigator.pop(context);
                }
              },
            ),
            ...categories.map((cat) {
              final isSelected = activeCategory == cat;
              return ListTile(
                title: Text(
                  cat,
                  style: isSelected
                      ? theme.textTheme.labelLarge?.copyWith(
                          color: primaryColor,
                        )
                      : theme.textTheme.labelLarge,
                ),
                selected: isSelected,
                selectedTileColor: primaryColor.withValues(alpha: 0.1),
                onTap: () {
                  ref.read(catalogCategoryFilterProvider.notifier).state = cat;
                  if (Scaffold.of(context).isDrawerOpen) {
                    Navigator.pop(context);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
