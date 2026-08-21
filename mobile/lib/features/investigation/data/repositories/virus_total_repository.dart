import '../../../../core/utils/result.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../models/virus_total_model.dart';
import '../datasources/virus_total_remote_data_source.dart';

class VirusTotalRepository {
  final VirusTotalRemoteDataSource _remoteDataSource;

  const VirusTotalRepository(this._remoteDataSource);

  Future<Result<VirusTotalModel>> getAnalysis(String query) async {
    try {
      final analysis = await _remoteDataSource.getAnalysis(query);
      return Success(analysis);
    } catch (e) {
      if (e is AppException) {
        return Failure(e);
      }
      return Failure(ServerException(e.toString()));
    }
  }
}
