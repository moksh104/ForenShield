import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../../core/components/foren_navigation.dart';
import '../providers/mission_control_provider.dart';
import '../../providers/cisa_kev_provider.dart';
import '../../domain/entities/mission_control_entity.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/kev_threat_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Mission Control Home Screen matching exact white-theme design spec.
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
      body: SafeArea(child: _buildBody(context, state, notifier)),
      bottomNavigationBar: ForenBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.go(RouteConstants.academy);
              break;
            case 2:
              context.go(RouteConstants.simulation);
              break;
            case 3:
              context.go(RouteConstants.investigation);
              break;
            case 4:
              context.go(RouteConstants.profile);
              break;
          }
        },
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
        return const Center(child: CircularProgressIndicator(strokeWidth: 2.5));

      case MissionControlStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: foren.critical.t500, size: 48),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Unable to load dashboard',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  state.errorMessage ?? 'Please try again.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foren.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: () => notifier.loadDashboard(),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case MissionControlStatus.empty:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.space_dashboard_outlined,
                  color: foren.textDisabled,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No telemetry yet',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () => notifier.refreshDashboard(),
                  icon: const Icon(Icons.sync, size: 16),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
        );

      case MissionControlStatus.refreshing:
      case MissionControlStatus.success:
        final data = state.data;
        if (data == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: () => notifier.refreshDashboard(),
          color: theme.colorScheme.primary,
          child: _buildDashboardContent(context, data),
        );
    }
  }

  Widget _buildDashboardContent(BuildContext context, dynamic data) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;
    final entity = data as MissionControlEntity;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.zero,
      children:
          [
                // ── 1. Header ──
                DashboardHeader(
                  userName: entity.userName,
                  avatarUrl: entity.userAvatarUrl,
                  rankTitle: entity.rankTitle,
                  unreadNotifications: entity.notifications
                      .where((n) => n.isUnread)
                      .length,
                  onNotificationTap: () =>
                      context.push(RouteConstants.notifications),
                  onSearchTap: () {},
                  onProfileTap: () => context.push(RouteConstants.profile),
                ),
                const SizedBox(height: AppSpacing.md),

                // ── 2. Hero Banner (User Identity + Operational State) ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: AppRadius.borderRadiusLg,
                      border: Border.all(color: foren.borderSubtle),
                      boxShadow: theme.brightness == Brightness.dark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back, ',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Outfit',
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Container(
                                width: 32,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Rank:  • Level \\nXP:  / ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: foren.textSecondary,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                onPressed: () =>
                                    context.push(RouteConstants.academy),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.borderRadiusMd,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Continue Learning',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        SizedBox(
                          width: 140,
                          height: 130,
                          child: CustomPaint(
                            painter: _WelcomeIllustrationPainter(
                              primaryColor: colorScheme.primary,
                              isDark: theme.brightness == Brightness.dark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── 3. Threat / Case Summary ──
                _buildKevSection(context),
                const SizedBox(height: AppSpacing.xl),

                // ── 4. Progress / XP ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: AppRadius.borderRadiusLg,
                      border: Border.all(color: foren.borderSubtle),
                      boxShadow: theme.brightness == Brightness.dark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learning Progress',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            SizedBox(
                              width: 58,
                              height: 58,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 58,
                                    height: 58,
                                    child: CircularProgressIndicator(
                                      value: entity.courseCompletionPercentage,
                                      strokeWidth: 5.5,
                                      backgroundColor: foren.surfaceRaised1,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '%',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entity.currentCourseTitle.isNotEmpty
                                        ? entity.currentCourseTitle
                                        : 'No active course',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    entity.currentModuleTitle.isNotEmpty
                                        ? entity.currentModuleTitle
                                        : 'Start learning today.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: foren.textSecondary,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: entity.courseCompletionPercentage,
                                      minHeight: 4,
                                      backgroundColor: foren.surfaceRaised1,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () =>
                                  context.push(RouteConstants.profileStats),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  borderRadius: AppRadius.borderRadiusMd,
                                  border: Border.all(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bar_chart_rounded,
                                      size: 20,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Stats',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: colorScheme.primary,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── 5. Active Work / Investigations ──
                if (entity.activeCaseTitle.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Text(
                      'Active Investigation',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: GestureDetector(
                      onTap: () => context.push(RouteConstants.investigation),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: AppRadius.borderRadiusLg,
                          border: Border.all(color: foren.borderSubtle),
                          boxShadow: theme.brightness == Brightness.dark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: foren.warning.t500.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search_rounded,
                                color: foren.warning.t500,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entity.activeCaseTitle,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ' •  evidence collected',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: foren.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: foren.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // ── 6. Recent Activity Section ──
                if (entity.recentActivities.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Text(
                      'Recent Activity',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(color: foren.borderSubtle),
                      ),
                      child: Column(
                        children: entity.recentActivities.take(3).map((
                          activity,
                        ) {
                          final isLast =
                              activity == entity.recentActivities.take(3).last;
                          return Column(
                            children: [
                              _buildActivityRow(
                                context,
                                title: activity.title,
                                subtitle: activity.subtitle,
                                time: activity.timestamp,
                                icon: Icons
                                    .history, // Should ideally map activity.iconName
                                iconBg: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                iconColor: colorScheme.primary,
                              ),
                              if (!isLast)
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: foren.borderSubtle,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ]
              .animate(interval: 50.ms)
              .fade(duration: 400.ms, curve: Curves.easeOutCubic)
              .slideY(
                begin: 0.05,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }

  // ── CISA KEV Section ─────────────────────────────────────────────────────

  Widget _buildKevSection(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final cs = theme.colorScheme;
    final kevState = ref.watch(cisaKevProvider);
    final kevNotifier = ref.read(cisaKevProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: foren.critical.t500,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Live Threat Intelligence',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
              // Subtitle badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: foren.critical.t500.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'CISA KEV',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foren.critical.t500,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Known exploited vulnerabilities from the official CISA catalog',
            style: theme.textTheme.bodySmall?.copyWith(
              color: foren.textSecondary,
              fontSize: 11,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // ── Content by status ───────────────────────────────────────────
        switch (kevState.status) {
          CisaKevStatus.initial || CisaKevStatus.loading => const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
          ),

          CisaKevStatus.error when !kevState.hasData => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.borderRadiusLg,
                border: Border.all(color: foren.borderSubtle),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    color: foren.textDisabled,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No live threat data available.',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          kevState.errorMessage ??
                              'Unable to load live threat intelligence.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: foren.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => kevNotifier.refresh(),
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: cs.primary,
                      size: 20,
                    ),
                    tooltip: 'Retry',
                  ),
                ],
              ),
            ),
          ),

          // Success or refreshing (with or without stale-cache error banner)
          _ => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stale cache / error banner (shown only when has data + error)
              if (kevState.status == CisaKevStatus.error && kevState.hasData)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: foren.warning.t500.withValues(alpha: 0.08),
                      borderRadius: AppRadius.borderRadiusMd,
                      border: Border.all(
                        color: foren.warning.t500.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 14,
                          color: foren.warning.t500,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            kevState.errorMessage ??
                                'Unable to load live threat intelligence. Showing cached data.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: foren.warning.t500,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Horizontal scrolling KEV cards
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  itemCount: kevState.entries.length,
                  separatorBuilder: (context, _) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    return KevThreatCard(entry: kevState.entries[index]);
                  },
                ),
              ),
            ],
          ),
        },
      ],
    );
  }

  // ── Activity Row Builder ──
  Widget _buildActivityRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;
    final effectiveIconBg = theme.brightness == Brightness.dark
        ? iconColor.withValues(alpha: 0.15)
        : iconBg;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: effectiveIconBg,
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, size: 18, color: iconColor)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: foren.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foren.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: foren.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom Painter for Welcome Banner Vector Art ──
class _WelcomeIllustrationPainter extends CustomPainter {
  final Color primaryColor;
  final bool isDark;

  _WelcomeIllustrationPainter({
    required this.primaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final fillPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final subtlePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw Laptop Outline
    final laptopRect = RRect.fromLTRBR(
      35,
      25,
      115,
      80,
      const Radius.circular(6),
    );
    canvas.drawRRect(laptopRect, fillPaint);
    canvas.drawRRect(laptopRect, outlinePaint);

    // Laptop Stand / Keyboard Base
    final baseLine = Path()
      ..moveTo(25, 80)
      ..lineTo(125, 80)
      ..lineTo(120, 85)
      ..lineTo(30, 85)
      ..close();
    canvas.drawPath(baseLine, fillPaint);
    canvas.drawPath(baseLine, outlinePaint);

    // Shield Emblem on Laptop Screen
    final shieldPath = Path()
      ..moveTo(75, 33)
      ..lineTo(92, 33)
      ..lineTo(92, 53)
      ..quadraticBezierTo(75, 68, 75, 68)
      ..quadraticBezierTo(58, 53, 58, 33)
      ..close();
    canvas.drawPath(shieldPath, outlinePaint);

    // 'F' on Shield
    const textStyle = TextStyle(
      color: AppColors.primary,
      fontSize: 14,
      fontWeight: FontWeight.w900,
      fontFamily: 'Outfit',
    );
    final textPainter = TextPainter(
      text: const TextSpan(text: 'F', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(71, 40));

    // Books stack behind laptop
    final book1 = RRect.fromLTRBR(95, 60, 135, 70, const Radius.circular(2));
    final book2 = RRect.fromLTRBR(90, 70, 138, 80, const Radius.circular(2));
    canvas.drawRRect(book1, subtlePaint);
    canvas.drawRRect(book2, subtlePaint);

    // Graduation cap on top of books
    final capPath = Path()
      ..moveTo(115, 45)
      ..lineTo(132, 52)
      ..lineTo(115, 59)
      ..lineTo(98, 52)
      ..close();
    canvas.drawPath(capPath, subtlePaint);

    // Plant Pot on left
    final potPath = Path()
      ..moveTo(15, 70)
      ..lineTo(25, 70)
      ..lineTo(23, 85)
      ..lineTo(17, 85)
      ..close();
    canvas.drawPath(potPath, subtlePaint);

    // Floating Plus / Crosses
    canvas.drawLine(const Offset(45, 12), const Offset(51, 12), subtlePaint);
    canvas.drawLine(const Offset(48, 9), const Offset(48, 15), subtlePaint);

    canvas.drawLine(const Offset(135, 20), const Offset(141, 20), subtlePaint);
    canvas.drawLine(const Offset(138, 17), const Offset(138, 23), subtlePaint);

    // Small Dots
    canvas.drawCircle(const Offset(65, 10), 1.5, subtlePaint);
    canvas.drawCircle(const Offset(120, 12), 1.5, subtlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
