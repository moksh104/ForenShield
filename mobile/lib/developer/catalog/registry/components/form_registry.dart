import '../../models/component_definition.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/password_field.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/multiline_field.dart';

final List<ComponentDefinition> formComponents = [
  ComponentDefinition(
    name: 'AppTextField',
    category: 'Forms',
    description: 'The highly configurable base text input component.',
    purpose: 'To collect standard text data from the user.',
    whenToUse: 'For usernames, emails, short descriptions, and general inputs.',
    whenNotToUse: 'For passwords (use PasswordField) or very long text (use MultilineField).',
    keywords: ['input', 'text', 'form', 'field', 'textbox'],
    codeExample: '''AppTextField(
  label: 'Email Address',
  hint: 'enter@example.com',
  prefixIcon: Icon(Icons.email),
)''',
    properties: [
      const ComponentProperty(name: 'label', type: PropertyType.string, defaultValue: 'Username'),
      const ComponentProperty(name: 'hint', type: PropertyType.string, defaultValue: 'Enter your username'),
      const ComponentProperty(name: 'helperText', type: PropertyType.string, defaultValue: 'Must be unique.'),
      const ComponentProperty(name: 'enabled', type: PropertyType.boolean, defaultValue: true),
      const ComponentProperty(name: 'isSuccess', type: PropertyType.boolean, defaultValue: false),
      const ComponentProperty(name: 'isLoading', type: PropertyType.boolean, defaultValue: false),
      const ComponentProperty(name: 'showClearButton', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return AppTextField(
        label: props['label'] as String,
        hint: props['hint'] as String,
        helperText: props['helperText'] as String,
        enabled: props['enabled'] as bool,
        isSuccess: props['isSuccess'] as bool,
        isLoading: props['isLoading'] as bool,
        showClearButton: props['showClearButton'] as bool,
      );
    },
  ),
  ComponentDefinition(
    name: 'PasswordField',
    category: 'Forms',
    description: 'A secure text input managing obscure state and strength indicators.',
    purpose: 'To securely collect and validate user passwords.',
    whenToUse: 'During login, registration, or sensitive configuration changes.',
    codeExample: '''PasswordField(
  showStrengthIndicator: true,
  strength: 0.75,
)''',
    properties: [
      const ComponentProperty(name: 'label', type: PropertyType.string, defaultValue: 'Password'),
      const ComponentProperty(name: 'showStrengthIndicator', type: PropertyType.boolean, defaultValue: true),
      const ComponentProperty(name: 'strength', type: PropertyType.number, defaultValue: 0.4),
      const ComponentProperty(name: 'enabled', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return PasswordField(
        label: props['label'] as String,
        showStrengthIndicator: props['showStrengthIndicator'] as bool,
        strength: (props['strength'] as num).toDouble(),
        enabled: props['enabled'] as bool,
        requirements: const ['Minimum 8 chars', '1 Uppercase', '1 Number'],
      );
    },
  ),
  ComponentDefinition(
    name: 'SearchField',
    category: 'Forms',
    description: 'A specialized text field optimized for debounced search operations.',
    purpose: 'To allow rapid querying of lists and data tables.',
    whenToUse: 'In app bars or at the top of long lists.',
    codeExample: '''SearchField(
  hint: 'Search evidence...',
  isLoading: isSearching,
  onChanged: (q) => debounceSearch(q),
)''',
    properties: [
      const ComponentProperty(name: 'hint', type: PropertyType.string, defaultValue: 'Search cases...'),
      const ComponentProperty(name: 'isLoading', type: PropertyType.boolean, defaultValue: false),
      const ComponentProperty(name: 'enabled', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return SearchField(
        hint: props['hint'] as String,
        isLoading: props['isLoading'] as bool,
        enabled: props['enabled'] as bool,
      );
    },
  ),
  ComponentDefinition(
    name: 'MultilineField',
    category: 'Forms',
    description: 'Auto-growing text field for long-form content.',
    purpose: 'To collect extensive textual data like case notes or reports.',
    whenToUse: 'When the expected input spans multiple sentences or paragraphs.',
    codeExample: '''MultilineField(
  label: 'Case Notes',
  minLines: 3,
  maxLines: 10,
  maxLength: 1000,
)''',
    properties: [
      const ComponentProperty(name: 'label', type: PropertyType.string, defaultValue: 'Observations'),
      const ComponentProperty(name: 'minLines', type: PropertyType.number, defaultValue: 3.0),
      const ComponentProperty(name: 'maxLength', type: PropertyType.number, defaultValue: 250.0),
    ],
    builder: (context, props) {
      return MultilineField(
        label: props['label'] as String,
        minLines: (props['minLines'] as num).toInt(),
        maxLength: (props['maxLength'] as num).toInt(),
      );
    },
  ),
];
