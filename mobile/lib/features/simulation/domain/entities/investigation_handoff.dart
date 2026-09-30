class InvestigationHandoff {
  final String originatingSimulationId;
  final String originatingSimulationTitle;
  final String? caseId;
  final String? caseTitle;
  final List<String> discoveredEvidenceIds;
  final int finalScore;
  final String status;
  final String summary;
  final DateTime completedAt;

  const InvestigationHandoff({
    required this.originatingSimulationId,
    required this.originatingSimulationTitle,
    this.caseId,
    this.caseTitle,
    this.discoveredEvidenceIds = const [],
    required this.finalScore,
    required this.status,
    required this.summary,
    required this.completedAt,
  });

  factory InvestigationHandoff.fromJson(Map<String, dynamic> json) {
    DateTime parseTime(dynamic val) {
      if (val == null) return DateTime.now();
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return InvestigationHandoff(
      originatingSimulationId:
          (json['originating_simulation_id'] ?? '').toString(),
      originatingSimulationTitle:
          (json['originating_simulation_title'] ?? '').toString(),
      caseId: json['case_id']?.toString(),
      caseTitle: json['case_title']?.toString(),
      discoveredEvidenceIds:
          (json['discovered_evidence_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      finalScore: (json['final_score'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '').toString(),
      summary: (json['summary'] ?? '').toString(),
      completedAt: parseTime(json['completed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originating_simulation_id': originatingSimulationId,
      'originating_simulation_title': originatingSimulationTitle,
      'case_id': caseId,
      'case_title': caseTitle,
      'discovered_evidence_ids': discoveredEvidenceIds,
      'final_score': finalScore,
      'status': status,
      'summary': summary,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
