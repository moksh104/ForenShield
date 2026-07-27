import '../../domain/entities/investigation_entity.dart';
import 'evidence_model.dart';
import 'timeline_model.dart';
import 'verdict_model.dart';

class SuspectModel extends SuspectEntity {
  const SuspectModel({
    required super.id,
    required super.name,
    required super.role,
    required super.avatarUrl,
    required super.ipAddress,
    required super.status,
  });

  factory SuspectModel.fromJson(Map<String, dynamic> json) {
    return SuspectModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      ipAddress: json['ip_address'] as String? ?? '',
      status: json['status'] as String? ?? 'Suspect',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'avatar_url': avatarUrl,
      'ip_address': ipAddress,
      'status': status,
    };
  }
}

class CaseModel extends InvestigationEntity {
  const CaseModel({
    required super.id,
    required super.caseCode,
    required super.title,
    required super.description,
    required super.priority,
    required super.difficulty,
    required super.status,
    required super.assignedDate,
    required super.progress,
    required List<EvidenceModel> super.evidenceList,
    required List<TimelineEventModel> super.timeline,
    required List<SuspectModel> super.suspects,
    required super.notes,
    required super.objectives,
    super.verdict,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as String? ?? '',
      caseCode: json['case_code'] as String? ?? '#FSC-000',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'Medium',
      difficulty: json['difficulty'] as String? ?? 'Intermediate',
      status: json['status'] as String? ?? 'Open',
      assignedDate: json['assigned_date'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      evidenceList: (json['evidence_list'] as List<dynamic>?)
              ?.map((e) => EvidenceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => TimelineEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suspects: (json['suspects'] as List<dynamic>?)
              ?.map((e) => SuspectModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: json['notes'] as String? ?? '',
      objectives: (json['objectives'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      verdict: json['verdict'] != null
          ? VerdictModel.fromJson(json['verdict'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'case_code': caseCode,
      'title': title,
      'description': description,
      'priority': priority,
      'difficulty': difficulty,
      'status': status,
      'assigned_date': assignedDate,
      'progress': progress,
      'evidence_list':
          evidenceList.map((e) => (e as EvidenceModel).toJson()).toList(),
      'timeline':
          timeline.map((t) => (t as TimelineEventModel).toJson()).toList(),
      'suspects':
          suspects.map((s) => (s as SuspectModel).toJson()).toList(),
      'notes': notes,
      'objectives': objectives,
      'verdict': verdict != null ? (verdict as VerdictModel).toJson() : null,
    };
  }
}
