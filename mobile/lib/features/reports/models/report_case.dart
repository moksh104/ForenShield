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
}
