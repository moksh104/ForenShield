import '../../domain/entities/mission_control_entity.dart';

/// Data model for Mission Control Dashboard serialization.
class MissionControlModel extends MissionControlEntity {
  const MissionControlModel({
    required super.userName,
    required super.userAvatarUrl,
    required super.rankTitle,
    required super.xpPoints,
    required super.userLevel,
    required super.nextLevelXp,
    required super.overallThreatLevel,
    required super.securityScore,
    required super.todayRiskMessage,
    required super.currentMissionTitle,
    required super.missionEstimatedMinutes,
    required super.missionDifficulty,
    required super.missionProgress,
    required super.isMissionCompleted,
    required super.currentCourseTitle,
    required super.currentModuleTitle,
    required super.courseCompletionPercentage,
    required super.courseTimeRemaining,
    required super.activeCaseId,
    required super.activeCaseTitle,
    required super.activeCaseType,
    required super.evidenceCount,
    required super.caseStatus,
    required super.completedObjectives,
    required super.totalObjectives,
    required super.weeklyCoursesCompleted,
    required super.weeklyCasesSolved,
    required super.weeklyHoursPracticed,
    required super.weeklyXpEarned,
    required super.dailyXpData,
    required super.achievements,
    required super.notifications,
    required super.recentActivities,
  });

  factory MissionControlModel.fromJson(Map<String, dynamic> json) {
    return MissionControlModel(
      userName: json['user_name'] as String? ?? 'Agent Moksh',
      userAvatarUrl: json['user_avatar_url'] as String? ?? '',
      rankTitle: json['rank_title'] as String? ?? 'Analyst II',
      xpPoints: json['xp_points'] as int? ?? 1450,
      userLevel: json['user_level'] as int? ?? 5,
      nextLevelXp: json['next_level_xp'] as int? ?? 2000,
      overallThreatLevel: json['overall_threat_level'] as String? ?? 'LOW',
      securityScore: json['security_score'] as int? ?? 88,
      todayRiskMessage:
          json['today_risk_message'] as String? ?? 'Minimal Anomalies Detected',
      currentMissionTitle:
          json['current_mission_title'] as String? ??
          'Identify Phishing Vector #204',
      missionEstimatedMinutes: json['mission_estimated_minutes'] as int? ?? 15,
      missionDifficulty: json['mission_difficulty'] as String? ?? 'Medium',
      missionProgress: (json['mission_progress'] as num?)?.toDouble() ?? 0.45,
      isMissionCompleted: json['is_mission_completed'] as bool? ?? false,
      currentCourseTitle:
          json['current_course_title'] as String? ??
          'Digital Forensics & Incident Response',
      currentModuleTitle:
          json['current_module_title'] as String? ??
          'Module 3 · Memory Artifact Analysis',
      courseCompletionPercentage:
          (json['course_completion_percentage'] as num?)?.toDouble() ?? 0.68,
      courseTimeRemaining:
          json['course_time_remaining'] as String? ?? '25 min left',
      activeCaseId: (json['active_case_id'] ?? '#FSC-0091').toString(),
      activeCaseTitle:
          json['active_case_title'] as String? ??
          'Ransomware Intrusion: NovaCorp',
      activeCaseType:
          json['active_case_type'] as String? ?? 'Memory & Disk Forensics',
      evidenceCount: json['evidence_count'] as int? ?? 12,
      caseStatus: json['case_status'] as String? ?? 'IN PROGRESS',
      completedObjectives: json['completed_objectives'] as int? ?? 4,
      totalObjectives: json['total_objectives'] as int? ?? 7,
      weeklyCoursesCompleted: json['weekly_courses_completed'] as int? ?? 3,
      weeklyCasesSolved: json['weekly_cases_solved'] as int? ?? 8,
      weeklyHoursPracticed:
          (json['weekly_hours_practiced'] as num?)?.toDouble() ?? 14.5,
      weeklyXpEarned: json['weekly_xp_earned'] as int? ?? 1250,
      dailyXpData:
          (json['daily_xp_data'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [120, 240, 180, 310, 290, 420, 350],
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((e) => AchievementItemModel.fromJson(e))
              .toList() ??
          _defaultAchievements,
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map((e) => DashboardNotificationModel.fromJson(e))
              .toList() ??
          _defaultNotifications,
      recentActivities:
          (json['recent_activities'] as List<dynamic>?)
              ?.map((e) => DashboardActivityModel.fromJson(e))
              .toList() ??
          _defaultActivities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'user_avatar_url': userAvatarUrl,
      'rank_title': rankTitle,
      'xp_points': xpPoints,
      'user_level': userLevel,
      'next_level_xp': nextLevelXp,
      'overall_threat_level': overallThreatLevel,
      'security_score': securityScore,
      'today_risk_message': todayRiskMessage,
      'current_mission_title': currentMissionTitle,
      'mission_estimated_minutes': missionEstimatedMinutes,
      'mission_difficulty': missionDifficulty,
      'mission_progress': missionProgress,
      'is_mission_completed': isMissionCompleted,
      'current_course_title': currentCourseTitle,
      'current_module_title': currentModuleTitle,
      'course_completion_percentage': courseCompletionPercentage,
      'course_time_remaining': courseTimeRemaining,
      'active_case_id': activeCaseId,
      'active_case_title': activeCaseTitle,
      'active_case_type': activeCaseType,
      'evidence_count': evidenceCount,
      'case_status': caseStatus,
      'completed_objectives': completedObjectives,
      'total_objectives': totalObjectives,
      'weekly_courses_completed': weeklyCoursesCompleted,
      'weekly_cases_solved': weeklyCasesSolved,
      'weekly_hours_practiced': weeklyHoursPracticed,
      'weekly_xp_earned': weeklyXpEarned,
      'daily_xp_data': dailyXpData,
    };
  }

  static const List<AchievementItem> _defaultAchievements = [
    AchievementItem(
      id: 'ach_1',
      title: 'First Responder',
      description: 'Completed your first live simulation drill',
      iconName: 'shield',
      xpReward: 100,
      isUnlocked: true,
      progress: 1.0,
    ),
    AchievementItem(
      id: 'ach_2',
      title: 'Master Investigator',
      description: 'Solved 10 forensic investigation cases',
      iconName: 'search',
      xpReward: 300,
      isUnlocked: true,
      progress: 1.0,
    ),
    AchievementItem(
      id: 'ach_3',
      title: 'Cyber Specialist',
      description: 'Reach 2,000 total XP',
      iconName: 'bolt',
      xpReward: 500,
      isUnlocked: false,
      progress: 0.725,
    ),
  ];

  static const List<DashboardNotification> _defaultNotifications = [
    DashboardNotification(
      id: 'notif_1',
      title: 'High Severity Threat Alert',
      message: 'New ransomware IOC matching NovaCorp signature',
      timestamp: '10m ago',
      isUnread: true,
      type: 'warning',
    ),
    DashboardNotification(
      id: 'notif_2',
      title: 'Academy Milestone Achieved',
      message: 'You earned the Memory Master badge!',
      timestamp: '1h ago',
      isUnread: true,
      type: 'success',
    ),
    DashboardNotification(
      id: 'notif_3',
      title: 'System Security Update',
      message: 'Threat database signatures updated v4.12',
      timestamp: '3h ago',
      isUnread: false,
      type: 'info',
    ),
  ];

  static const List<DashboardActivity> _defaultActivities = [
    DashboardActivity(
      id: 'act_1',
      title: 'Completed Volatility Memory Analysis',
      subtitle: 'Academy · Module 3',
      timestamp: '2h ago',
      type: 'academy',
      iconName: 'check_circle',
    ),
    DashboardActivity(
      id: 'act_2',
      title: 'Extracted Registry Evidence #E-09',
      subtitle: 'Investigation · #FSC-0091',
      timestamp: '4h ago',
      type: 'investigation',
      iconName: 'folder_open',
    ),
    DashboardActivity(
      id: 'act_3',
      title: 'Unlocked Achievement: First Responder',
      subtitle: 'Reward: +100 XP',
      timestamp: '1d ago',
      type: 'achievement',
      iconName: 'military_tech',
    ),
  ];
}

class AchievementItemModel {
  static AchievementItem fromJson(Map<String, dynamic> json) {
    return AchievementItem(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'shield',
      xpReward: json['xp_reward'] as int? ?? 100,
      isUnlocked: json['is_unlocked'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DashboardNotificationModel {
  static DashboardNotification fromJson(Map<String, dynamic> json) {
    return DashboardNotification(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      isUnread: json['is_unread'] as bool? ?? false,
      type: json['type'] as String? ?? 'info',
    );
  }
}

class DashboardActivityModel {
  static DashboardActivity fromJson(Map<String, dynamic> json) {
    return DashboardActivity(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      iconName: json['icon_name'] as String? ?? 'info',
    );
  }
}
