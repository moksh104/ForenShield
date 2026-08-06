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
import '../../domain/entities/mission_control_entity.dart';
import '../widgets/dashboard_header.dart';

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
      backgroundColor: theme.brightness == Brightness.dark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFFAFAFC),
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
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);
    final primaryColor = AppColors.primary;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.zero,
      children: [
        // ── 1. Header (Logo left, Search + Notif right) ──
        DashboardHeader(
          userName: data.userName,
          avatarUrl: data.userAvatarUrl,
          rankTitle: data.rankTitle,
          unreadNotifications: data.notifications
              .where((DashboardNotification n) => n.isUnread)
              .length,
          onNotificationTap: () => context.push(RouteConstants.settings),
          onSearchTap: () {},
          onProfileTap: () => context.push(RouteConstants.profile),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── 2. Hero Banner Card ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : Colors.white,
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(
                color: isDark
                    ? AppColors.borderSubtle
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: isDark
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
                // Left Text + Button Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                            height: 1.25,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Build skills.\nInvestigate threats.\nDefend the ',
                            ),
                            TextSpan(
                              text: 'digital world.',
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 32,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your journey to becoming a\ncyber defender starts here.',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () => context.push(RouteConstants.academy),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
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

                const SizedBox(width: 8),

                // Right Vector Illustration
                SizedBox(
                  width: 140,
                  height: 130,
                  child: CustomPaint(
                    painter: _WelcomeIllustrationPainter(
                      primaryColor: primaryColor,
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── 3. Learning Progress Card ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : Colors.white,
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(
                color: isDark
                    ? AppColors.borderSubtle
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: isDark
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
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    // Circular Ring (42%)
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
                              value: 0.42,
                              strokeWidth: 5.5,
                              backgroundColor: isDark
                                  ? AppColors.surfaceRaised1
                                  : const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryColor,
                              ),
                            ),
                          ),
                          Text(
                            '42%',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Center Details Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Intermediate',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Keep going! You\'re doing great.',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: 0.42,
                              minHeight: 4,
                              backgroundColor: isDark
                                  ? AppColors.surfaceRaised1
                                  : const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(
                                  text: '24 / 57 ',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(text: 'modules completed'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // View Stats Button Right
                    GestureDetector(
                      onTap: () => context.push(RouteConstants.profileStats),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.05),
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              size: 20,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'View Stats',
                              style: TextStyle(
                                color: primaryColor,
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

        // ── 4. Quick Access Section ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Outfit',
                ),
              ),
              GestureDetector(
                onTap: () => context.push(RouteConstants.academy),
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  title: 'Learning Paths',
                  subtitle: 'Explore curated cybersecurity courses',
                  icon: Icons.menu_book_outlined,
                  onTap: () => context.push(RouteConstants.academy),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  title: 'Hands-on Labs',
                  subtitle: 'Practice with real tools in a safe environment',
                  icon: Icons.science_outlined,
                  onTap: () => context.push(RouteConstants.simulation),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  title: 'Investigations',
                  subtitle: 'Solve real-world cases and collect evidence',
                  icon: Icons.search_rounded,
                  onTap: () => context.push(RouteConstants.investigation),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  title: 'Challenges',
                  subtitle: 'Test your skills and earn badges',
                  icon: Icons.emoji_events_outlined,
                  onTap: () => context.push(RouteConstants.achievementsWall),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // ── 5. Continue Learning Section ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Continue Learning',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Outfit',
                ),
              ),
              GestureDetector(
                onTap: () => context.push(RouteConstants.academy),
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: GestureDetector(
            onTap: () => context.push(RouteConstants.academy),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : Colors.white,
                borderRadius: AppRadius.borderRadiusLg,
                border: Border.all(
                  color: isDark
                      ? AppColors.borderSubtle
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: isDark
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
                  // Dark Thumbnail
                  Container(
                    width: 86,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(86, 80),
                          painter: _ThumbnailPainter(),
                        ),
                        Icon(
                          Icons.fingerprint,
                          size: 32,
                          color: primaryColor.withValues(alpha: 0.8),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Icon(
                            Icons.search,
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Learning Path',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data.currentCourseTitle.isNotEmpty
                              ? data.currentCourseTitle
                              : 'Digital Forensics Fundamentals',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Understand the core concepts of digital forensics and evidence handling.',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 11,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: 0.60,
                            minHeight: 4,
                            backgroundColor: isDark
                                ? AppColors.surfaceRaised1
                                : const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '60% complete',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // ── 6. Recent Activity Section ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              color: textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Outfit',
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : Colors.white,
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(
                color: isDark
                    ? AppColors.borderSubtle
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                _buildActivityRow(
                  context,
                  title: 'Analyzed USB Forensics Lab',
                  subtitle: 'You completed the lab',
                  time: '2h ago',
                  icon: Icons.science_outlined,
                  iconBg: const Color(0xFFEFF6FF),
                  iconColor: primaryColor,
                  onTap: () => context.push(RouteConstants.simulation),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark
                      ? AppColors.borderSubtle
                      : const Color(0xFFF1F5F9),
                ),
                _buildActivityRow(
                  context,
                  title: 'Phishing Investigation Case #03',
                  subtitle: 'Case completed',
                  time: '1d ago',
                  icon: Icons.check_circle_rounded,
                  iconBg: const Color(0xFFF0FDF4),
                  iconColor: const Color(0xFF16A34A),
                  onTap: () => context.push(RouteConstants.investigation),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  // ── Quick Access Card Builder ──
  Widget _buildQuickAccessCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        height: 120,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : Colors.white,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: isDark ? AppColors.borderSubtle : const Color(0xFFE2E8F0),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, size: 20, color: primaryColor)),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(color: textSecondary, fontSize: 9, height: 1.2),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
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
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);
    final effectiveIconBg = isDark ? iconColor.withValues(alpha: 0.15) : iconBg;

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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(time, style: TextStyle(color: textSecondary, fontSize: 11)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 16, color: textSecondary),
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

// ── Custom Painter for Dark Thumbnail Pattern ──
class _ThumbnailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var i = 0; i < 6; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (var i = 0; i < 6; i++) {
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
