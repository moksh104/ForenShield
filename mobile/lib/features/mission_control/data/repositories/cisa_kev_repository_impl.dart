import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/cisa_kev_entity.dart';
import '../../domain/repositories/cisa_kev_repository.dart';
import '../datasources/cisa_kev_remote_data_source.dart';

/// Concrete implementation of [CisaKevRepository].
///
/// Wraps the [CisaKevRemoteDataSource] in a [Result] discriminated union so
/// the provider/notifier layer never needs to catch exceptions directly.
class CisaKevRepositoryImpl implements CisaKevRepository {
  final CisaKevRemoteDataSource _remoteDataSource;

  const CisaKevRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<CisaKevEntry>>> getKevFeed() async {
    try {
      final response = await _remoteDataSource.getKevFeed();
      return Success(response.vulnerabilities);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load CISA KEV data: $e'));
    }
  }
}
