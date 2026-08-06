import '../../../../core/utils/result.dart';
import '../../domain/entities/mission_control_entity.dart';
import '../../domain/repositories/mission_control_repository.dart';

/// Offline mock implementation of [MissionControlRepository].
///
/// Returns rich, realistic cybersecurity dashboard metrics, active investigations,
/// achievements, and activity feeds with a simulated 600ms latency.
class MockMissionControlRepository implements MissionControlRepository {
  @override
  Future<Result<MissionControlEntity>> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const Success(
      MissionControlEntity(
        userName: 'Moksh Patel',
        userAvatarUrl: '',
        rankTitle: 'Senior Cyber Investigator',
        xpPoints: 4250,
        userLevel: 14,
        nextLevelXp: 5000,
        overallThreatLevel: 'ELEVATED',
        securityScore: 88,
        todayRiskMessage:
            'Phishing campaign targeting internal financial endpoints detected.',
        currentMissionTitle: 'Analyze Suspicious Memory Dump',
        missionEstimatedMinutes: 15,
        missionDifficulty: 'Intermediate',
        missionProgress: 0.65,
        isMissionCompleted: false,
        currentCourseTitle: 'Digital Forensics & Memory Analysis',
        currentModuleTitle: 'Volatiles & Process Injection',
        courseCompletionPercentage: 75.0,
        courseTimeRemaining: '45 mins left',
        activeCaseId: 'case_101',
        activeCaseTitle: 'Corporate Spear Phishing & Credential Harvest',
        activeCaseType: 'Email Forensics',
        evidenceCount: 5,
        caseStatus: 'In Progress',
        completedObjectives: 3,
        totalObjectives: 5,
        weeklyCoursesCompleted: 2,
        weeklyCasesSolved: 4,
        weeklyHoursPracticed: 8.5,
        weeklyXpEarned: 1250,
        dailyXpData: [120, 300, 450, 200, 550, 600, 420],
        achievements: [
          AchievementItem(
            id: 'ach_1',
            title: 'First Blood',
            description: 'Successfully solved your first forensic case.',
            iconName: 'shield',
            xpReward: 100,
            isUnlocked: true,
            progress: 1.0,
          ),
          AchievementItem(
            id: 'ach_2',
            title: 'Memory Master',
            description: 'Analyzed 10 memory dumps without hints.',
            iconName: 'memory',
            xpReward: 250,
            isUnlocked: true,
            progress: 1.0,
          ),
          AchievementItem(
            id: 'ach_3',
            title: 'Packet Whisperer',
            description: 'Parsed over 10,000 Wireshark PCAP packets.',
            iconName: 'network_check',
            xpReward: 500,
            isUnlocked: false,
            progress: 0.7,
          ),
        ],
        notifications: [
          DashboardNotification(
            id: 'notif_1',
            title: 'New Investigation Assigned',
            message: 'Case #102: Ransomware Attack on Server Alpha is open.',
            timestamp: '10m ago',
            isUnread: true,
            type: 'alert',
          ),
          DashboardNotification(
            id: 'notif_2',
            title: 'Streak Preserved!',
            message: 'You have maintained a 7-day learning streak.',
            timestamp: '2h ago',
            isUnread: false,
            type: 'info',
          ),
        ],
        recentActivities: [
          DashboardActivity(
            id: 'act_1',
            title: 'Completed Quiz: Process Injection Diagnostics',
            subtitle: 'Scored 95% (+150 XP)',
            timestamp: '1h ago',
            type: 'academy',
            iconName: 'quiz',
          ),
          DashboardActivity(
            id: 'act_2',
            title: 'Reviewed Evidence: Email Headers #EV-04',
            subtitle: 'Confirmed SPF/DKIM spoofing signature',
            timestamp: '3h ago',
            type: 'investigation',
            iconName: 'find_in_page',
          ),
          DashboardActivity(
            id: 'act_3',
            title: 'Unlocked Achievement: Memory Master',
            subtitle: '+250 XP Credited',
            timestamp: '1d ago',
            type: 'achievement',
            iconName: 'stars',
          ),
        ],
      ),
    );
  }
}
