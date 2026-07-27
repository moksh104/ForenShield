import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../providers/mission_control_provider.dart';
import '../widgets/achievement_card.dart';
import '../widgets/active_investigation_card.dart';
import '../widgets/activity_tile.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/mission_card.dart';
import '../widgets/notification_tile.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/section_header.dart';
import '../widgets/statistic_card.dart';
import '../widgets/threat_card.dart';

/// Mission Control Dashboard Screen — Enterprise Cybersecurity Command Center.
class MissionControlScreen extends ConsumerStatefulWidget {
  const MissionControlScreen({super.key});

  @override
  ConsumerState<MissionControlScreen> createState() =>
      _MissionControlScreenState();
}

class _MissionControlScreenState extends ConsumerState<MissionControlScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(missionControlProvider);
    final notifier = ref.read(missionControlProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _buildBody(context, state, notifier),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MissionControlState state,
    MissionControlNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    switch (state.status) {
      case MissionControlStatus.initial:
      case MissionControlStatus.loading:
        return Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        );

      case MissionControlStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: foren.critical.t500,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  state.errorMessage ?? 'Failed to load dashboard data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: () => notifier.loadDashboard(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.scaffoldBackgroundColor,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case MissionControlStatus.empty:
        return Center(
          child: Text(
            'No Mission Control Data Available.',
            style: TextStyle(color: foren.textDisabled),
          ),
        );

      case MissionControlStatus.refreshing:
      case MissionControlStatus.success:
        final data = state.data;
        if (data == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: () => notifier.refreshDashboard(),
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // 1. Welcome Header
              SliverToBoxAdapter(
                child: DashboardHeader(
                  userName: data.userName,
                  avatarUrl: data.userAvatarUrl,
                  rankTitle: data.rankTitle,
                  unreadNotifications:
                      data.notifications.where((n) => n.isUnread).length,
                  onNotificationTap: () =>
                      context.push(RouteConstants.settings),
                  onProfileTap: () => context.push(RouteConstants.profile),
                ),
              ),

              // 2. Cyber Risk Status Card
              SliverToBoxAdapter(
                child: ThreatCard(
                  threatLevel: data.overallThreatLevel,
                  securityScore: data.securityScore,
                  todayRiskMessage: data.todayRiskMessage,
                ),
              ),

              // 3. Today's Mission Section
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Today\'s Mission'),
              ),
              SliverToBoxAdapter(
                child: MissionCard(
                  title: data.currentMissionTitle,
                  estimatedMinutes: data.missionEstimatedMinutes,
                  difficulty: data.missionDifficulty,
                  progress: data.missionProgress,
                  isCompleted: data.isMissionCompleted,
                  onContinueTap: () => context.push(RouteConstants.simulation),
                ),
              ),

              // 4. Continue Learning Section
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Continue Learning'),
              ),
              SliverToBoxAdapter(
                child: ProgressCard(
                  courseTitle: data.currentCourseTitle,
                  moduleTitle: data.currentModuleTitle,
                  completionPercentage: data.courseCompletionPercentage,
                  timeRemaining: data.courseTimeRemaining,
                  onResumeTap: () => context.push(RouteConstants.academy),
                ),
              ),

              // 5. Active Investigation Section
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Active Investigation'),
              ),
              SliverToBoxAdapter(
                child: ActiveInvestigationCard(
                  caseId: data.activeCaseId,
                  caseTitle: data.activeCaseTitle,
                  caseType: data.activeCaseType,
                  evidenceCount: data.evidenceCount,
                  caseStatus: data.caseStatus,
                  completedObjectives: data.completedObjectives,
                  totalObjectives: data.totalObjectives,
                  onOpenTap: () => context.push(RouteConstants.investigation),
                ),
              ),

              // 6. Quick Actions Grid Section
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Quick Command Center'),
              ),
              const SliverToBoxAdapter(
                child: QuickActionGrid(),
              ),

              // 7. Recent Alerts & Notifications
              if (data.notifications.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: SectionHeader(title: 'Security Alerts & Updates'),
                ),
                SliverToBoxAdapter(
                  child: NotificationTileSection(
                    notifications: data.notifications,
                  ),
                ),
              ],

              // 8. Weekly Performance Statistics
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Weekly Performance Stats'),
              ),
              SliverToBoxAdapter(
                child: StatisticCard(
                  coursesCompleted: data.weeklyCoursesCompleted,
                  casesSolved: data.weeklyCasesSolved,
                  hoursPracticed: data.weeklyHoursPracticed,
                  xpEarned: data.weeklyXpEarned,
                  dailyXpData: data.dailyXpData,
                ),
              ),

              // 9. Achievements & Ranks
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Specialist Achievements'),
              ),
              SliverToBoxAdapter(
                child: AchievementCard(
                  currentLevel: data.userLevel,
                  currentXp: data.xpPoints,
                  nextLevelXp: data.nextLevelXp,
                  achievements: data.achievements,
                  onViewAllTap: () =>
                      context.push(RouteConstants.achievementsWall),
                ),
              ),

              // 10. Recent Activity Timeline
              if (data.recentActivities.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: SectionHeader(title: 'Recent Activity Log'),
                ),
                SliverToBoxAdapter(
                  child: ActivityTileSection(
                    activities: data.recentActivities,
                  ),
                ),
              ],

              // Bottom Margin
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl),
              ),
            ],
          ),
        );
    }
  }
}
