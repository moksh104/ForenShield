import '../models/component_definition.dart';
import 'components/button_registry.dart';
import 'components/card_registry.dart';
import 'components/form_registry.dart';
import 'components/state_registry.dart';
import 'components/chip_registry.dart';
import 'components/badge_progress_registry.dart';
import 'components/token_registry.dart';

/// Centralized data registry containing every component in the ForenShield catalog.
/// 
/// Future components are added here; the UI automatically indexes and renders them.
class CatalogRegistry {
  CatalogRegistry._();

  /// The master list of all components.
  static final List<ComponentDefinition> components = [
    ...buttonComponents,
    ...cardComponents,
    ...formComponents,
    ...stateComponents,
    ...chipComponents,
    ...badgeAndProgressComponents,
    ...tokenComponents,
  ];
}
