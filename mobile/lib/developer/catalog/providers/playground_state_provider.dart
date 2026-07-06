import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/component_definition.dart';

/// Manages the dynamic property map for the currently viewed component in the Live Playground.
class PlaygroundStateNotifier extends StateNotifier<Map<String, dynamic>> {
  PlaygroundStateNotifier() : super({});

  /// Initializes the state map with the default values from the component's property definitions.
  void initialize(List<ComponentProperty> properties) {
    final Map<String, dynamic> initialState = {};
    for (var prop in properties) {
      initialState[prop.name] = prop.defaultValue;
    }
    state = initialState;
  }

  /// Updates a specific property value and triggers a rebuild of the Live Preview.
  void updateProperty(String name, dynamic value) {
    state = {
      ...state,
      name: value,
    };
  }
}

/// Provider exposing the playground state controls isolated by component name.
final playgroundStateProvider = StateNotifierProvider.family<PlaygroundStateNotifier, Map<String, dynamic>, String>((ref, componentName) {
  return PlaygroundStateNotifier();
});
