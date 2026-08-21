import '../../../../core/utils/result.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../models/mitre_technique_model.dart';
import '../datasources/mitre_remote_data_source.dart';

class MitreRepository {
  final MitreRemoteDataSource _remoteDataSource;

  MitreRepository(this._remoteDataSource);

  Future<Result<List<MitreTechniqueModel>>> getMitreTechniques() async {
    try {
      final techniques = await _remoteDataSource.getMitreTechniques();
      return Success(techniques);
    } catch (e) {
      if (e is AppException) {
        return Failure(e);
      }
      return Failure(ServerException(e.toString()));
    }
  }
}
