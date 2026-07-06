import 'package:flutter/material.dart';
import '../../models/component_definition.dart';
import '../../../../core/widgets/badges/rank_badge.dart';
import '../../../../core/widgets/progress/linear_progress_card.dart';
import '../../../../core/widgets/progress/circular_progress_card.dart';
import '../../../../core/widgets/progress/lesson_progress_bar.dart';
import '../../../../core/widgets/progress/xp_progress_bar.dart';

final List<ComponentDefinition> badgeAndProgressComponents = [
  ComponentDefinition(
    name: 'RankBadge',
    category: 'Badges',
    description: 'A tiered visual badge representing user rank.',
    purpose: 'Gamification reward to indicate progression mastery.',
    whenToUse: 'In the user profile or leaderboards.',
    whenNotToUse: 'Inline within dense text.',
    keywords: ['rank', 'tier', 'medal', 'award'],
    codeExample: '''RankBadge(
  rank: RankTier.gold,
  size: 48,
)''',
    properties: [
      const ComponentProperty(name: 'rank', type: PropertyType.selection, defaultValue: RankTier.bronze, options: RankTier.values),
      const ComponentProperty(name: 'size', type: PropertyType.number, defaultValue: 48.0),
      const ComponentProperty(name: 'showLabel', type: PropertyType.boolean, defaultValue: true),
    ],
    builder: (context, props) {
      return RankBadge(
        rank: props['rank'] as RankTier,
        size: (props['size'] as num).toDouble(),
        showLabel: props['showLabel'] as bool,
      );
    },
  ),
  ComponentDefinition(
    name: 'LinearProgressCard',
    category: 'Progress',
    description: 'Card with an animated linear progress bar.',
    purpose: 'To track completion of linear processes or collections.',
    whenToUse: 'When showing course completion or long-running tasks.',
    codeExample: '''LinearProgressCard(
  title: 'Upload Progress',
  progress: 0.45,
)''',
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'Module Completion'),
      const ComponentProperty(name: 'progress', type: PropertyType.number, defaultValue: 0.65),
    ],
    builder: (context, props) {
      return LinearProgressCard(
        title: props['title'] as String,
        subtitle: 'Based on total points',
        progressText: '${((props['progress'] as num) * 100).toInt()}%',
        progress: (props['progress'] as num).toDouble(),
      );
    },
  ),
  ComponentDefinition(
    name: 'CircularProgressCard',
    category: 'Progress',
    description: 'Card with an animated circular progress ring.',
    purpose: 'To highlight a key metric or percentage centrally.',
    whenToUse: 'For accuracy scores, health metrics, or dashboard KPIs.',
    codeExample: '''CircularProgressCard(
  title: 'Accuracy',
  progress: 0.95,
  centerWidget: Text('95%'),
)''',
    properties: [
      const ComponentProperty(name: 'title', type: PropertyType.string, defaultValue: 'Case Accuracy'),
      const ComponentProperty(name: 'progress', type: PropertyType.number, defaultValue: 0.88),
    ],
    builder: (context, props) {
      final p = (props['progress'] as num).toDouble();
      return CircularProgressCard(
        title: props['title'] as String,
        progress: p,
        centerWidget: Text('${(p * 100).toInt()}%'),
      );
    },
  ),
  ComponentDefinition(
    name: 'LessonProgressBar',
    category: 'Progress',
    description: 'Segmented progress bar for multi-step processes.',
    purpose: 'To clearly demarcate discrete steps in a flow.',
    whenToUse: 'During onboarding, checkout flows, or sequential lessons.',
    codeExample: '''LessonProgressBar(
  totalSteps: 5,
  completedSteps: 2,
)''',
    properties: [
      const ComponentProperty(name: 'totalSteps', type: PropertyType.number, defaultValue: 5.0),
      const ComponentProperty(name: 'completedSteps', type: PropertyType.number, defaultValue: 2.0),
    ],
    builder: (context, props) {
      return LessonProgressBar(
        totalSteps: (props['totalSteps'] as num).toInt(),
        completedSteps: (props['completedSteps'] as num).toInt(),
      );
    },
  ),
  ComponentDefinition(
    name: 'XPProgressBar',
    category: 'Progress',
    description: 'Gamified level-up bar with gradient shine.',
    purpose: 'To motivate users to reach the next tier.',
    whenToUse: 'In gamified summaries or dashboards.',
    codeExample: '''XPProgressBar(
  currentXP: 1250,
  targetXP: 2000,
  currentLevel: 4,
)''',
    properties: [
      const ComponentProperty(name: 'currentXP', type: PropertyType.number, defaultValue: 1500.0),
    ],
    builder: (context, props) {
      return XPProgressBar(
        currentXP: (props['currentXP'] as num).toInt(),
        targetXP: 2500,
        currentLevel: 5,
      );
    },
  ),
];
