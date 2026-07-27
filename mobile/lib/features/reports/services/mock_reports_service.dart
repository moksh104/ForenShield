import '../models/report_case.dart';

class MockReportsService {
  const MockReportsService();

  List<ReportCase> fetchReports() {
    return const [
      ReportCase(
        id: 'rpt-ransomware-containment',
        caseNumber: 'FSR-2026-014',
        title: 'Ransomware Outbreak Containment',
        category: 'Incident Response Report',
        severity: 'Critical',
        status: 'Closed',
        generatedAt: '26 Jul 2026 · 14:20 UTC',
        analyst: 'Moksh Patel',
        summary:
            'Mock case report documenting the containment of a ransomware beacon on FS-HOST-09 with a verified firewall block on port 4444.',
        findings: [
          'Outbound C2 traffic observed to 198.51.100.42:8080 over port 4444.',
          'Malicious process ransomware_agent identified with PID 4092.',
          'Firewall DROP rule successfully blocked the active command channel.',
        ],
        remediationActions: [
          'Ran netstat to identify the suspicious socket and remote endpoint.',
          'Used pkill to terminate the malware process.',
          'Applied an emergency iptables rule to block port 4444.',
        ],
        artifacts: [
          'Terminal transcript capture',
          'Process termination log',
          'Firewall rule audit entry',
        ],
      ),
      ReportCase(
        id: 'rpt-sqli-remediation',
        caseNumber: 'FSR-2026-012',
        title: 'SQL Injection Attack Remediation',
        category: 'Web Security Report',
        severity: 'High',
        status: 'Closed',
        generatedAt: '24 Jul 2026 · 09:10 UTC',
        analyst: 'Moksh Patel',
        summary:
            'Mock remediation notes for a SQL injection incident detected in web access logs and contained through WAF sanitization.',
        findings: [
          'Injected payload observed in Nginx access logs.',
          'Requests matched a classic tautology-based SQLi pattern.',
          'No data exfiltration indicators were identified in the sandbox.',
        ],
        remediationActions: [
          'Reviewed access logs for payload signatures.',
          'Applied a mock WAF sanitization rule.',
          'Recommended input validation and parameterized queries.',
        ],
        artifacts: [
          'Access log excerpt',
          'WAF policy snapshot',
          'Case analyst notes',
        ],
      ),
      ReportCase(
        id: 'rpt-ssh-analysis',
        caseNumber: 'FSR-2026-009',
        title: 'Unauthorized SSH Access Analysis',
        category: 'DFIR Report',
        severity: 'Medium',
        status: 'In Review',
        generatedAt: '22 Jul 2026 · 18:45 UTC',
        analyst: 'Moksh Patel',
        summary:
            'Draft DFIR report showing repeated SSH brute-force attempts against the bastion host and pending key revocation actions.',
        findings: [
          'Repeated failed logins originated from 198.51.100.42.',
          'Root account was the primary target of the attack burst.',
          'Authentication logs remain intact for follow-up analysis.',
        ],
        remediationActions: [
          'Documented brute-force indicators.',
          'Prepared a key revocation plan.',
          'Queued follow-up integrity checks for the bastion host.',
        ],
        artifacts: [
          'Auth log excerpt',
          'IOC timeline',
          'Pending response checklist',
        ],
      ),
    ];
  }
}
