import '../../../core/models/failure.dart' as core_fail;
import '../../../core/utils/result.dart';
import '../entities/feature_entity.dart';
import '../repository/feature_repository.dart';

/// UseCase: Creates a new feature.
class CreateFeatureUseCase {
  final FeatureRepository repository;

  const CreateFeatureUseCase(this.repository);

  Future<Result<FeatureEntity>> execute(String name, String description) async {
    if (name.isEmpty) {
      return Failure(const core_fail.Failure(message: 'Name cannot be empty.'));
    }
    return await repository.createFeature(name, description);
  }
}
