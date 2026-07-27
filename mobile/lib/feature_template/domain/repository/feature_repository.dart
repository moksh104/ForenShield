import '../../../core/utils/result.dart';
import '../entities/feature_entity.dart';

/// The contract for data operations on FeatureEntity.
/// The Domain layer defines *what* is needed, but not *how* it is fetched.
abstract interface class FeatureRepository {
  /// Fetches a list of FeatureEntities.
  Future<Result<List<FeatureEntity>>> getFeatures();

  /// Fetches a single FeatureEntity by its ID.
  Future<Result<FeatureEntity>> getFeatureById(String id);

  /// Creates a new FeatureEntity.
  Future<Result<FeatureEntity>> createFeature(String name, String description);

  /// Updates an existing FeatureEntity.
  Future<Result<FeatureEntity>> updateFeature(
    String id,
    String name,
    String description,
  );

  /// Deletes a FeatureEntity.
  Future<Result<void>> deleteFeature(String id);
}
