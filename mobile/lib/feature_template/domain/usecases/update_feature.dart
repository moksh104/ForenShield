import '../../../core/models/failure.dart' as core_fail;
import '../../../core/utils/result.dart';
import '../entities/feature_entity.dart';
import '../repository/feature_repository.dart';

/// UseCase: Updates an existing feature.
class UpdateFeatureUseCase {
  final FeatureRepository repository;

  const UpdateFeatureUseCase(this.repository);

  Future<Result<FeatureEntity>> execute(
    String id,
    String name,
    String description,
  ) async {
    if (id.isEmpty) {
      return Failure(const core_fail.Failure(message: 'Invalid ID provided.'));
    }
    return await repository.updateFeature(id, name, description);
  }
}
