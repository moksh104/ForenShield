import '../../../../core/utils/result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase to load profile.
class LoadProfileUseCase {
  final ProfileRepository _repository;

  const LoadProfileUseCase(this._repository);

  Future<Result<ProfileEntity>> call() async {
    return await _repository.getProfile();
  }
}
