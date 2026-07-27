import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/mission_control_entity.dart';
import '../../domain/repositories/mission_control_repository.dart';
import '../datasources/mission_control_remote_data_source.dart';

/// Implementation of [MissionControlRepository].
class MissionControlRepositoryImpl implements MissionControlRepository {
  final MissionControlRemoteDataSource _remoteDataSource;

  const MissionControlRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<MissionControlEntity>> getDashboardData() async {
    try {
      final data = await _remoteDataSource.getDashboardData();
      return Success(data);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load Mission Control data: $e'));
    }
  }
}
