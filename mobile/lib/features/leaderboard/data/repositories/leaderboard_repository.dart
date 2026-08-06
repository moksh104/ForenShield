import '../datasource/leaderboard_remote_data_source.dart';
import '../models/leaderboard_entry_model.dart';

/// Repository wrapping [LeaderboardRemoteDataSource] with error handling.
class LeaderboardRepository {
  final LeaderboardRemoteDataSource _dataSource;

  const LeaderboardRepository(this._dataSource);

  /// Fetches the leaderboard for a given [period].
  ///
  /// Returns a map containing leaderboard entries, current user entry,
  /// and metadata.
  Future<LeaderboardResult> fetchLeaderboard(String period) async {
    try {
      final data = await _dataSource.fetchLeaderboard(period);

      final rawEntries = data['leaderboard'] as List<dynamic>? ?? [];
      final entries = rawEntries
          .map((e) =>
              LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      LeaderboardEntryModel? currentUser;
      if (data['current_user'] != null) {
        currentUser = LeaderboardEntryModel.fromJson(
            data['current_user'] as Map<String, dynamic>);
      }

      return LeaderboardResult(
        entries: entries,
        currentUser: currentUser,
        myRank: (data['my_rank'] as int?) ?? 0,
        totalPlayers: (data['total_players'] as int?) ?? entries.length,
        period: period,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Awards XP and returns updated stats.
  Future<Map<String, dynamic>> updateXp(int xp, String reason) async {
    try {
      return await _dataSource.updateXp(xp, reason);
    } catch (e) {
      rethrow;
    }
  }
}

/// Value object for leaderboard query results.
class LeaderboardResult {
  final List<LeaderboardEntryModel> entries;
  final LeaderboardEntryModel? currentUser;
  final int myRank;
  final int totalPlayers;
  final String period;

  const LeaderboardResult({
    required this.entries,
    this.currentUser,
    required this.myRank,
    required this.totalPlayers,
    required this.period,
  });
}
