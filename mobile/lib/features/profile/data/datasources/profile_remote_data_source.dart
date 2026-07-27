import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

/// Remote Data Source for Profile & Settings API calls.
class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  const ProfileRemoteDataSource(this._apiClient);

  /// Fetches profile data from backend API.
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/profile');
      if (response.data != null) {
        return ProfileModel.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }
    return ProfileModel.fromJson(const {});
  }

  /// Updates profile details (fullName, email).
  Future<ProfileModel> updateProfile({
    required String fullName,
    required String email,
  }) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/profile/update',
        data: {'full_name': fullName, 'email': email},
      );
      if (response.data != null) {
        return ProfileModel.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback update
    }
    final current = await getProfile();
    return current.copyWith(fullName: fullName, email: email) as ProfileModel;
  }

  /// Changes password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post<Map<String, dynamic>>(
        '/profile/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } catch (_) {
      // Simulated API response
    }
  }
}
