import 'package:flutter/material.dart';

/// The stability status of the component within the design system.
enum ComponentStatus { stable, experimental, deprecated, internal }

/// The data type of a playground property control.
enum PropertyType { boolean, string, number, selection }

/// Defines an interactive property for the Live Playground.
class ComponentProperty {
  /// The unique name of the property.
  final String name;

  /// The data type determining which control is rendered (e.g., Switch vs Dropdown).
  final PropertyType type;

  /// The initial default value of the property.
  final dynamic defaultValue;

  /// A list of available options, required if [type] is [PropertyType.selection].
  final List<dynamic>? options;

  const ComponentProperty({
    required this.name,
    required this.type,
    required this.defaultValue,
    this.options,
  });
}

/// The single source of truth defining a component in the catalog.
class ComponentDefinition {
  /// The human-readable name of the component (e.g., 'AppButton').
  final String name;

  /// The grouping category (e.g., 'Buttons', 'Forms').
  final String category;

  /// A brief summary of what the component is.
  final String description;

  /// Searchable keywords to help developers find this component.
  final List<String> keywords;

  /// Detailed explanation of the component's role in the system.
  final String purpose;

  /// Guidelines on the appropriate use cases.
  final String whenToUse;

  /// Guidelines on when to avoid using this component.
  final String whenNotToUse;

  /// Names of other components that are similar or commonly used together.
  final List<String> relatedComponents;

  /// Accessibility considerations, ARIA roles, or semantic rules.
  final String accessibilityNotes;

  /// Rendering performance notes or layout constraints.
  final String performanceNotes;

  /// The current lifecycle status of the component.
  final ComponentStatus status;

  /// The chain of internal ForenShield dependencies required by this component.
  final List<String> dependencies;

  /// A snippet of Dart code showing how to instantiate the component.
  final String codeExample;

  /// The interactive properties available in the Live Playground.
  final List<ComponentProperty> properties;

  /// The rendering function for the Live Playground.
  /// Receives the active [activeProperties] state to render variations.
  final Widget Function(BuildContext context, Map<String, dynamic> activeProperties) builder;

  const ComponentDefinition({
    required this.name,
    required this.category,
    required this.description,
    this.keywords = const [],
    required this.purpose,
    required this.whenToUse,
    this.whenNotToUse = 'No specific restrictions.',
    this.relatedComponents = const [],
    this.accessibilityNotes = 'None provided.',
    this.performanceNotes = 'No known performance issues.',
    this.status = ComponentStatus.stable,
    this.dependencies = const [],
    required this.codeExample,
    this.properties = const [],
    required this.builder,
  });
}
