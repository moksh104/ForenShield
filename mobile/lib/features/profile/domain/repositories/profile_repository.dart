import '../../../../core/utils/result.dart';
import '../entities/profile_entity.dart';

/// Contract interface for Profile repository.
abstract class ProfileRepository {
  /// Fetches user profile data.
  Future<Result<ProfileEntity>> getProfile();

  /// Updates user profile details (fullName, email, bio, phone, avatarUrl).
  Future<Result<ProfileEntity>> updateProfile({
    required String fullName,
    required String email,
    String? bio,
    String? phone,
    String? avatarUrl,
  });

  /// Changes password.
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
