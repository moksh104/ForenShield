import '../../../../core/utils/result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase to update profile details.
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Result<ProfileEntity>> call({
    required String fullName,
    required String email,
    String? bio,
    String? phone,
    String? avatarUrl,
  }) async {
    return await _repository.updateProfile(
      fullName: fullName,
      email: email,
      bio: bio,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }
}
