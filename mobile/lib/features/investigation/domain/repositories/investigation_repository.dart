import '../../../../core/utils/result.dart';
import '../entities/evidence_entity.dart';
import '../entities/investigation_entity.dart';

/// Contract interface for Investigation Lab repository.
abstract class InvestigationRepository {
  /// Fetches cases with optional status, priority, search, sorting filters.
  Future<Result<List<InvestigationEntity>>> getCases({
    String? statusFilter,
    String? priorityFilter,
    String? searchQuery,
    String? sortBy,
  });

  /// Fetches a single case details by ID.
  Future<Result<InvestigationEntity>> getCaseDetail(String caseId);

  /// Fetches single evidence item details by ID.
  Future<Result<EvidenceEntity>> getEvidence(String evidenceId);

  /// Toggles reviewed status for an evidence artifact.
  Future<Result<EvidenceEntity>> markEvidenceReviewed(String evidenceId);

  /// Submits investigation verdict choice.
  Future<Result<int>> submitVerdict({
    required String caseId,
    required int selectedVerdictIndex,
  });
}
