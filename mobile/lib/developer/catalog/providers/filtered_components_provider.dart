import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../registry/catalog_registry.dart';
import '../models/component_definition.dart';
import 'catalog_search_provider.dart';
import 'catalog_filter_provider.dart';

/// Provides a dynamically filtered list of components based on active search and filter state.
final filteredComponentsProvider = Provider<List<ComponentDefinition>>((ref) {
  final query = ref.watch(catalogSearchQueryProvider).toLowerCase().trim();
  final category = ref.watch(catalogCategoryFilterProvider);
  final allComponents = CatalogRegistry.components;

  return allComponents.where((comp) {
    // 1. Check category filter
    if (category != null && comp.category != category) {
      return false;
    }
    
    // 2. Check search query
    if (query.isEmpty) return true;

    // Deep search across multiple fields
    final matchesName = comp.name.toLowerCase().contains(query);
    final matchesCategory = comp.category.toLowerCase().contains(query);
    final matchesDesc = comp.description.toLowerCase().contains(query);
    final matchesKeywords = comp.keywords.any((k) => k.toLowerCase().contains(query));
    final matchesAccessibility = comp.accessibilityNotes.toLowerCase().contains(query);
    
    // Check property names in the playground
    final matchesProperty = comp.properties.any((p) => p.name.toLowerCase().contains(query));

    return matchesName || 
           matchesCategory || 
           matchesDesc || 
           matchesKeywords || 
           matchesAccessibility || 
           matchesProperty;
  }).toList();
});
