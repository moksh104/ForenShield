import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../datasources/nvd_remote_data_source.dart';
import '../models/nvd_model.dart';

/// Concrete implementation of the NVD statistics repository.
///
/// Wraps [NvdRemoteDataSource] in a [Result] discriminated union so the
/// provider/notifier layer receives typed success/failure without catching
/// exceptions directly.
class NvdRepositoryImpl {
  final NvdRemoteDataSource _remoteDataSource;

  const NvdRepositoryImpl(this._remoteDataSource);

  /// Returns a [Result] wrapping the aggregated [NvdStats] on success,
  /// or an [AppException] on any failure.
  Future<Result<NvdStats>> getNvdStats() async {
    try {
      final model = await _remoteDataSource.getNvdStats();
      return Success(model);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load NVD statistics: $e'));
    }
  }
}
