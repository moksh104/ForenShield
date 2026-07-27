import 'package:equatable/equatable.dart';

/// User statistics domain entity.
class UserStatsEntity extends Equatable {
  final double totalLearningHours;
  final int casesSolved;
  final int coursesCompleted;
  final int currentStreakDays;
  final int securityScore;

  const UserStatsEntity({
    required this.totalLearningHours,
    required this.casesSolved,
    required this.coursesCompleted,
    required this.currentStreakDays,
    required this.securityScore,
  });

  @override
  List<Object?> get props => [
        totalLearningHours,
        casesSolved,
        coursesCompleted,
        currentStreakDays,
        securityScore,
      ];
}

/// Achievement badge entity.
class AchievementBadgeEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final String unlockedDate;
  final int xpReward;
  final bool isUnlocked;

  const AchievementBadgeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.unlockedDate,
    required this.xpReward,
    required this.isUnlocked,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconName,
        unlockedDate,
        xpReward,
        isUnlocked,
      ];
}

/// XP log item entity.
class XpHistoryItemEntity extends Equatable {
  final String id;
  final String title;
  final String source;
  final int xpAmount;
  final String timestamp;

  const XpHistoryItemEntity({
    required this.id,
    required this.title,
    required this.source,
    required this.xpAmount,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, title, source, xpAmount, timestamp];
}

/// Core Profile domain entity.
class ProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String avatarUrl;
  final String bio;
  final String phone;
  final int xpPoints;
  final String rankTitle;
  final String memberSince;
  final String accountStatus;
  final int level;
  final int nextLevelXp;
  final UserStatsEntity stats;
  final List<AchievementBadgeEntity> badges;
  final List<XpHistoryItemEntity> xpHistory;

  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.avatarUrl,
    this.bio = 'Lead Cyber Forensic Specialist',
    this.phone = '+1 (555) 019-2834',
    required this.xpPoints,
    required this.rankTitle,
    required this.memberSince,
    required this.accountStatus,
    required this.level,
    required this.nextLevelXp,
    required this.stats,
    required this.badges,
    required this.xpHistory,
  });

  ProfileEntity copyWith({
    String? fullName,
    String? email,
    String? avatarUrl,
    String? bio,
    String? phone,
  }) {
    return ProfileEntity(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      xpPoints: xpPoints,
      rankTitle: rankTitle,
      memberSince: memberSince,
      accountStatus: accountStatus,
      level: level,
      nextLevelXp: nextLevelXp,
      stats: stats,
      badges: badges,
      xpHistory: xpHistory,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        role,
        avatarUrl,
        bio,
        phone,
        xpPoints,
        rankTitle,
        memberSince,
        accountStatus,
        level,
        nextLevelXp,
        stats,
        badges,
        xpHistory,
      ];
}
