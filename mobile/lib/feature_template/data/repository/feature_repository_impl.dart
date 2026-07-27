import '../../../core/models/failure.dart' as core_fail;
import '../../../core/utils/result.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/feature_entity.dart';
import '../../domain/repository/feature_repository.dart';
import '../datasource/feature_local_datasource.dart';
import '../datasource/feature_remote_datasource.dart';
import '../models/feature_request.dart';

/// The concrete implementation of the Repository.
/// Orchestrates data retrieval between Local Cache and Remote API.
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  final FeatureLocalDataSource localDataSource;

  FeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<FeatureEntity>>> getFeatures() async {
    try {
      final remoteData = await remoteDataSource.getFeatures();
      await localDataSource.cacheFeatures(remoteData);
      return Success(remoteData);
    } on ApiException catch (e) {
      // Fallback to cache on network failure
      final cachedData = await localDataSource.getCachedFeatures();
      if (cachedData != null && cachedData.isNotEmpty) {
        return Success(cachedData);
      }
      return Failure(core_fail.Failure(message: e.message));
    } catch (e) {
      return Failure(core_fail.Failure(message: e.toString()));
    }
  }

  @override
  Future<Result<FeatureEntity>> getFeatureById(String id) async {
    try {
      final remoteData = await remoteDataSource.getFeatureById(id);
      return Success(remoteData);
    } on ApiException catch (e) {
      return Failure(core_fail.Failure(message: e.message));
    } catch (e) {
      return Failure(core_fail.Failure(message: e.toString()));
    }
  }

  @override
  Future<Result<FeatureEntity>> createFeature(
    String name,
    String description,
  ) async {
    try {
      final request = FeatureRequest(name: name, description: description);
      final remoteData = await remoteDataSource.createFeature(request);
      return Success(remoteData);
    } on ApiException catch (e) {
      return Failure(core_fail.Failure(message: e.message));
    } catch (e) {
      return Failure(core_fail.Failure(message: e.toString()));
    }
  }

  @override
  Future<Result<FeatureEntity>> updateFeature(
    String id,
    String name,
    String description,
  ) async {
    try {
      final request = FeatureRequest(name: name, description: description);
      final remoteData = await remoteDataSource.updateFeature(id, request);
      return Success(remoteData);
    } on ApiException catch (e) {
      return Failure(core_fail.Failure(message: e.message));
    } catch (e) {
      return Failure(core_fail.Failure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteFeature(String id) async {
    try {
      await remoteDataSource.deleteFeature(id);
      return const Success(null);
    } on ApiException catch (e) {
      return Failure(core_fail.Failure(message: e.message));
    } catch (e) {
      return Failure(core_fail.Failure(message: e.toString()));
    }
  }
}
