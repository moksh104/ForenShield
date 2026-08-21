import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';
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
    if (ApiConfig.useMockApi) {
      return _getFallbackCases(
        statusFilter: statusFilter,
        priorityFilter: priorityFilter,
        searchQuery: searchQuery,
      );
    }
    final response = await _apiClient.get<List<dynamic>>(
      '/investigation_cases.php',
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
    throw const ApiException('Invalid cases data received');
  }

  /// Fetches case details by ID.
  Future<CaseModel> getCaseDetail(String caseId) async {
    if (ApiConfig.useMockApi) {
      final all = _getFallbackCases();
      return all.firstWhere((c) => c.id == caseId, orElse: () => all.first);
    }
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/investigation_case_detail.php',
      queryParameters: {'id': caseId},
    );
    if (response.data != null) {
      return CaseModel.fromJson(response.data!);
    }
    throw const ApiException('Invalid case details received');
  }

  /// Fetches single evidence item details.
  Future<EvidenceModel> getEvidence(String evidenceId) async {
    if (ApiConfig.useMockApi) {
      final caseDetail = await getCaseDetail('case_101');
      final found = caseDetail.evidenceList.firstWhere(
        (e) => e.id == evidenceId,
        orElse: () => _fallbackEvidence.first,
      );
      return found as EvidenceModel;
    }
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/investigation_evidence.php',
      queryParameters: {'id': evidenceId},
    );
    if (response.data != null) {
      return EvidenceModel.fromJson(response.data!);
    }
    throw const ApiException('Invalid evidence data received');
  }

  /// Submits verdict decision.
  Future<int> submitVerdict({
    required String caseId,
    required int selectedVerdictIndex,
  }) async {
    if (ApiConfig.useMockApi) {
      return selectedVerdictIndex == 1 ? 100 : 40;
    }
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/investigation_verdict.php',
      data: {'case_id': caseId, 'selected_verdict_index': selectedVerdictIndex},
    );
    if (response.data != null && response.data!['score'] != null) {
      return response.data!['score'] as int;
    }
    throw const ApiException('Invalid verdict submission response');
  }

  static const List<EvidenceModel> _fallbackEvidence = [
    EvidenceModel(
      id: 'ev_001',
      title: 'Suspicious USB Dump Log',
      type: 'log',
      contentText:
          '2026-04-24 14:02:11 UTC - USB Mass Storage Device Attached: SanDisk Ultra 3.0 (SN: 99482012)',
      metadataMap: {
        'Source': 'Windows Event Log (System)',
        'Event ID': '20001',
        'User': 'SYSTEM / Administrator',
        'Computer': 'FINANCE-PC01',
        'SHA-256': '44d88612fea8a8f36de82e1278abb02f',
      },
      isReviewed: true,
      timestamp: '2026-04-24 14:02 UTC',
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
        caseCode: 'Case #01',
        title: 'USB Forensics Investigation',
        description:
            'A suspicious USB drive was found. Analyze the data and find the evidence.',
        priority: 'Medium',
        difficulty: 'Beginner',
        status: 'In Progress',
        assignedDate: '2026-04-24',
        progress: 0.60,
        evidenceList: _fallbackEvidence,
        timeline: const [
          TimelineEventModel(
            id: 'tl_1',
            title: 'USB Drive Attached',
            description: 'Unidentified USB device inserted into workstation.',
            timestamp: '14:00 UTC',
            category: 'Physical Access',
            severity: 'Medium',
            isExpanded: true,
          ),
        ],
        suspects: const [],
        notes: 'USB drive contains hidden partition with payload.',
        objectives: const [
          'Examine USB disk image partitions',
          'Extract deleted files from FAT32 volume',
          'Identify malicious executable',
        ],
        verdict: const VerdictModel(
          id: 'v_101',
          caseId: 'case_101',
          summaryText:
              'Identify the primary malware vector found on the USB drive.',
          options: [
            'Autorun.inf launching hidden binary',
            'Corrupted partition table',
            'Normal documents only',
          ],
          correctOptionIndex: 0,
          explanationText:
              'Autorun.inf was configured to launch an obfuscated payload.',
          xpReward: 300,
        ),
      ),
      const CaseModel(
        id: 'case_102',
        caseCode: 'Case #02',
        title: 'Phishing Email Analysis',
        description:
            'Investigate a phishing email and identify the attacker\'s intent and indicators.',
        priority: 'High',
        difficulty: 'Intermediate',
        status: 'In Progress',
        assignedDate: '2026-04-24',
        progress: 0.40,
        evidenceList: [],
        timeline: [],
        suspects: [],
        notes: '',
        objectives: ['Analyze SMTP headers', 'Extract malicious link'],
      ),
      const CaseModel(
        id: 'case_103',
        caseCode: 'Case #03',
        title: 'Network Intrusion Case',
        description:
            'Analyze network logs and traces to identify the source of intrusion.',
        priority: 'Critical',
        difficulty: 'Advanced',
        status: 'Open',
        assignedDate: '2026-04-20',
        progress: 0.20,
        evidenceList: [],
        timeline: [],
        suspects: [],
        notes: '',
        objectives: ['Analyze PCAP network trace', 'Identify C2 IP address'],
      ),
      const CaseModel(
        id: 'case_104',
        caseCode: 'Case #04',
        title: 'Mobile Device Analysis',
        description:
            'Extract and analyze data from a mobile device to uncover hidden information.',
        priority: 'Medium',
        difficulty: 'Intermediate',
        status: 'Open',
        assignedDate: '2026-04-18',
        progress: 0.00,
        evidenceList: [],
        timeline: [],
        suspects: [],
        notes: '',
        objectives: ['Extract SQLite database', 'Recover deleted SMS logs'],
      ),
    ];

    return cases.where((c) {
      if (statusFilter != null && statusFilter != 'All') {
        if (statusFilter == 'Beginner' && c.difficulty != 'Beginner') {
          return false;
        }
        if (statusFilter == 'Intermediate' && c.difficulty != 'Intermediate') {
          return false;
        }
        if (statusFilter == 'Advanced' && c.difficulty != 'Advanced') {
          return false;
        }
        if (statusFilter == 'Completed' && c.progress < 1.0) {
          return false;
        }
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return c.title.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }
}
