import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/evidence_entity.dart';
import '../../domain/entities/investigation_entity.dart';
import '../../domain/repositories/investigation_repository.dart';
import '../datasources/investigation_remote_data_source.dart';

/// Implementation of [InvestigationRepository].
class InvestigationRepositoryImpl implements InvestigationRepository {
  final InvestigationRemoteDataSource _remoteDataSource;

  const InvestigationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<InvestigationEntity>>> getCases({
    String? statusFilter,
    String? priorityFilter,
    String? searchQuery,
    String? sortBy,
  }) async {
    try {
      final cases = await _remoteDataSource.getCases(
        statusFilter: statusFilter,
        priorityFilter: priorityFilter,
        searchQuery: searchQuery,
        sortBy: sortBy,
      );
      return Success(cases);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load investigation cases: $e'));
    }
  }

  @override
  Future<Result<InvestigationEntity>> getCaseDetail(String caseId) async {
    try {
      final caseDetail = await _remoteDataSource.getCaseDetail(caseId);
      return Success(caseDetail);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load case details: $e'));
    }
  }

  @override
  Future<Result<EvidenceEntity>> getEvidence(String evidenceId) async {
    try {
      final evidence = await _remoteDataSource.getEvidence(evidenceId);
      return Success(evidence);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load evidence: $e'));
    }
  }

  @override
  Future<Result<EvidenceEntity>> markEvidenceReviewed(String evidenceId) async {
    try {
      final evidence = await _remoteDataSource.getEvidence(evidenceId);
      final updated = evidence.copyWith(isReviewed: true);
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to mark evidence reviewed: $e'));
    }
  }

  @override
  Future<Result<int>> submitVerdict({
    required String caseId,
    required int selectedVerdictIndex,
  }) async {
    try {
      final score = await _remoteDataSource.submitVerdict(
        caseId: caseId,
        selectedVerdictIndex: selectedVerdictIndex,
      );
      return Success(score);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to submit verdict: $e'));
    }
  }
}
