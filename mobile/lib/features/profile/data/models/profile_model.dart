import '../../domain/entities/profile_entity.dart';

class UserStatsModel extends UserStatsEntity {
  const UserStatsModel({
    required super.totalLearningHours,
    required super.casesSolved,
    required super.coursesCompleted,
    required super.currentStreakDays,
    required super.securityScore,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalLearningHours:
          (json['total_learning_hours'] as num?)?.toDouble() ?? 24.5,
      casesSolved: json['cases_solved'] as int? ?? 12,
      coursesCompleted: json['courses_completed'] as int? ?? 4,
      currentStreakDays: json['current_streak_days'] as int? ?? 7,
      securityScore: json['security_score'] as int? ?? 88,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_learning_hours': totalLearningHours,
      'cases_solved': casesSolved,
      'courses_completed': coursesCompleted,
      'current_streak_days': currentStreakDays,
      'security_score': securityScore,
    };
  }
}

class AchievementBadgeModel extends AchievementBadgeEntity {
  const AchievementBadgeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconName,
    required super.unlockedDate,
    required super.xpReward,
    required super.isUnlocked,
  });

  factory AchievementBadgeModel.fromJson(Map<String, dynamic> json) {
    return AchievementBadgeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'shield',
      unlockedDate: json['unlocked_date'] as String? ?? '',
      xpReward: json['xp_reward'] as int? ?? 100,
      isUnlocked: json['is_unlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_name': iconName,
      'unlocked_date': unlockedDate,
      'xp_reward': xpReward,
      'is_unlocked': isUnlocked,
    };
  }
}

class XpHistoryItemModel extends XpHistoryItemEntity {
  const XpHistoryItemModel({
    required super.id,
    required super.title,
    required super.source,
    required super.xpAmount,
    required super.timestamp,
  });

  factory XpHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return XpHistoryItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      source: json['source'] as String? ?? '',
      xpAmount: json['xp_amount'] as int? ?? 50,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'source': source,
      'xp_amount': xpAmount,
      'timestamp': timestamp,
    };
  }
}

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.role,
    required super.avatarUrl,
    required super.xpPoints,
    required super.rankTitle,
    required super.memberSince,
    required super.accountStatus,
    required super.level,
    required super.nextLevelXp,
    required UserStatsModel super.stats,
    required List<AchievementBadgeModel> super.badges,
    required List<XpHistoryItemModel> super.xpHistory,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? 'usr_101',
      fullName: json['full_name'] as String? ?? 'Agent Moksh',
      email: json['email'] as String? ?? 'moksh@forenshield.com',
      role: json['role'] as String? ?? 'Forensic Specialist',
      avatarUrl: json['avatar_url'] as String? ?? '',
      xpPoints: json['xp_points'] as int? ?? 1450,
      rankTitle: json['rank_title'] as String? ?? 'Analyst II',
      memberSince: json['member_since'] as String? ?? 'Jan 2026',
      accountStatus: json['account_status'] as String? ?? 'Active / Verified',
      level: json['level'] as int? ?? 5,
      nextLevelXp: json['next_level_xp'] as int? ?? 2000,
      stats: json['stats'] != null
          ? UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>)
          : _defaultStats,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) =>
                  AchievementBadgeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          _defaultBadges,
      xpHistory: (json['xp_history'] as List<dynamic>?)
              ?.map((e) =>
                  XpHistoryItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          _defaultXpHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'avatar_url': avatarUrl,
      'xp_points': xpPoints,
      'rank_title': rankTitle,
      'member_since': memberSince,
      'account_status': accountStatus,
      'level': level,
      'next_level_xp': nextLevelXp,
      'stats': (stats as UserStatsModel).toJson(),
      'badges':
          badges.map((b) => (b as AchievementBadgeModel).toJson()).toList(),
      'xp_history':
          xpHistory.map((x) => (x as XpHistoryItemModel).toJson()).toList(),
    };
  }

  static const UserStatsModel _defaultStats = UserStatsModel(
    totalLearningHours: 24.5,
    casesSolved: 12,
    coursesCompleted: 4,
    currentStreakDays: 7,
    securityScore: 88,
  );

  static const List<AchievementBadgeModel> _defaultBadges = [
    AchievementBadgeModel(
      id: 'b1',
      title: 'First Responder',
      description: 'Completed your first live simulation drill',
      iconName: 'shield',
      unlockedDate: '2026-06-10',
      xpReward: 100,
      isUnlocked: true,
    ),
    AchievementBadgeModel(
      id: 'b2',
      title: 'Memory Master',
      description: 'Solved 10 RAM memory forensics cases',
      iconName: 'psychology',
      unlockedDate: '2026-07-02',
      xpReward: 300,
      isUnlocked: true,
    ),
    AchievementBadgeModel(
      id: 'b3',
      title: 'Cyber Specialist',
      description: 'Reach Level 5 rank',
      iconName: 'military_tech',
      unlockedDate: '2026-07-15',
      xpReward: 500,
      isUnlocked: true,
    ),
  ];

  static const List<XpHistoryItemModel> _defaultXpHistory = [
    XpHistoryItemModel(
      id: 'xp1',
      title: 'Completed Lesson: Volatility 3 Analysis',
      source: 'Cyber Academy',
      xpAmount: 50,
      timestamp: '2h ago',
    ),
    XpHistoryItemModel(
      id: 'xp2',
      title: 'Solved Case: #FSC-0091 NovaCorp Breach',
      source: 'Investigation Lab',
      xpAmount: 500,
      timestamp: '1d ago',
    ),
    XpHistoryItemModel(
      id: 'xp3',
      title: 'Daily Streak Bonus (7 Days)',
      source: 'Mission Control',
      xpAmount: 100,
      timestamp: '2d ago',
    ),
  ];
}
