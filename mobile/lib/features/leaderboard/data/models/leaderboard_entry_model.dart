/// Represents a single entry in the ForenShield global leaderboard.
class LeaderboardEntryModel {
  final int userId;
  final String username;
  final int xp;
  final int rank;
  final int completedCourses;
  final int completedCases;
  final int streak;
  final String? avatarUrl;
  final DateTime? lastActivity;

  const LeaderboardEntryModel({
    required this.userId,
    required this.username,
    required this.xp,
    required this.rank,
    required this.completedCourses,
    required this.completedCases,
    required this.streak,
    this.avatarUrl,
    this.lastActivity,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      username: (json['username'] ?? 'Agent').toString(),
      xp: json['xp'] is int
          ? json['xp']
          : int.tryParse(json['xp']?.toString() ?? '0') ?? 0,
      rank: json['rank'] is int
          ? json['rank']
          : int.tryParse(json['rank']?.toString() ?? '0') ?? 0,
      completedCourses: json['completed_courses'] is int
          ? json['completed_courses']
          : int.tryParse(json['completed_courses']?.toString() ?? '0') ?? 0,
      completedCases: json['completed_cases'] is int
          ? json['completed_cases']
          : int.tryParse(json['completed_cases']?.toString() ?? '0') ?? 0,
      streak: json['streak'] is int
          ? json['streak']
          : int.tryParse(json['streak']?.toString() ?? '0') ?? 0,
      avatarUrl: json['avatar_url']?.toString(),
      lastActivity: json['last_activity'] != null
          ? DateTime.tryParse(json['last_activity'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'xp': xp,
      'rank': rank,
      'completed_courses': completedCourses,
      'completed_cases': completedCases,
      'streak': streak,
      'avatar_url': avatarUrl,
      'last_activity': lastActivity?.toIso8601String(),
    };
  }

  LeaderboardEntryModel copyWith({
    int? userId,
    String? username,
    int? xp,
    int? rank,
    int? completedCourses,
    int? completedCases,
    int? streak,
    String? avatarUrl,
    DateTime? lastActivity,
  }) {
    return LeaderboardEntryModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      xp: xp ?? this.xp,
      rank: rank ?? this.rank,
      completedCourses: completedCourses ?? this.completedCourses,
      completedCases: completedCases ?? this.completedCases,
      streak: streak ?? this.streak,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
