import '../../../core/models/failure.dart' as core_fail;
import '../../../core/utils/result.dart';
import '../repository/feature_repository.dart';

/// UseCase: Deletes a feature.
class DeleteFeatureUseCase {
  final FeatureRepository repository;

  const DeleteFeatureUseCase(this.repository);

  Future<Result<void>> execute(String id) async {
    if (id.isEmpty) {
      return Failure(const core_fail.Failure(message: 'Invalid ID provided.'));
    }
    return await repository.deleteFeature(id);
  }
}
