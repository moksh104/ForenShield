import '../../../../core/utils/result.dart';
import '../entities/investigation_entity.dart';
import '../repositories/investigation_repository.dart';

/// UseCase to load investigation cases.
class LoadCasesUseCase {
  final InvestigationRepository _repository;

  const LoadCasesUseCase(this._repository);

  Future<Result<List<InvestigationEntity>>> call({
    String? statusFilter,
    String? priorityFilter,
    String? searchQuery,
    String? sortBy,
  }) async {
    return await _repository.getCases(
      statusFilter: statusFilter,
      priorityFilter: priorityFilter,
      searchQuery: searchQuery,
      sortBy: sortBy,
    );
  }
}
