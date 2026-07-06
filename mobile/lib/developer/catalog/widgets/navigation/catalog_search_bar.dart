import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/catalog_search_provider.dart';
import '../../../../../core/widgets/search_field.dart';
import '../../../../../core/theme/app_spacing.dart';

/// A sticky search bar for deep querying the catalog.
class CatalogSearchBar extends ConsumerWidget {
  const CatalogSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: SearchField(
        hint: 'Search components, keywords, or properties...',
        onChanged: (query) {
          ref.read(catalogSearchQueryProvider.notifier).state = query;
        },
      ),
    );
  }
}
