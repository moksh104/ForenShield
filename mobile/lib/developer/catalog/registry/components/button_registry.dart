import '../../models/component_definition.dart';
import '../../../../core/widgets/app_button.dart';

final List<ComponentDefinition> buttonComponents = [
  ComponentDefinition(
    name: 'AppButton',
    category: 'Buttons',
    description: 'A highly customizable, reusable button component.',
    purpose: 'Provides a standard interaction surface for primary, secondary, tertiary, and destructive actions.',
    whenToUse: 'Whenever a user needs to trigger an action, submit a form, or navigate.',
    whenNotToUse: 'Do not use for subtle inline text links.',
    relatedComponents: ['IconButton'],
    keywords: ['click', 'press', 'action', 'cta', 'button', 'primary', 'secondary'],
    codeExample: '''AppButton(
  text: 'Continue',
  type: AppButtonType.primary,
  onPressed: () {},
)''',
    dependencies: ['AppColors', 'AppTypography', 'AppSpacing', 'AppRadius', 'AppMotion'],
    properties: [
      const ComponentProperty(name: 'text', type: PropertyType.string, defaultValue: 'Button Text'),
      const ComponentProperty(name: 'type', type: PropertyType.selection, defaultValue: AppButtonType.primary, options: AppButtonType.values),
      const ComponentProperty(name: 'isLoading', type: PropertyType.boolean, defaultValue: false),
      const ComponentProperty(name: 'fullWidth', type: PropertyType.boolean, defaultValue: false),
      const ComponentProperty(name: 'isDisabled', type: PropertyType.boolean, defaultValue: false),
    ],
    builder: (context, props) {
      return AppButton(
        text: props['text'] as String,
        type: props['type'] as AppButtonType,
        isLoading: props['isLoading'] as bool,
        fullWidth: props['fullWidth'] as bool,
        onPressed: (props['isDisabled'] as bool) ? null : () {},
      );
    },
  ),
];
