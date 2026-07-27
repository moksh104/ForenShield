import '../../../../core/utils/result.dart';
import '../repositories/investigation_repository.dart';

/// UseCase to submit investigation verdict.
class SubmitVerdictUseCase {
  final InvestigationRepository _repository;

  const SubmitVerdictUseCase(this._repository);

  Future<Result<int>> call({
    required String caseId,
    required int selectedVerdictIndex,
  }) async {
    return await _repository.submitVerdict(
      caseId: caseId,
      selectedVerdictIndex: selectedVerdictIndex,
    );
  }
}
