class ReportTimelineItem {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final String category;
  final String severity;

  const ReportTimelineItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    required this.severity,
  });

  factory ReportTimelineItem.fromJson(Map<String, dynamic> json) {
    return ReportTimelineItem(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      category: json['category'] as String? ?? 'Forensics',
      severity: json['severity'] as String? ?? 'Info',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'category': category,
      'severity': severity,
    };
  }
}

class ReportEvidenceItem {
  final String id;
  final String title;
  final String type;
  final String content;
  final String timestamp;
  final Map<String, dynamic> metadata;

  const ReportEvidenceItem({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    required this.timestamp,
    required this.metadata,
  });

  factory ReportEvidenceItem.fromJson(Map<String, dynamic> json) {
    return ReportEvidenceItem(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'artifact',
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      metadata: json['metadata'] is Map<String, dynamic>
          ? json['metadata'] as Map<String, dynamic>
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'content': content,
      'timestamp': timestamp,
      'metadata': metadata,
    };
  }
}

class ReportActionItem {
  final String actionId;
  final String actionLabel;
  final int scoreDelta;
  final String consequence;

  const ReportActionItem({
    required this.actionId,
    required this.actionLabel,
    required this.scoreDelta,
    required this.consequence,
  });

  factory ReportActionItem.fromJson(Map<String, dynamic> json) {
    return ReportActionItem(
      actionId: (json['action_id'] ?? json['actionId'] ?? '').toString(),
      actionLabel: json['action_label'] as String? ?? json['actionLabel'] as String? ?? '',
      scoreDelta: (json['score_delta'] ?? json['scoreDelta'] ?? 0) as int,
      consequence: json['consequence'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action_id': actionId,
      'action_label': actionLabel,
      'score_delta': scoreDelta,
      'consequence': consequence,
    };
  }
}

class ReportVerdictSnapshot {
  final String summary;
  final String rootCause;
  final String explanation;
  final int score;
  final int xpEarned;

  const ReportVerdictSnapshot({
    required this.summary,
    required this.rootCause,
    required this.explanation,
    required this.score,
    required this.xpEarned,
  });

  factory ReportVerdictSnapshot.fromJson(Map<String, dynamic> json) {
    return ReportVerdictSnapshot(
      summary: json['summary'] as String? ?? '',
      rootCause: json['root_cause'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      score: (json['score'] ?? 100) as int,
      xpEarned: (json['xp_earned'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'root_cause': rootCause,
      'explanation': explanation,
      'score': score,
      'xp_earned': xpEarned,
    };
  }
}

class ReportCase {
  final String id;
  final String caseNumber;
  final String? caseId;
  final String? scenarioId;
  final String? attemptId;
  final String title;
  final String category;
  final String severity;
  final String status;
  final String generatedAt;
  final String analyst;
  final String summary;
  final int score;
  final int xpEarned;
  final List<String> findings;
  final List<String> remediationActions;
  final List<String> artifacts;
  final List<ReportTimelineItem> timeline;
  final List<ReportEvidenceItem> evidence;
  final List<ReportActionItem> analystActions;
  final ReportVerdictSnapshot? verdict;

  const ReportCase({
    required this.id,
    required this.caseNumber,
    this.caseId,
    this.scenarioId,
    this.attemptId,
    required this.title,
    required this.category,
    required this.severity,
    required this.status,
    required this.generatedAt,
    required this.analyst,
    required this.summary,
    this.score = 100,
    this.xpEarned = 0,
    required this.findings,
    required this.remediationActions,
    required this.artifacts,
    this.timeline = const [],
    this.evidence = const [],
    this.analystActions = const [],
    this.verdict,
  });

  factory ReportCase.fromJson(Map<String, dynamic> json) {
    return ReportCase(
      id: (json['id'] ?? '').toString(),
      caseNumber: json['case_number'] as String? ?? '',
      caseId: json['case_id'] as String?,
      scenarioId: json['scenario_id'] as String?,
      attemptId: json['attempt_id'] as String?,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      severity: json['severity'] as String? ?? 'Medium',
      status: json['status'] as String? ?? 'Open',
      generatedAt: json['generated_at'] as String? ?? '',
      analyst: json['analyst'] as String? ?? 'Analyst',
      summary: json['summary'] as String? ?? '',
      score: (json['score'] ?? 100) as int,
      xpEarned: (json['xp_earned'] ?? 0) as int,
      findings:
          (json['findings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      remediationActions:
          (json['remediation_actions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      artifacts:
          (json['artifacts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      timeline:
          (json['timeline'] as List<dynamic>?)
              ?.map((e) => ReportTimelineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      evidence:
          (json['evidence'] as List<dynamic>?)
              ?.map((e) => ReportEvidenceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      analystActions:
          (json['analyst_actions'] as List<dynamic>?)
              ?.map((e) => ReportActionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      verdict: json['verdict'] is Map<String, dynamic> && (json['verdict'] as Map<String, dynamic>).isNotEmpty
          ? ReportVerdictSnapshot.fromJson(json['verdict'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'case_number': caseNumber,
      'case_id': caseId,
      'scenario_id': scenarioId,
      'attempt_id': attemptId,
      'title': title,
      'category': category,
      'severity': severity,
      'status': status,
      'generated_at': generatedAt,
      'analyst': analyst,
      'summary': summary,
      'score': score,
      'xp_earned': xpEarned,
      'findings': findings,
      'remediation_actions': remediationActions,
      'artifacts': artifacts,
      'timeline': timeline.map((e) => e.toJson()).toList(),
      'evidence': evidence.map((e) => e.toJson()).toList(),
      'analyst_actions': analystActions.map((e) => e.toJson()).toList(),
      'verdict': verdict?.toJson(),
    };
  }
}
