import 'package:equatable/equatable.dart';

/// Entity representing an achievement unlocked or in-progress.
class AchievementItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final int xpReward;
  final bool isUnlocked;
  final double progress;

  const AchievementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.xpReward,
    required this.isUnlocked,
    required this.progress,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconName,
    xpReward,
    isUnlocked,
    progress,
  ];
}

/// Entity representing a notification alert.
class DashboardNotification extends Equatable {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final bool isUnread;
  final String type;

  const DashboardNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isUnread,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, message, timestamp, isUnread, type];
}

/// Entity representing a recent user activity log entry.
class DashboardActivity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String timestamp;
  final String type;
  final String iconName;

  const DashboardActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
    required this.iconName,
  });

  @override
  List<Object?> get props => [id, title, subtitle, timestamp, type, iconName];
}

/// Core domain entity for Mission Control Dashboard data.
class MissionControlEntity extends Equatable {
  final String userName;
  final String userAvatarUrl;
  final String rankTitle;
  final int xpPoints;
  final int userLevel;
  final int nextLevelXp;
  final String overallThreatLevel;
  final int securityScore;
  final String todayRiskMessage;
  final String currentMissionTitle;
  final int missionEstimatedMinutes;
  final String missionDifficulty;
  final double missionProgress;
  final bool isMissionCompleted;
  final String currentCourseTitle;
  final String currentModuleTitle;
  final double courseCompletionPercentage;
  final String courseTimeRemaining;
  final String activeCaseId;
  final String activeCaseTitle;
  final String activeCaseType;
  final int evidenceCount;
  final String caseStatus;
  final int completedObjectives;
  final int totalObjectives;
  final int weeklyCoursesCompleted;
  final int weeklyCasesSolved;
  final double weeklyHoursPracticed;
  final int weeklyXpEarned;
  final List<double> dailyXpData;
  final List<AchievementItem> achievements;
  final List<DashboardNotification> notifications;
  final List<DashboardActivity> recentActivities;

  const MissionControlEntity({
    required this.userName,
    required this.userAvatarUrl,
    required this.rankTitle,
    required this.xpPoints,
    required this.userLevel,
    required this.nextLevelXp,
    required this.overallThreatLevel,
    required this.securityScore,
    required this.todayRiskMessage,
    required this.currentMissionTitle,
    required this.missionEstimatedMinutes,
    required this.missionDifficulty,
    required this.missionProgress,
    required this.isMissionCompleted,
    required this.currentCourseTitle,
    required this.currentModuleTitle,
    required this.courseCompletionPercentage,
    required this.courseTimeRemaining,
    required this.activeCaseId,
    required this.activeCaseTitle,
    required this.activeCaseType,
    required this.evidenceCount,
    required this.caseStatus,
    required this.completedObjectives,
    required this.totalObjectives,
    required this.weeklyCoursesCompleted,
    required this.weeklyCasesSolved,
    required this.weeklyHoursPracticed,
    required this.weeklyXpEarned,
    required this.dailyXpData,
    required this.achievements,
    required this.notifications,
    required this.recentActivities,
  });

  @override
  List<Object?> get props => [
    userName,
    userAvatarUrl,
    rankTitle,
    xpPoints,
    userLevel,
    nextLevelXp,
    overallThreatLevel,
    securityScore,
    todayRiskMessage,
    currentMissionTitle,
    missionEstimatedMinutes,
    missionDifficulty,
    missionProgress,
    isMissionCompleted,
    currentCourseTitle,
    currentModuleTitle,
    courseCompletionPercentage,
    courseTimeRemaining,
    activeCaseId,
    activeCaseTitle,
    activeCaseType,
    evidenceCount,
    caseStatus,
    completedObjectives,
    totalObjectives,
    weeklyCoursesCompleted,
    weeklyCasesSolved,
    weeklyHoursPracticed,
    weeklyXpEarned,
    dailyXpData,
    achievements,
    notifications,
    recentActivities,
  ];
}
