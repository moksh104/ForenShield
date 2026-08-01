import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/effects/scanner_effect.dart';
import '../../../../core/theme/app_radius.dart';
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
      body: ParticleBackground(
        numberOfParticles: 30,
        particleColor: theme.colorScheme.primary,
        duration: const Duration(seconds: 18),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildBody(context, state, notifier),
          ),
        ),
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
        return KeyedSubtree(
          key: const ValueKey('loading_state'),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScannerEffect(
                  size: 140.0,
                  color: theme.colorScheme.primary,
                  duration: const Duration(milliseconds: 2000),
                  child: Icon(
                    Icons.security,
                    size: 36,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'INITIALIZING MISSION CONTROL...',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
                ).animate().fadeIn().scale(),
              ],
            ),
          ),
        );

      case MissionControlStatus.error:
        return KeyedSubtree(
          key: const ValueKey('error_state'),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GlassEffect(
                blurX: 16.0,
                blurY: 16.0,
                opacity: 0.14,
                borderRadius: AppRadius.borderRadiusLg,
                border: Border.all(
                  color: foren.critical.t500.withValues(alpha: 0.5),
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlowEffect(
                      glowColor: foren.critical.t500,
                      blurRadius: 20,
                      spreadRadius: 4,
                      animate: true,
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(
                        Icons.error_outline,
                        color: foren.critical.t500,
                        size: 56,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'COMMAND LINK OFFLINE',
                      style: TextStyle(
                        color: foren.critical.t500,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      state.errorMessage ?? 'Failed to synchronize dashboard telemetry.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    GlowEffect(
                      glowColor: theme.colorScheme.primary,
                      blurRadius: 10,
                      spreadRadius: 2,
                      animate: true,
                      borderRadius: AppRadius.borderRadiusMd,
                      child: ElevatedButton.icon(
                        onPressed: () => notifier.loadDashboard(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.scaffoldBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.md,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.borderRadiusMd,
                          ),
                        ),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text(
                          'Re-establish Uplink',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case MissionControlStatus.empty:
        return KeyedSubtree(
          key: const ValueKey('empty_state'),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GlassEffect(
                blurX: 16.0,
                blurY: 16.0,
                opacity: 0.14,
                borderRadius: AppRadius.borderRadiusLg,
                border: Border.all(
                  color: foren.borderSubtle.withValues(alpha: 0.4),
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScannerEffect(
                      size: 130.0,
                      color: foren.textDisabled,
                      duration: const Duration(milliseconds: 3000),
                      child: Icon(
                        Icons.space_dashboard_outlined,
                        color: foren.textDisabled,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'NO ACTIVE TELEMETRY',
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'No Mission Control Data Available.',
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton.icon(
                      onPressed: () => notifier.refreshDashboard(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(color: theme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      icon: const Icon(Icons.sync, size: 16),
                      label: const Text('Poll Sensors'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case MissionControlStatus.refreshing:
      case MissionControlStatus.success:
        final data = state.data;
        if (data == null) return const SizedBox.shrink();

        return KeyedSubtree(
          key: const ValueKey('success_state'),
          child: RefreshIndicator(
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
                  ).animate().fadeIn(duration: 400.ms, delay: 40.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 2. Cyber Risk Status Card
                SliverToBoxAdapter(
                  child: ThreatCard(
                    threatLevel: data.overallThreatLevel,
                    securityScore: data.securityScore,
                    todayRiskMessage: data.todayRiskMessage,
                  ).animate().fadeIn(duration: 400.ms, delay: 90.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 3. Today's Mission Section
                SliverToBoxAdapter(
                  child: const SectionHeader(title: 'Today\'s Mission')
                      .animate().fadeIn(duration: 400.ms, delay: 140.ms),
                ),
                SliverToBoxAdapter(
                  child: MissionCard(
                    title: data.currentMissionTitle,
                    estimatedMinutes: data.missionEstimatedMinutes,
                    difficulty: data.missionDifficulty,
                    progress: data.missionProgress,
                    isCompleted: data.isMissionCompleted,
                    onContinueTap: () => context.push(RouteConstants.simulation),
                  ).animate().fadeIn(duration: 400.ms, delay: 160.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 4. Continue Learning Section
                SliverToBoxAdapter(
                  child: const SectionHeader(title: 'Continue Learning')
                      .animate().fadeIn(duration: 400.ms, delay: 200.ms),
                ),
                SliverToBoxAdapter(
                  child: ProgressCard(
                    courseTitle: data.currentCourseTitle,
                    moduleTitle: data.currentModuleTitle,
                    completionPercentage: data.courseCompletionPercentage,
                    timeRemaining: data.courseTimeRemaining,
                    onResumeTap: () => context.push(RouteConstants.academy),
                  ).animate().fadeIn(duration: 400.ms, delay: 220.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 5. Active Investigation Section
                SliverToBoxAdapter(
                  child: const SectionHeader(title: 'Active Investigation')
                      .animate().fadeIn(duration: 400.ms, delay: 260.ms),
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
                  ).animate().fadeIn(duration: 400.ms, delay: 280.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 6. Quick Actions Grid Section
                SliverToBoxAdapter(
                  child: const SectionHeader(title: 'Quick Command Center')
                      .animate().fadeIn(duration: 400.ms, delay: 320.ms),
                ),
                SliverToBoxAdapter(
                  child: const QuickActionGrid()
                      .animate().fadeIn(duration: 400.ms, delay: 340.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 7. Recent Alerts & Notifications
                if (data.notifications.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: const SectionHeader(title: 'Security Alerts & Updates')
                        .animate().fadeIn(duration: 400.ms, delay: 380.ms),
                  ),
                  SliverToBoxAdapter(
                    child: NotificationTileSection(
                      notifications: data.notifications,
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                  ),
                ],

                // 8. Weekly Performance Statistics
                SliverToBoxAdapter(
                  child: const SectionHeader(title: 'Weekly Performance Stats')
                      .animate().fadeIn(duration: 400.ms, delay: 440.ms),
                ),
                SliverToBoxAdapter(
                  child: StatisticCard(
                    coursesCompleted: data.weeklyCoursesCompleted,
                    casesSolved: data.weeklyCasesSolved,
                    hoursPracticed: data.weeklyHoursPracticed,
                    xpEarned: data.weeklyXpEarned,
                    dailyXpData: data.dailyXpData,
                  ).animate().fadeIn(duration: 400.ms, delay: 460.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 9. Achievements & Ranks
                SliverToBoxAdapter(
                  child: const SectionHeader(title: 'Specialist Achievements')
                      .animate().fadeIn(duration: 400.ms, delay: 500.ms),
                ),
                SliverToBoxAdapter(
                  child: AchievementCard(
                    currentLevel: data.userLevel,
                    currentXp: data.xpPoints,
                    nextLevelXp: data.nextLevelXp,
                    achievements: data.achievements,
                    onViewAllTap: () =>
                        context.push(RouteConstants.achievementsWall),
                  ).animate().fadeIn(duration: 400.ms, delay: 520.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ),

                // 10. Recent Activity Timeline
                if (data.recentActivities.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: const SectionHeader(title: 'Recent Activity Log')
                        .animate().fadeIn(duration: 400.ms, delay: 560.ms),
                  ),
                  SliverToBoxAdapter(
                    child: ActivityTileSection(
                      activities: data.recentActivities,
                    ).animate().fadeIn(duration: 400.ms, delay: 580.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                  ),
                ],

                // Bottom Margin
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),
              ],
            ),
          ),
        );
    }
  }
}
