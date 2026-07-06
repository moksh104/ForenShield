import 'package:flutter/material.dart';
import '../../models/component_definition.dart';
import '../../../../core/widgets/chips/app_chip.dart';
import '../../../../core/widgets/chips/status_chip.dart';
import '../../../../core/widgets/chips/difficulty_chip.dart';
import '../../../../core/widgets/chips/category_chip.dart';
import '../../../../core/widgets/chips/xp_chip.dart';
import '../../../../core/theme/app_colors.dart';

final List<ComponentDefinition> chipComponents = [
  ComponentDefinition(
    name: 'AppChip',
    category: 'Chips',
    description: 'A versatile, interactive chip component.',
    purpose: 'To represent inputs, attributes, or actions in a compact format.',
    whenToUse: 'For tag selection, filtering, or discrete dynamic actions.',
    keywords: ['tag', 'pill', 'filter', 'choice'],
    codeExample: '''AppChip(
  label: 'Network',
  type: AppChipType.filled,
  isSelected: true,
)''',
    properties: [
      const ComponentProperty(name: 'label', type: PropertyType.string, defaultValue: 'ForenShield'),
      const ComponentProperty(name: 'type', type: PropertyType.selection, defaultValue: AppChipType.filled, options: AppChipType.values),
      const ComponentProperty(name: 'isSelected', type: PropertyType.boolean, defaultValue: false),
      const ComponentProperty(name: 'isRemovable', type: PropertyType.boolean, defaultValue: false),
      const ComponentProperty(name: 'isEnabled', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return AppChip(
        label: props['label'] as String,
        type: props['type'] as AppChipType,
        isSelected: props['isSelected'] as bool,
        isRemovable: props['isRemovable'] as bool,
        isEnabled: props['isEnabled'] as bool,
        onTap: () {},
        onRemoved: (props['isRemovable'] as bool) ? () {} : null,
      );
    },
  ),
  ComponentDefinition(
    name: 'StatusChip',
    category: 'Chips',
    description: 'Semantic chip mapping to exact system states.',
    purpose: 'To standardize the visual representation of status fields.',
    whenToUse: 'On lists or cards indicating the lifecycle state of a case or module.',
    codeExample: '''StatusChip(state: StatusChipState.active)''',
    properties: [
      const ComponentProperty(name: 'state', type: PropertyType.selection, defaultValue: StatusChipState.active, options: StatusChipState.values),
    ],
    builder: (context, props) {
      return StatusChip(state: props['state'] as StatusChipState);
    },
  ),
  ComponentDefinition(
    name: 'DifficultyChip',
    category: 'Chips',
    description: 'Visual indicator of difficulty levels.',
    purpose: 'To help users assess the challenge level of a module at a glance.',
    whenToUse: 'In curriculum listings or module headers.',
    codeExample: '''DifficultyChip(level: DifficultyLevel.advanced)''',
    properties: [
      const ComponentProperty(name: 'level', type: PropertyType.selection, defaultValue: DifficultyLevel.beginner, options: DifficultyLevel.values),
    ],
    builder: (context, props) {
      return DifficultyChip(level: props['level'] as DifficultyLevel);
    },
  ),
  ComponentDefinition(
    name: 'CategoryChip',
    category: 'Chips',
    description: 'A customizable tag for dynamic metadata.',
    purpose: 'To tag content where the exact categories might be dynamic.',
    whenToUse: 'When rendering a list of tags provided by the backend.',
    codeExample: '''CategoryChip(label: 'Malware', color: AppColors.error)''',
    properties: [
      const ComponentProperty(name: 'label', type: PropertyType.string, defaultValue: 'Cryptography'),
    ],
    builder: (context, props) {
      return CategoryChip(
        label: props['label'] as String,
        color: AppColors.primary,
        icon: Icons.code,
      );
    },
  ),
  ComponentDefinition(
    name: 'XPChip',
    category: 'Chips',
    description: 'An animated gamification chip for Experience Points.',
    purpose: 'To visually reward the user and display current currency/XP.',
    whenToUse: 'In app bars or reward summaries.',
    codeExample: '''XPChip(xp: 1500)''',
    properties: [
      const ComponentProperty(name: 'xp', type: PropertyType.number, defaultValue: 1250.0),
      const ComponentProperty(name: 'animate', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return XPChip(
        xp: (props['xp'] as num).toInt(),
        animate: props['animate'] as bool,
      );
    },
  ),
];
