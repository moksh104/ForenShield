import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/features/reports/models/report_case.dart';

void main() {
  group('Phase 5 Incident Report Models Test', () {
    test('parses full database-backed report case correctly', () {
      final json = {
        'id': 'rep_case_101_1',
        'case_number': '#FSC-0101',
        'case_id': 'case_101',
        'scenario_id': 'account-takeover',
        'attempt_id': 'att_test_123',
        'title': 'Suspicious Account Login Incident Report',
        'category': 'Identity & Access',
        'severity': 'Critical',
        'status': 'FINALIZED',
        'generated_at': '2026-09-30 08:00 UTC',
        'analyst': 'Senior SOC Analyst',
        'summary':
            'Forensic analysis confirmed brute-force credential stuffing and unauthorized MFA fatigue.',
        'score': 95,
        'xp_earned': 350,
        'findings': [
          'Compromised IP address: 198.51.100.22',
          'Token exfiltration via PowerShell script execution',
        ],
        'remediation_actions': [
          'Enforce strict FIDO2 security keys.',
          'Revoke all OAuth tokens.',
        ],
        'artifacts': [
          'auth_audit_log.json',
          'memory_dump.raw',
        ],
        'timeline': [
          {
            'id': 'tl_01',
            'title': 'Initial Brute Force Alert',
            'description': '300 failed attempts within 2 minutes.',
            'timestamp': '2026-09-30 02:14:00',
            'category': 'Access Anomaly',
            'severity': 'Critical',
          }
        ],
        'evidence': [
          {
            'id': 'ev_101_1',
            'title': 'Authentication Audit Log',
            'type': 'logfile',
            'content': 'Failed login from 198.51.100.22',
            'timestamp': '2026-09-30 02:15:00',
            'metadata': {'ip': '198.51.100.22', 'port': 443},
          }
        ],
        'analyst_actions': [
          {
            'action_id': 'act_isolate_host',
            'action_label': 'Isolate Host from VLAN',
            'score_delta': 20,
            'consequence': 'Lateral movement severed successfully.',
          }
        ],
        'verdict': {
          'summary': 'Credential stuffing attack identified.',
          'root_cause': 'Brute-force password spray',
          'explanation': 'Unrestricted RDP endpoint exposed to WAN.',
          'score': 95,
          'xp_earned': 350,
        },
      };

      final report = ReportCase.fromJson(json);

      expect(report.id, 'rep_case_101_1');
      expect(report.caseNumber, '#FSC-0101');
      expect(report.caseId, 'case_101');
      expect(report.scenarioId, 'account-takeover');
      expect(report.attemptId, 'att_test_123');
      expect(report.title, 'Suspicious Account Login Incident Report');
      expect(report.category, 'Identity & Access');
      expect(report.severity, 'Critical');
      expect(report.status, 'FINALIZED');
      expect(report.score, 95);
      expect(report.xpEarned, 350);

      // Verify findings & remediation
      expect(report.findings.length, 2);
      expect(report.remediationActions.length, 2);
      expect(report.artifacts.length, 2);

      // Verify timeline
      expect(report.timeline.length, 1);
      expect(report.timeline.first.title, 'Initial Brute Force Alert');
      expect(report.timeline.first.severity, 'Critical');

      // Verify evidence
      expect(report.evidence.length, 1);
      expect(report.evidence.first.title, 'Authentication Audit Log');
      expect(report.evidence.first.metadata['ip'], '198.51.100.22');

      // Verify analyst actions
      expect(report.analystActions.length, 1);
      expect(report.analystActions.first.actionLabel, 'Isolate Host from VLAN');
      expect(report.analystActions.first.scoreDelta, 20);

      // Verify verdict
      expect(report.verdict, isNotNull);
      expect(report.verdict!.rootCause, 'Brute-force password spray');
      expect(report.verdict!.score, 95);

      // Verify toJson serialization round-trip
      final serialized = report.toJson();
      expect(serialized['id'], 'rep_case_101_1');
      expect(serialized['case_number'], '#FSC-0101');
      expect(serialized['score'], 95);
      expect(serialized['xp_earned'], 350);
      expect((serialized['timeline'] as List).length, 1);
      expect((serialized['evidence'] as List).length, 1);
      expect((serialized['analyst_actions'] as List).length, 1);
    });

    test('gracefully handles empty/missing optional fields', () {
      final json = {
        'id': 'rep_case_simple',
        'case_number': '#FSC-0001',
        'title': 'Minimal Report',
        'category': 'General',
        'severity': 'Low',
        'status': 'FINALIZED',
        'generated_at': '2026-09-30',
        'analyst': 'Analyst',
        'summary': 'Simple summary',
      };

      final report = ReportCase.fromJson(json);

      expect(report.id, 'rep_case_simple');
      expect(report.score, 100);
      expect(report.xpEarned, 0);
      expect(report.findings, isEmpty);
      expect(report.remediationActions, isEmpty);
      expect(report.artifacts, isEmpty);
      expect(report.timeline, isEmpty);
      expect(report.evidence, isEmpty);
      expect(report.analystActions, isEmpty);
      expect(report.verdict, isNull);
    });
  });
}
