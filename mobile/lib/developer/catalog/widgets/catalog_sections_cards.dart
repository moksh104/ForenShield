/// ForenShield Widget Catalog — Cards section.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/components/foren_components.dart';
import 'catalog_helpers.dart';

class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogSection(
      title: 'Cards',
      description: 'All eight card types, built on one shared ForenCard shell.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogSubsection(
            label: 'Mission Card',
            child: ForenMissionCard(
              title: 'Finance Dept. Phishing Report',
              priority: ForenThreatLevel.high,
              description:
                  'A phishing email has been reported inside the Finance Department. Analyze headers and identify IOCs.',
              rewardXp: 250,
              onTap: () {},
            ),
          ),
          CatalogSubsection(
            label: 'Investigation Card',
            child: ForenInvestigationCard(
              caseId: 'CASE-2024-0041',
              title: 'Lateral Movement via SMB',
              difficulty: ForenDifficulty.advanced,
              evidenceCount: 12,
              status: ForenStatus.inProgress,
              onTap: () {},
            ),
          ),
          CatalogSubsection(
            label: 'Course Card',
            child: ForenCourseCard(
              category: 'Network Forensics',
              title: 'Packet Capture Analysis',
              lessonCount: 8,
              progress: 0.62,
              onTap: () {},
            ),
          ),
          CatalogSubsection(
            label: 'Simulation Card',
            child: ForenSimulationCard(
              title: 'Spear Phishing Campaign',
              scenarioType: 'Social Engineering',
              difficulty: ForenDifficulty.intermediate,
              onTap: () {},
            ),
          ),
          CatalogSubsection(
            label: 'Alert Card — all threat levels',
            child: Column(
              children: [
                ForenAlertCard(
                  severity: ForenThreatLevel.critical,
                  message: 'C2 beacon detected on workstation WS-024 — exfiltration risk.',
                  timeAgo: '2 m ago',
                  onTap: () {},
                ),
                const SizedBox(height: ForenSpace.sm),
                ForenAlertCard(
                  severity: ForenThreatLevel.high,
                  message: 'Suspicious PowerShell invocation on AD server.',
                  timeAgo: '15 m ago',
                  onTap: () {},
                ),
                const SizedBox(height: ForenSpace.sm),
                ForenAlertCard(
                  severity: ForenThreatLevel.medium,
                  message: 'Failed login attempts from external IP.',
                  timeAgo: '1 h ago',
                  onTap: () {},
                ),
                const SizedBox(height: ForenSpace.sm),
                ForenAlertCard(
                  severity: ForenThreatLevel.low,
                  message: 'USB device inserted on air-gapped workstation.',
                  timeAgo: '2 h ago',
                  onTap: () {},
                ),
              ],
            ),
          ),
          CatalogSubsection(
            label: 'Evidence Card',
            child: Column(
              children: [
                ForenEvidenceCard(
                  filename: 'finance_email_headers.eml',
                  type: ForenEvidenceType.email,
                  meta: '12 KB',
                  onTap: () {},
                ),
                const SizedBox(height: ForenSpace.sm),
                ForenEvidenceCard(
                  filename: 'capture_2024-01-15.pcap',
                  type: ForenEvidenceType.pcap,
                  meta: '4.7 MB',
                  onTap: () {},
                ),
                const SizedBox(height: ForenSpace.sm),
                ForenEvidenceCard(
                  filename: 'memory_dump_ws024.dmp',
                  type: ForenEvidenceType.memoryDump,
                  meta: '128 MB',
                  onTap: () {},
                ),
              ],
            ),
          ),
          CatalogSubsection(
            label: 'Statistics Card',
            child: Wrap(
              spacing: ForenSpace.md,
              runSpacing: ForenSpace.md,
              children: [
                SizedBox(
                  width: 200,
                  child: ForenStatisticsCard(
                    label: 'Active Threats',
                    value: '14',
                    icon: Icons.warning_amber_outlined,
                    trend: '+4 since yesterday',
                    trendPositive: false,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ForenStatisticsCard(
                    label: 'Cases Solved',
                    value: '128',
                    icon: Icons.check_circle_outline,
                    trend: '+7 this week',
                    trendPositive: true,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ForenStatisticsCard(
                    label: 'XP Earned',
                    value: '9,450',
                    icon: Icons.bolt_outlined,
                  ),
                ),
              ],
            ),
          ),
          CatalogSubsection(
            label: 'Achievement Card — locked & unlocked',
            child: CatalogPropRow(children: [
              SizedBox(
                width: 150,
                child: ForenAchievementCard(
                  title: 'Packet Detective',
                  icon: Icons.radar,
                  unlocked: true,
                  rewardXp: 500,
                  onTap: () {},
                ),
              ),
              SizedBox(
                width: 150,
                child: ForenAchievementCard(
                  title: 'Memory Master',
                  icon: Icons.memory,
                  unlocked: false,
                  rewardXp: 750,
                  onTap: () {},
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
