import 'package:flutter/material.dart';
import '../../models/component_definition.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/theme/app_colors.dart';

final List<ComponentDefinition> cardComponents = [
  ComponentDefinition(
    name: 'AppCard',
    category: 'Cards',
    description: 'A standard, highly reusable surface container.',
    purpose: 'Acts as the foundational surface for most grouped content in ForenShield.',
    whenToUse: 'To group related information visually.',
    whenNotToUse: 'When the content is extremely simple and does not require separation from the background.',
    relatedComponents: ['SectionCard', 'GlassCard'],
    keywords: ['surface', 'container', 'box', 'elevation', 'shadow'],
    codeExample: '''AppCard(
  title: 'Card Title',
  subtitle: 'Optional subtitle',
  body: Text('Main card content goes here.'),
)''',
    dependencies: ['AppColors', 'AppTypography', 'AppSpacing', 'AppRadius', 'AppShadows'],
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'Evidence Details'),
      const ComponentProperty(name: 'subtitle', type: PropertyType.string, defaultValue: 'Collected on Oct 24, 2026'),
      const ComponentProperty(name: 'elevation', type: PropertyType.number, defaultValue: 1.0),
      const ComponentProperty(name: 'hasBorder', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return AppCard(
        title: props['title'] as String,
        subtitle: props['subtitle'] as String,
        elevation: (props['elevation'] as num).toDouble(),
        hasBorder: props['hasBorder'] as bool,
        body: const Text('This is the main body content of the card. It scales automatically based on its children.'),
      );
    },
  ),
  ComponentDefinition(
    name: 'SectionCard',
    category: 'Cards',
    description: 'A large grouping container with standardized headers.',
    purpose: 'To delineate high-level page sections.',
    whenToUse: 'For major sections on a screen containing multiple smaller elements or cards.',
    whenNotToUse: 'For small, atomic pieces of data.',
    codeExample: '''SectionCard(
  title: 'Recent Activity',
  child: ActivityListWidget(),
)''',
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'Investigation Progress'),
      const ComponentProperty(name: 'subtitle', type: PropertyType.string, defaultValue: 'View all your recent module scores.'),
    ],
    builder: (context, props) {
      return SectionCard(
        title: props['title'] as String,
        subtitle: props['subtitle'] as String,
        child: const Text('Section content goes here...'),
      );
    },
  ),
  ComponentDefinition(
    name: 'GlassCard',
    category: 'Cards',
    description: 'A premium frosted glass surface effect.',
    purpose: 'Used for overlapping UI elements to maintain context of what is behind them.',
    whenToUse: 'For premium overlays, floating action panels, or complex backgrounds.',
    whenNotToUse: 'As a generic list item container due to performance overhead.',
    performanceNotes: 'Extensive use of BackdropFilter can cause GPU frame drops on lower-end devices. Use sparingly.',
    codeExample: '''GlassCard(
  blur: 10.0,
  opacity: 0.2,
  child: Text('Frosted Content'),
)''',
    properties: [
      const ComponentProperty(name: 'blur', type: PropertyType.number, defaultValue: 10.0),
      const ComponentProperty(name: 'opacity', type: PropertyType.number, defaultValue: 0.2),
      const ComponentProperty(name: 'hasBorder', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      // Wrapped in a colored container so the glass effect is visible in the playground
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: GlassCard(
          blur: (props['blur'] as num).toDouble(),
          opacity: (props['opacity'] as num).toDouble(),
          hasBorder: props['hasBorder'] as bool,
          child: const Text('Frosted Glass Content', style: TextStyle(color: Colors.white)),
        ),
      );
    },
  ),
  ComponentDefinition(
    name: 'InfoCard',
    category: 'Cards',
    description: 'A contextual messaging card for alerts and statuses.',
    purpose: 'To immediately draw user attention to specific system states.',
    whenToUse: 'For success messages, warnings, critical errors, or important tips.',
    whenNotToUse: 'For standard data display.',
    codeExample: '''InfoCard(
  type: InfoCardType.warning,
  icon: Icons.warning_amber_rounded,
  title: 'Connection Lost',
  description: 'Operating in offline mode.',
)''',
    properties: [
      const ComponentProperty(name: 'type', type: PropertyType.selection, defaultValue: InfoCardType.info, options: InfoCardType.values),
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'System Notice'),
      const ComponentProperty(name: 'description', type: PropertyType.string, defaultValue: 'Your profile has been updated successfully.'),
    ],
    builder: (context, props) {
      final type = props['type'] as InfoCardType;
      IconData icon = Icons.info_outline;
      if (type == InfoCardType.success) icon = Icons.check_circle_outline;
      if (type == InfoCardType.warning) icon = Icons.warning_amber_rounded;
      if (type == InfoCardType.error) icon = Icons.error_outline;

      return InfoCard(
        type: type,
        icon: icon,
        title: props['title'] as String,
        description: props['description'] as String,
      );
    },
  ),
];
