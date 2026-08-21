import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class AchievementRemoteDataSource {
  final ApiClient _apiClient;

  const AchievementRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> fetchAchievements(
    String category, {
    int page = 1,
    int limit = 20,
    String search = '',
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.achievementsList,
      queryParameters: {
        'category': category,
        'page': page,
        'limit': limit,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return response.data ?? {};
  }
}
