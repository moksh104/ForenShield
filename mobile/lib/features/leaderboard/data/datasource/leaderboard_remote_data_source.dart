import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

/// Remote data source for leaderboard endpoints.
class LeaderboardRemoteDataSource {
  final ApiClient _apiClient;

  const LeaderboardRemoteDataSource(this._apiClient);

  /// Fetches the ranked leaderboard filtered by [period].
  ///
  /// [period] can be 'all', 'weekly', 'monthly', 'investigators', 'learners'.
  Future<Map<String, dynamic>> fetchLeaderboard(
    String period, {
    int page = 1,
    int limit = 20,
    String search = '',
  }) async {
    String endpoint = ApiEndpoints.leaderboardGlobal;
    if (period == 'weekly') {
      endpoint = ApiEndpoints.leaderboardWeekly;
    } else if (period == 'monthly') {
      endpoint = ApiEndpoints.leaderboardMonthly;
    } else if (period == 'investigators') {
      endpoint = ApiEndpoints.leaderboardTopInvestigators;
    } else if (period == 'learners') {
      endpoint = ApiEndpoints.leaderboardTopLearners;
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return response.data ?? {};
  }

  /// Fetches the current user's personalized rank card
  Future<Map<String, dynamic>> fetchProfileRank() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.leaderboardProfileRank,
    );
    return response.data ?? {};
  }
}
