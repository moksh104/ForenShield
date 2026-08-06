/// ForenShield Widget Catalog — Badges & Chips section.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/components/foren_components.dart';
import 'catalog_helpers.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogSection(
      title: 'Badges & Chips',
      description:
          'Threat Badge, Difficulty Badge, Status Chip, XP Chip, Notification Badge.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CatalogSubsection(
            label: 'Threat Badge — all levels',
            child: CatalogPropRow(
              children: [
                ForenThreatBadge(level: ForenThreatLevel.critical),
                ForenThreatBadge(level: ForenThreatLevel.high),
                ForenThreatBadge(level: ForenThreatLevel.medium),
                ForenThreatBadge(level: ForenThreatLevel.low),
                ForenThreatBadge(level: ForenThreatLevel.info),
              ],
            ),
          ),
          const CatalogSubsection(
            label: 'Difficulty Badge — all levels',
            child: CatalogPropRow(
              children: [
                ForenDifficultyBadge(level: ForenDifficulty.beginner),
                ForenDifficultyBadge(level: ForenDifficulty.intermediate),
                ForenDifficultyBadge(level: ForenDifficulty.advanced),
                ForenDifficultyBadge(level: ForenDifficulty.expert),
              ],
            ),
          ),
          const CatalogSubsection(
            label: 'Status Chip — all states',
            child: CatalogPropRow(
              children: [
                ForenStatusChip(status: ForenStatus.active),
                ForenStatusChip(status: ForenStatus.inProgress),
                ForenStatusChip(status: ForenStatus.completed),
                ForenStatusChip(status: ForenStatus.locked),
              ],
            ),
          ),
          const CatalogSubsection(
            label: 'XP Chip',
            child: CatalogPropRow(
              children: [
                ForenXpChip(amount: 250),
                ForenXpChip(amount: 1000, showPlus: false),
              ],
            ),
          ),
          CatalogSubsection(
            label: 'Notification Badge',
            child: CatalogPropRow(
              children: [
                ForenNotificationBadge(
                  count: 3,
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: ForenIconSize.hero,
                  ),
                ),
                ForenNotificationBadge(
                  count: 128,
                  child: const Icon(
                    Icons.mail_outline,
                    size: ForenIconSize.hero,
                  ),
                ),
                ForenNotificationBadge(
                  count: 0,
                  child: const Icon(
                    Icons.shield_outlined,
                    size: ForenIconSize.hero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
