/// ForenShield Widget Catalog — Dialogs section.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/components/foren_components.dart';
import 'catalog_helpers.dart';

class DialogsSection extends StatelessWidget {
  const DialogsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogSection(
      title: 'Dialogs',
      description: 'Mission Brief, Investigation Summary, Success, Warning (standard & destructive).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogSubsection(
            label: 'Mission Brief Dialog',
            child: CatalogPropRow(children: [
              ForenButton.primary(
                label: 'Open Mission Brief',
                feature: ForenFeature.missionControl,
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ForenMissionBriefDialog(
                    priority: ForenThreatLevel.high,
                    incidentSummary:
                        'A phishing email with malicious attachment was delivered to 14 Finance employees. Three have opened the attachment.',
                    objectives: [
                      'Identify the phishing sender domain and spoofed sender',
                      'Extract and detonate the malicious attachment in a sandbox',
                      'Map affected machines and lateral movement paths',
                    ],
                    rewardXp: 250,
                    onBegin: () {},
                  ),
                ),
              ),
            ]),
          ),
          CatalogSubsection(
            label: 'Investigation Summary Dialog',
            child: CatalogPropRow(children: [
              ForenButton.primary(
                label: 'Open Summary',
                feature: ForenFeature.investigation,
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ForenInvestigationSummaryDialog(
                    caseTitle: 'CASE-2024-0041 — Lateral Movement via SMB',
                    findings: [
                      'Compromised service account: svc_backup',
                      'Pass-the-Hash used for lateral movement to DC-01',
                      'C2 callback to 185.220.101.47 via DNS tunnel',
                    ],
                    accuracy: 0.86,
                    xpEarned: 430,
                    onContinue: () {},
                  ),
                ),
              ),
            ]),
          ),
          CatalogSubsection(
            label: 'Success Dialog',
            child: CatalogPropRow(children: [
              ForenButton.primary(
                label: 'Open Success',
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ForenSuccessDialog(
                    title: 'Mission Complete!',
                    message: 'You successfully identified all indicators of compromise in the Finance phishing case.',
                    buttonLabel: 'Claim Reward',
                    onDismiss: () {},
                  ),
                ),
              ),
            ]),
          ),
          CatalogSubsection(
            label: 'Warning Dialog — standard',
            child: CatalogPropRow(children: [
              ForenButton.ghost(
                label: 'Open Warning',
                feature: ForenFeature.simulation,
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ForenWarningDialog(
                    title: 'Abandon Mission?',
                    message: 'Your progress will be saved, but your current run will end. You can resume this mission from the beginning.',
                    confirmLabel: 'Abandon',
                    onConfirm: () {},
                  ),
                ),
              ),
            ]),
          ),
          CatalogSubsection(
            label: 'Warning Dialog — destructive',
            child: CatalogPropRow(children: [
              ForenButton.danger(
                label: 'Open Destructive Warning',
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ForenWarningDialog(
                    title: 'Delete Case File?',
                    message: 'This will permanently delete CASE-2024-0041 and all associated evidence. This action cannot be undone.',
                    confirmLabel: 'Delete Case',
                    isDestructive: true,
                    onConfirm: () {},
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
