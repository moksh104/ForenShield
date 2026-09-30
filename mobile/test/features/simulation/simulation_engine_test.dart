import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/features/simulation/data/models/simulation_action_result_model.dart';
import 'package:forenshield/features/simulation/domain/entities/simulation_attempt.dart';
import 'package:forenshield/features/simulation/domain/entities/simulation_node.dart';
import 'package:forenshield/features/simulation/domain/entities/simulation_scenario.dart';

void main() {
  group('Simulation Node and Action Parsing', () {
    test('parses simulation action with safety and score delta', () {
      final json = {
        'id': 'act_inspect_headers',
        'label': 'Inspect Raw SMTP Headers',
        'description': 'Analyze RFC 5322 header trail and SPF alignment.',
        'action_type': 'investigate',
        'safety': 'safe',
        'score_delta': 10,
        'consequence_summary': 'SPF inspection confirms sender domain spoofing.',
        'unlocks_evidence_ids': ['ev_102_1'],
        'next_node_id': 'phish_node_header_analysis',
      };

      final action = SimulationAction.fromJson(json);

      expect(action.id, 'act_inspect_headers');
      expect(action.safety, SimulationActionSafety.safe);
      expect(action.scoreDelta, 10);
      expect(action.unlocksEvidenceIds, ['ev_102_1']);
      expect(action.nextNodeId, 'phish_node_header_analysis');
    });

    test('parses simulation node with narrative and available choices', () {
      final json = {
        'id': 'phish_node_start',
        'type': 'incident_start',
        'title': 'Urgent Invoice Phishing Alert',
        'narrative':
            'Assistant Controller received an urgent payment alert claiming AWS infrastructure deletion.',
        'context_data': {
          'Sender': 'billing-support@aws-cloud-verify.net',
          'Originating IP': '194.26.29.112',
        },
        'available_actions': [
          {
            'id': 'act_inspect_headers',
            'label': 'Inspect Headers',
            'description': 'Check SPF and DKIM records.',
            'action_type': 'investigate',
            'safety': 'safe',
            'score_delta': 10,
            'consequence_summary': 'Spoofing detected.',
            'unlocks_evidence_ids': ['ev_102_1'],
            'next_node_id': 'phish_node_header_analysis',
          },
        ],
        'evidence_unlocked_on_enter': [],
        'is_terminal': false,
        'is_success': false,
      };

      final node = SimulationNode.fromJson(json);

      expect(node.id, 'phish_node_start');
      expect(node.type, SimulationNodeType.incidentStart);
      expect(node.contextData['Originating IP'], '194.26.29.112');
      expect(node.availableActions.length, 1);
      expect(node.availableActions.first.id, 'act_inspect_headers');
      expect(node.isTerminal, isFalse);
    });
  });

  group('Simulation Attempt and Tracking', () {
    test('parses active attempt state and preserves action audit trail', () {
      final json = {
        'id': 'att_test_123',
        'user_id': 1,
        'scenario_id': 'phishing-incident',
        'current_node_id': 'phish_node_header_analysis',
        'status': 'in_progress',
        'score': 100,
        'xp_earned': 0,
        'selected_actions': [
          {
            'node_id': 'phish_node_start',
            'node_title': 'Urgent Alert',
            'action_id': 'act_inspect_headers',
            'action_label': 'Inspect Headers',
            'action_type': 'investigate',
            'safety': 'safe',
            'score_delta': 10,
            'consequence': 'Spoofing detected.',
            'evidence_unlocked': ['ev_102_1'],
            'timestamp': '2026-09-30T12:00:00Z',
          },
        ],
        'discovered_evidence_ids': ['ev_102_1'],
        'state_flags': {'headers_analyzed': true},
        'started_at': '2026-09-30T12:00:00Z',
        'last_activity_at': '2026-09-30T12:01:00Z',
      };

      final attempt = SimulationAttempt.fromJson(json);

      expect(attempt.id, 'att_test_123');
      expect(attempt.status, SimulationAttemptStatus.inProgress);
      expect(attempt.currentNodeId, 'phish_node_header_analysis');
      expect(attempt.score, 100);
      expect(attempt.selectedActions.length, 1);
      expect(attempt.selectedActions.first.actionId, 'act_inspect_headers');
      expect(attempt.discoveredEvidenceIds, ['ev_102_1']);
      expect(attempt.stateFlags['headers_analyzed'], isTrue);
    });
  });

  group('Investigation Handoff and Action Evaluation', () {
    test(
      'parses terminal action result with investigation handoff and score',
      () {
        final json = {
          'success': true,
          'attempt': {
            'id': 'att_test_123',
            'user_id': 1,
            'scenario_id': 'phishing-incident',
            'current_node_id': 'phish_node_success',
            'status': 'completed',
            'score': 100,
            'xp_earned': 250,
            'selected_actions': [],
            'discovered_evidence_ids': ['ev_102_1', 'ev_102_2'],
            'state_flags': {'full_containment': true},
            'started_at': '2026-09-30T12:00:00Z',
            'last_activity_at': '2026-09-30T12:05:00Z',
          },
          'action_taken': {
            'node_id': 'phish_node_containment',
            'node_title': 'Perimeter Containment',
            'action_id': 'act_perimeter_block_and_purge',
            'action_label': 'Firewall Block + Email Purge',
            'action_type': 'remediate',
            'safety': 'safe',
            'score_delta': 20,
            'consequence': 'All threat vectors neutralized.',
            'evidence_unlocked': [],
            'timestamp': '2026-09-30T12:05:00Z',
          },
          'consequence': 'Threat completely eliminated tenant-wide.',
          'score_delta': 20,
          'unlocked_evidence': [],
          'next_node': {
            'id': 'phish_node_success',
            'type': 'resolution',
            'title': 'Threat Neutralized',
            'narrative': 'Exemplary incident containment.',
            'is_terminal': true,
            'is_success': true,
          },
          'is_finished': true,
          'is_success': true,
          'xp_awarded': 250,
          'investigation_handoff': {
            'originating_simulation_id': 'phishing-incident',
            'originating_simulation_title': 'Executive Phishing',
            'case_id': 'case_102',
            'case_title': 'Phishing Email Investigation',
            'discovered_evidence_ids': ['ev_102_1', 'ev_102_2'],
            'final_score': 100,
            'status': 'completed',
            'summary': 'Exemplary incident containment.',
            'completed_at': '2026-09-30T12:05:00Z',
          },
        };

        final result = SimulationActionResult.fromJson(json);

        expect(result.isFinished, isTrue);
        expect(result.isSuccess, isTrue);
        expect(result.xpAwarded, 250);
        expect(result.investigationHandoff, isNotNull);
        expect(result.investigationHandoff!.caseId, 'case_102');
        expect(result.investigationHandoff!.finalScore, 100);
        expect(result.investigationHandoff!.discoveredEvidenceIds, [
          'ev_102_1',
          'ev_102_2',
        ]);
      },
    );
  });

  group('Simulation Scenario Enhanced Model', () {
    test('parses scenario with passingScore and activeAttempt resume data', () {
      final json = {
        'id': 'phishing-incident',
        'title': 'Executive Phishing & Credential Harvest',
        'description': 'A spear-phishing campaign targets corporate finance.',
        'category': 'webSec',
        'difficulty': 'medium',
        'estimatedMinutes': 12,
        'xpReward': 250,
        'passingScore': 70,
        'entryNodeId': 'phish_node_start',
        'investigationCaseId': 'case_102',
        'initialTerminalHistory': [],
        'objectives': [],
        'isCompleted': false,
        'activeAttempt': {
          'attemptId': 'att_active_999',
          'currentNodeId': 'phish_node_header_analysis',
          'score': 90,
          'status': 'in_progress',
        },
      };

      final scenario = SimulationScenario.fromJson(json);

      expect(scenario.id, 'phishing-incident');
      expect(scenario.passingScore, 70);
      expect(scenario.entryNodeId, 'phish_node_start');
      expect(scenario.investigationCaseId, 'case_102');
      expect(scenario.activeAttempt, isNotNull);
      expect(scenario.activeAttempt!.attemptId, 'att_active_999');
      expect(scenario.activeAttempt!.score, 90);
    });
  });
}
