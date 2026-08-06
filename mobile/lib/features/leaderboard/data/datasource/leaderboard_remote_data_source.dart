import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

/// Remote data source for leaderboard endpoints.
class LeaderboardRemoteDataSource {
  final ApiClient _apiClient;

  const LeaderboardRemoteDataSource(this._apiClient);

  /// Fetches the ranked leaderboard filtered by [period].
  ///
  /// [period] can be 'all', 'weekly', or 'monthly'.
  Future<Map<String, dynamic>> fetchLeaderboard(String period) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.leaderboard,
      queryParameters: {'period': period},
    );
    return response.data ?? {};
  }

  /// Awards XP to the authenticated user.
  Future<Map<String, dynamic>> updateXp(int xp, String reason) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.updateXp,
      data: {'xp': xp, 'reason': reason},
    );
    return response.data ?? {};
  }
}
