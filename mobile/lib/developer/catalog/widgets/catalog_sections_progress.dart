/// ForenShield Widget Catalog — Progress section.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/components/foren_components.dart';
import 'catalog_helpers.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogSection(
      title: 'Progress',
      description:
          'XP Progress, Mission Progress, Learning Progress, Circular Score.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CatalogSubsection(
            label: 'XP Progress',
            child: SizedBox(
              width: 320,
              child: ForenXpProgress(currentXp: 1840, nextLevelXp: 2500),
            ),
          ),
          const CatalogSubsection(
            label: 'Mission Progress',
            child: SizedBox(
              width: 320,
              child: ForenMissionProgress(completedSteps: 3, totalSteps: 5),
            ),
          ),
          const CatalogSubsection(
            label: 'Learning Progress',
            child: SizedBox(
              width: 320,
              child: ForenLearningProgress(percent: 0.62),
            ),
          ),
          const CatalogSubsection(
            label:
                'Circular Score — semantic coloring (≥75% green, ≥50% warning, <50% critical)',
            child: CatalogPropRow(
              spacing: ForenSpace.xl,
              children: [
                ForenCircularScore(percent: 0.88, label: 'Security Posture'),
                ForenCircularScore(percent: 0.61, label: 'Detection Rate'),
                ForenCircularScore(percent: 0.34, label: 'Coverage'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
