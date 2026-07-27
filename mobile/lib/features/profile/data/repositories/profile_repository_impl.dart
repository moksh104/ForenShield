import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

/// Implementation of [ProfileRepository].
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ProfileEntity>> getProfile() async {
    try {
      final profile = await _remoteDataSource.getProfile();
      return Success(profile);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to load profile: $e'));
    }
  }

  @override
  Future<Result<ProfileEntity>> updateProfile({
    required String fullName,
    required String email,
    String? bio,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final updated = await _remoteDataSource.updateProfile(
        fullName: fullName,
        email: email,
      );
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to update profile: $e'));
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ApiException('Failed to change password: $e'));
    }
  }
}
