import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/component_definition.dart';
import '../providers/filtered_components_provider.dart';
import '../providers/playground_state_provider.dart';
import '../widgets/navigation/catalog_sidebar.dart';
import '../widgets/navigation/catalog_search_bar.dart';
import '../widgets/preview/live_preview_card.dart';
import '../widgets/controls/playground_controls.dart';
import '../widgets/inspector/component_inspector.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// The root page for the Developer Component Catalog.
class CatalogMainPage extends ConsumerWidget {
  const CatalogMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CatalogSidebar(),
      appBar: AppBar(
        title: const Text('Developer Catalog'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) 
                const CatalogSidebar(),
              
              if (isDesktop)
                const VerticalDivider(width: 1, thickness: 1),

              Expanded(
                child: Column(
                  children: [
                    const CatalogSearchBar(),
                    const Expanded(child: _CatalogContentList()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CatalogContentList extends ConsumerWidget {
  const _CatalogContentList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final components = ref.watch(filteredComponentsProvider);

    if (components.isEmpty) {
      return const Center(
        child: Text('No components match your search criteria.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: components.length,
      itemBuilder: (context, index) {
        return _ComponentDetailSection(component: components[index]);
      },
    );
  }
}

class _ComponentDetailSection extends ConsumerStatefulWidget {
  final ComponentDefinition component;

  const _ComponentDetailSection({required this.component});

  @override
  ConsumerState<_ComponentDetailSection> createState() => _ComponentDetailSectionState();
}

class _ComponentDetailSectionState extends ConsumerState<_ComponentDetailSection> {
  @override
  void initState() {
    super.initState();
    // Initialize default playground state for this specific component
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playgroundStateProvider(widget.component.name).notifier).initialize(widget.component.properties);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComponentInspector(component: widget.component),
          const SizedBox(height: AppSpacing.lg),
          LivePreviewCard(component: widget.component),
          if (widget.component.properties.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            PlaygroundControls(component: widget.component),
          ],
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.outline),
        ],
      ),
    );
  }
}
