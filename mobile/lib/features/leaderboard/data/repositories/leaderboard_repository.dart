import '../datasource/leaderboard_remote_data_source.dart';
import '../models/leaderboard_entry_model.dart';

/// Repository wrapping [LeaderboardRemoteDataSource] with error handling.
class LeaderboardRepository {
  final LeaderboardRemoteDataSource _dataSource;

  const LeaderboardRepository(this._dataSource);

  /// Fetches the leaderboard for a given [period] with pagination and search.
  Future<List<LeaderboardEntryModel>> fetchLeaderboard(
    String period, {
    int page = 1,
    String search = '',
  }) async {
    try {
      final data = await _dataSource.fetchLeaderboard(
        period,
        page: page,
        search: search,
      );

      final rawEntries = data['leaderboard'] as List<dynamic>? ?? [];
      final entries = rawEntries
          .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return entries;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the current user's profile rank data
  Future<LeaderboardProfileResult> fetchProfileRank() async {
    try {
      final data = await _dataSource.fetchProfileRank();

      LeaderboardEntryModel? currentUser;
      if (data['current_user'] != null) {
        currentUser = LeaderboardEntryModel.fromJson(
          data['current_user'] as Map<String, dynamic>,
        );
      }

      final rawNearby = data['nearby_players'] as List<dynamic>? ?? [];
      final nearbyPlayers = rawNearby
          .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return LeaderboardProfileResult(
        currentUser: currentUser,
        percentile: (data['percentile'] as num?)?.toDouble() ?? 0.0,
        totalPlayers: (data['total_players'] as int?) ?? 0,
        weeklyPosition: (data['weekly_position'] as int?) ?? 0,
        monthlyPosition: (data['monthly_position'] as int?) ?? 0,
        nearbyPlayers: nearbyPlayers,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Value object for profile rank results.
class LeaderboardProfileResult {
  final LeaderboardEntryModel? currentUser;
  final double percentile;
  final int totalPlayers;
  final int weeklyPosition;
  final int monthlyPosition;
  final List<LeaderboardEntryModel> nearbyPlayers;

  const LeaderboardProfileResult({
    this.currentUser,
    required this.percentile,
    required this.totalPlayers,
    required this.weeklyPosition,
    required this.monthlyPosition,
    required this.nearbyPlayers,
  });
}
