import '../../models/component_definition.dart';
import '../../../../core/widgets/app_loading_state.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_success_state.dart';

final List<ComponentDefinition> stateComponents = [
  ComponentDefinition(
    name: 'AppLoadingState',
    category: 'States',
    description: 'A customizable loading state indicator.',
    purpose: 'To inform the user that a process is ongoing.',
    whenToUse: 'During API calls, heavy computations, or data fetching.',
    whenNotToUse: 'For immediate, synchronous actions.',
    keywords: ['loading', 'spinner', 'progress', 'wait'],
    codeExample: '''AppLoadingState(
  title: 'Fetching Data...',
  size: AppLoadingSize.large,
)''',
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'Loading'),
      const ComponentProperty(name: 'description', type: PropertyType.string, defaultValue: 'Please wait...'),
      const ComponentProperty(name: 'size', type: PropertyType.selection, defaultValue: AppLoadingSize.medium, options: AppLoadingSize.values),
      const ComponentProperty(name: 'isDeterminate', type: PropertyType.boolean, defaultValue: false),
    ],
    builder: (context, props) {
      return AppLoadingState(
        title: props['title'] as String,
        description: props['description'] as String,
        size: props['size'] as AppLoadingSize,
        progress: (props['isDeterminate'] as bool) ? 0.65 : null,
      );
    },
  ),
  ComponentDefinition(
    name: 'AppEmptyState',
    category: 'States',
    description: 'A friendly empty state for unpopulated areas.',
    purpose: 'To prevent dead ends when data is missing.',
    whenToUse: 'When a list, search result, or dashboard is completely empty.',
    codeExample: '''AppEmptyState(
  title: 'No results',
  description: 'Try adjusting your filters.',
)''',
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'No Evidence Found'),
      const ComponentProperty(name: 'description', type: PropertyType.string, defaultValue: 'Adjust your search parameters and try again.'),
    ],
    builder: (context, props) {
      return AppEmptyState(
        title: props['title'] as String,
        description: props['description'] as String,
      );
    },
  ),
  ComponentDefinition(
    name: 'AppErrorState',
    category: 'States',
    description: 'A prominent error display with retry capabilities.',
    purpose: 'To gracefully handle and recover from systemic or network failures.',
    whenToUse: 'When an essential process fails unexpectedly.',
    codeExample: '''AppErrorState(
  description: 'Network timeout.',
  onRetry: () => fetch(),
)''',
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'Connection Failed'),
      const ComponentProperty(name: 'description', type: PropertyType.string, defaultValue: 'Could not reach the secure server.'),
    ],
    builder: (context, props) {
      return AppErrorState(
        title: props['title'] as String,
        description: props['description'] as String,
        onRetry: () {},
      );
    },
  ),
  ComponentDefinition(
    name: 'AppSuccessState',
    category: 'States',
    description: 'A celebratory success screen.',
    purpose: 'To provide positive reinforcement after completing a major task.',
    whenToUse: 'After submitting reports, passing modules, or completing investigations.',
    codeExample: '''AppSuccessState(
  title: 'Report Filed',
  description: 'Your findings were uploaded successfully.',
  onContinue: () {},
)''',
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'Investigation Complete'),
      const ComponentProperty(name: 'description', type: PropertyType.string, defaultValue: 'You have successfully closed this case.'),
      const ComponentProperty(name: 'animate', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return AppSuccessState(
        title: props['title'] as String,
        description: props['description'] as String,
        animate: props['animate'] as bool,
        onContinue: () {},
      );
    },
  ),
];
