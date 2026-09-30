import '../../../../core/utils/result.dart';
import '../../data/models/verdict_result_model.dart';
import '../repositories/investigation_repository.dart';

/// UseCase to submit investigation verdict.
/// Returns [VerdictResult] — the server-evaluated outcome with score, XP, and achievements.
class SubmitVerdictUseCase {
  final InvestigationRepository _repository;

  const SubmitVerdictUseCase(this._repository);

  Future<Result<VerdictResult>> call({
    required String caseId,
    required int selectedVerdictIndex,
  }) async {
    return await _repository.submitVerdict(
      caseId: caseId,
      selectedVerdictIndex: selectedVerdictIndex,
    );
  }
}
