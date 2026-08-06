import 'package:equatable/equatable.dart';
import 'evidence_entity.dart';
import 'timeline_entity.dart';
import 'verdict_entity.dart';

/// Suspect person of interest in an investigation case.
class SuspectEntity extends Equatable {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final String ipAddress;
  final String status;

  const SuspectEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.ipAddress,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, role, avatarUrl, ipAddress, status];
}

/// Core Case Domain Entity for Investigation Lab.
typedef CaseEntity = InvestigationEntity;

class InvestigationEntity extends Equatable {
  final String id;
  final String caseCode;
  final String title;
  final String description;
  final String priority; // 'Critical' | 'High' | 'Medium' | 'Low'
  final String difficulty; // 'Beginner' | 'Intermediate' | 'Advanced'
  final String status; // 'Open' | 'In Progress' | 'Solved'
  final String assignedDate;
  final double progress;
  final List<EvidenceEntity> evidenceList;
  final List<TimelineEventEntity> timeline;
  final List<SuspectEntity> suspects;
  final String notes;
  final List<String> objectives;
  final VerdictEntity? verdict;

  const InvestigationEntity({
    required this.id,
    required this.caseCode,
    required this.title,
    required this.description,
    required this.priority,
    required this.difficulty,
    required this.status,
    required this.assignedDate,
    required this.progress,
    required this.evidenceList,
    required this.timeline,
    required this.suspects,
    required this.notes,
    required this.objectives,
    this.verdict,
  });

  InvestigationEntity copyWith({
    String? status,
    double? progress,
    List<EvidenceEntity>? evidenceList,
    List<TimelineEventEntity>? timeline,
    String? notes,
  }) {
    return InvestigationEntity(
      id: id,
      caseCode: caseCode,
      title: title,
      description: description,
      priority: priority,
      difficulty: difficulty,
      status: status ?? this.status,
      assignedDate: assignedDate,
      progress: progress ?? this.progress,
      evidenceList: evidenceList ?? this.evidenceList,
      timeline: timeline ?? this.timeline,
      suspects: suspects,
      notes: notes ?? this.notes,
      objectives: objectives,
      verdict: verdict,
    );
  }

  @override
  List<Object?> get props => [
    id,
    caseCode,
    title,
    description,
    priority,
    difficulty,
    status,
    assignedDate,
    progress,
    evidenceList,
    timeline,
    suspects,
    notes,
    objectives,
    verdict,
  ];
}
