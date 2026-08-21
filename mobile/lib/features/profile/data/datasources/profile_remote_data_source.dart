import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../models/profile_model.dart';

/// Remote Data Source for Profile & Settings API calls.
class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  const ProfileRemoteDataSource(this._apiClient);

  /// Fetches profile data from backend API.
  Future<ProfileModel> getProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.profile,
    );
    if (response.data != null) {
      return ProfileModel.fromJson(response.data!);
    }
    throw const ApiException('Invalid profile data received from server');
  }

  /// Updates profile details (fullName, email, phone, avatarUrl).
  Future<ProfileModel> updateProfile({
    required String fullName,
    required String email,
    String? phone,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{'full_name': fullName, 'email': email};
    if (phone != null) data['phone'] = phone;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;

    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.updateProfile,
      data: data,
    );
    if (response.data != null) {
      return ProfileModel.fromJson(response.data!);
    }
    throw const ApiException('Failed to parse updated profile data');
  }

  /// Changes password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/profile/change-password',
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }
}
