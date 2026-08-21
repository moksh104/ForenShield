class ReportCase {
  final String id;
  final String caseNumber;
  final String title;
  final String category;
  final String severity;
  final String status;
  final String generatedAt;
  final String analyst;
  final String summary;
  final List<String> findings;
  final List<String> remediationActions;
  final List<String> artifacts;

  const ReportCase({
    required this.id,
    required this.caseNumber,
    required this.title,
    required this.category,
    required this.severity,
    required this.status,
    required this.generatedAt,
    required this.analyst,
    required this.summary,
    required this.findings,
    required this.remediationActions,
    required this.artifacts,
  });

  factory ReportCase.fromJson(Map<String, dynamic> json) {
    return ReportCase(
      id: (json['id'] ?? '').toString(),
      caseNumber: json['case_number'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      severity: json['severity'] as String? ?? 'Medium',
      status: json['status'] as String? ?? 'Open',
      generatedAt: json['generated_at'] as String? ?? '',
      analyst: json['analyst'] as String? ?? 'Analyst',
      summary: json['summary'] as String? ?? '',
      findings:
          (json['findings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      remediationActions:
          (json['remediation_actions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      artifacts:
          (json['artifacts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'case_number': caseNumber,
      'title': title,
      'category': category,
      'severity': severity,
      'status': status,
      'generated_at': generatedAt,
      'analyst': analyst,
      'summary': summary,
      'findings': findings,
      'remediation_actions': remediationActions,
      'artifacts': artifacts,
    };
  }
}
