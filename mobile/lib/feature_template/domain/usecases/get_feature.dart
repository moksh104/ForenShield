import '../../../core/models/failure.dart' as core_fail;
import '../../../core/utils/result.dart';
import '../entities/feature_entity.dart';
import '../repository/feature_repository.dart';

/// UseCase: Retrieves all features.
/// UseCases encapsulate a single, specific business action.
class GetFeaturesUseCase {
  final FeatureRepository repository;

  const GetFeaturesUseCase(this.repository);

  Future<Result<List<FeatureEntity>>> execute() async {
    return await repository.getFeatures();
  }
}

/// UseCase: Retrieves a specific feature.
class GetFeatureByIdUseCase {
  final FeatureRepository repository;

  const GetFeatureByIdUseCase(this.repository);

  Future<Result<FeatureEntity>> execute(String id) async {
    if (id.isEmpty) {
      return Failure(const core_fail.Failure(message: 'Invalid ID provided.'));
    }
    return await repository.getFeatureById(id);
  }
}
