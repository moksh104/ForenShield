import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

/// Remote data source for achievement endpoints.
class AchievementRemoteDataSource {
  final ApiClient _apiClient;

  const AchievementRemoteDataSource(this._apiClient);

  /// Fetches all achievements for the authenticated user.
  Future<Map<String, dynamic>> fetchAchievements() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.achievements,
    );
    return response.data ?? {};
  }
}
