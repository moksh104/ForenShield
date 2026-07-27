import '../../../../core/utils/result.dart';
import '../entities/evidence_entity.dart';
import '../repositories/investigation_repository.dart';

/// UseCase to load evidence item.
class LoadEvidenceUseCase {
  final InvestigationRepository _repository;

  const LoadEvidenceUseCase(this._repository);

  Future<Result<EvidenceEntity>> call(String evidenceId) async {
    return await _repository.getEvidence(evidenceId);
  }
}
