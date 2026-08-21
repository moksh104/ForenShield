import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/components/foren_navigation.dart';
import '../../../../routes/route_constants.dart';
import '../../../../shared/widgets/foren_brand_header.dart';
import '../providers/profile_provider.dart';

/// My Profile Screen matching exact white-theme design spec screenshot.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;

    final state = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: ForenBottomNav(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteConstants.missionControl);
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
              break;
          }
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Top Header Bar: Back + Logo + Search & Notif ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.lg,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: colorScheme.onSurface,
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RouteConstants.missionControl);
                      }
                    },
                  ),
                  const SizedBox(width: AppSpacing.xs),

                  // Shared Brand Header
                  const ForenShieldBrandHeader(),

                  const Spacer(),

                  // Settings Gear Icon
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.settings),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.settings_outlined,
                        size: 22,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),

                  // Notification Bell
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.notifications),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.notifications_none_outlined,
                            size: 22,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Main Scrollable Body ──
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                children: [
                  // ── 2. Title Section + Leaderboard Button ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Profile',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Outfit',
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Track your progress, earn rewards and level up your skills.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: foren.textSecondary,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: AppSpacing.md),

                        // Leaderboard Button
                        GestureDetector(
                          onTap: () =>
                              context.push(RouteConstants.achievementsWall),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: AppRadius.borderRadiusSm,
                              border: Border.all(color: foren.borderSubtle),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bar_chart_rounded,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Leaderboard',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── 3. Profile Header Card ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(color: foren.borderSubtle),
                        boxShadow: theme.brightness == Brightness.dark
                            ? []
                            : [
                                BoxShadow(
                                  color: colorScheme.shadow.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Column(
                        children: [
                          // Top Profile Info Area
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Row(
                              children: [
                                // Avatar Circle
                                GestureDetector(
                                  onTap: () => _showAvatarOptionsBottomSheet(
                                    context,
                                    ref,
                                    state.profile?.avatarUrl ?? '',
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 68,
                                        height: 68,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFDBEAFE),
                                          image:
                                              (state
                                                      .profile
                                                      ?.avatarUrl
                                                      .isNotEmpty ??
                                                  false)
                                              ? (state.profile!.avatarUrl
                                                        .startsWith('http')
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                          state
                                                              .profile!
                                                              .avatarUrl,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : DecorationImage(
                                                        image: FileImage(
                                                          File(
                                                            state
                                                                .profile!
                                                                .avatarUrl,
                                                          ),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ))
                                              : null,
                                        ),
                                        child:
                                            (state.profile?.avatarUrl.isEmpty ??
                                                true)
                                            ? const Center(
                                                child: Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Color(0xFF3B82F6),
                                                ),
                                              )
                                            : null,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: colorScheme.surface,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: foren.borderSubtle,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 12,
                                              color: foren.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),

                                // Center Column (Name, Rank, Level progress)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.profile?.fullName.isNotEmpty ??
                                                false
                                            ? state.profile!.fullName
                                            : 'Agent',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: colorScheme.onSurface,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Outfit',
                                            ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            state.profile?.rankTitle ??
                                                'Cyber Detective',
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  color: colorScheme.primary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(width: AppSpacing.xs),
                                          Icon(
                                            Icons.verified,
                                            size: 15,
                                            color: colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Level ${state.profile?.level ?? 1}',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                              color: colorScheme.onSurface,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      // Progress Bar
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        // Progress to next level
                                        child: LinearProgressIndicator(
                                          value:
                                              state.profile != null &&
                                                  state.profile!.nextLevelXp > 0
                                              ? (state.profile!.xpPoints %
                                                        state
                                                            .profile!
                                                            .nextLevelXp) /
                                                    state.profile!.nextLevelXp
                                              : 0.0,
                                          minHeight: 5,
                                          backgroundColor: foren.surfaceRaised1,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                colorScheme.primary,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        '${state.profile?.nextLevelXp ?? 0} XP to Level ${(state.profile?.level ?? 0) + 1}',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: foren.textSecondary,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: AppSpacing.md),

                                // Right Crest / Wreath Badge
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: CustomPaint(
                                    painter: _WreathBadgePainter(
                                      primaryColor: colorScheme.primary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${state.profile?.level ?? 1}',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: colorScheme.primary,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Outfit',
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            height: 1,
                            thickness: 1,
                            color: foren.borderSubtle,
                          ),

                          // Bottom Half 4-Stat Metrics Row
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                _buildStatMetric(
                                  context,
                                  icon: Icons.star_rounded,
                                  iconColor: colorScheme.primary,
                                  value: '${state.profile?.xpPoints ?? 0}',
                                  label: 'XP Earned',
                                ),
                                _buildVerticalDivider(foren.borderSubtle),
                                _buildStatMetric(
                                  context,
                                  icon: Icons.adjust_rounded,
                                  iconColor: const Color(0xFF16A34A),
                                  value:
                                      '${state.profile?.stats.casesSolved ?? 0}',
                                  label: 'Cases Solved',
                                ),
                                _buildVerticalDivider(foren.borderSubtle),
                                _buildStatMetric(
                                  context,
                                  icon: Icons.local_fire_department_outlined,
                                  iconColor: const Color(0xFFEA580C),
                                  value:
                                      '${state.profile?.stats.currentStreakDays ?? 0}',
                                  label: 'Day Streak',
                                ),
                                _buildVerticalDivider(foren.borderSubtle),
                                _buildStatMetric(
                                  context,
                                  icon: Icons.workspace_premium_outlined,
                                  iconColor: colorScheme.primary,
                                  value:
                                      '${state.profile?.badges.where((b) => b.isUnlocked).length ?? 0}',
                                  label: 'Badges Earned',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 4. Current Rank Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Rank',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.push(RouteConstants.achievementsWall),
                          child: Text(
                            'See All Ranks',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
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
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/logos/app_logo.png',
                            width: 54,
                            height: 54,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.profile?.rankTitle ?? 'Agent',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Next Rank',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: foren.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                'Cyber Analyst',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '3,200 XP needed',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: foren.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 5. Learning Progress Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Learning Progress',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.push(RouteConstants.academyProgress),
                          child: Text(
                            'View All',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        _buildProgressMetricCard(
                          context,
                          value: '18',
                          label: 'Courses\nEnrolled',
                          primaryColor: colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _buildProgressMetricCard(
                          context,
                          value: '7',
                          label: 'Courses\nCompleted',
                          primaryColor: const Color(0xFF16A34A),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _buildProgressMetricCard(
                          context,
                          value: '12h 30m',
                          label: 'Total Learning\nTime',
                          primaryColor: const Color(0xFFEA580C),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _buildProgressMetricCard(
                          context,
                          value: '75%',
                          label: 'Overall\nProgress',
                          primaryColor: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 6. Recent Achievements Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Achievements',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.push(RouteConstants.achievementsWall),
                          child: Text(
                            'View All',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildAchievementTile(
                            context,
                            title: 'Evidence Hunter',
                            subtitle: 'Found 50 evidence items',
                            date: '24 Apr 2025',
                            icon: Icons.shield_outlined,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildAchievementTile(
                            context,
                            title: 'Phishing Expert',
                            subtitle: 'Completed 5 phishing simulations',
                            date: '22 Apr 2025',
                            icon: Icons.phishing_outlined,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildAchievementTile(
                            context,
                            title: 'Streak Master',
                            subtitle: 'Maintain a 15-day learning streak',
                            date: '20 Apr 2025',
                            icon: Icons.local_fire_department_outlined,
                            color: const Color(0xFFEA580C),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 7. Quick Actions Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Text(
                      'Quick Actions',
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
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionTile(
                            context,
                            title: 'Continue\nLearning',
                            icon: Icons.menu_book_outlined,
                            iconBg: const Color(0xFFEFF6FF),
                            iconColor: colorScheme.primary,
                            onTap: () => context.push(RouteConstants.academy),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildQuickActionTile(
                            context,
                            title: 'Go to\nLab',
                            icon: Icons.science_outlined,
                            iconBg: const Color(0xFFF0FDF4),
                            iconColor: const Color(0xFF16A34A),
                            onTap: () =>
                                context.push(RouteConstants.simulation),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildQuickActionTile(
                            context,
                            title: 'Investigate\nCases',
                            icon: Icons.search_rounded,
                            iconBg: const Color(0xFFFAF5FF),
                            iconColor: colorScheme.primary,
                            onTap: () =>
                                context.push(RouteConstants.investigation),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildQuickActionTile(
                            context,
                            title: 'View\nAnalytics',
                            icon: Icons.bar_chart_rounded,
                            iconBg: const Color(0xFFFFF7ED),
                            iconColor: const Color(0xFFEA580C),
                            onTap: () =>
                                context.push(RouteConstants.profileStats),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stat Metric Column ──
  Widget _buildStatMetric(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foren.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Progress Metric Card Builder ──
  Widget _buildProgressMetricCard(
    BuildContext context, {
    required String value,
    required String label,
    required Color primaryColor,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(color: foren.borderSubtle),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'Outfit',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foren.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Achievement Tile Builder ──
  Widget _buildAchievementTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: foren.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'Outfit',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: foren.textSecondary,
              fontSize: 9.5,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: theme.textTheme.bodySmall?.copyWith(
              color: foren.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Action Tile Builder ──
  Widget _buildQuickActionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;
    final effectiveIconBg = theme.brightness == Brightness.dark
        ? iconColor.withValues(alpha: 0.15)
        : iconBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(color: foren.borderSubtle),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: effectiveIconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider(Color color) {
    return Container(width: 1, height: 44, color: color);
  }

  void _showAvatarOptionsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String currentAvatarUrl,
  ) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final primaryColor = theme.colorScheme.primary;
    final criticalColor = foren.critical.t500;
    final hasAvatar = currentAvatarUrl.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: foren.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Profile Picture Options',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, color: primaryColor),
                title: Text(
                  'Camera',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickImageSource(context, ref, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: primaryColor,
                ),
                title: Text(
                  'Gallery',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickImageSource(context, ref, ImageSource.gallery);
                },
              ),
              if (hasAvatar)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: criticalColor),
                  title: Text(
                    'Remove Photo',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: criticalColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref.read(profileProvider.notifier).removeAvatar();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageSource(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image == null) return;

      await ref.read(profileProvider.notifier).updateAvatar(image.path);
    } catch (_) {}
  }
}

// ── Custom Wreath Crest Badge Painter ──
class _WreathBadgePainter extends CustomPainter {
  final Color primaryColor;
  _WreathBadgePainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final shieldPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final wreathPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Shield Outline
    final shieldPath = Path()
      ..moveTo(center.dx - 18, center.dy - 22)
      ..lineTo(center.dx + 18, center.dy - 22)
      ..lineTo(center.dx + 18, center.dy + 4)
      ..quadraticBezierTo(center.dx, center.dy + 22, center.dx, center.dy + 22)
      ..quadraticBezierTo(
        center.dx - 18,
        center.dy + 4,
        center.dx - 18,
        center.dy + 4,
      )
      ..close();
    canvas.drawPath(shieldPath, shieldPaint);

    // Left Wreath Branch
    final leftBranch = Path()
      ..moveTo(center.dx - 24, center.dy + 15)
      ..quadraticBezierTo(
        center.dx - 28,
        center.dy - 5,
        center.dx - 18,
        center.dy - 24,
      );
    canvas.drawPath(leftBranch, wreathPaint);

    // Right Wreath Branch
    final rightBranch = Path()
      ..moveTo(center.dx + 24, center.dy + 15)
      ..quadraticBezierTo(
        center.dx + 28,
        center.dy - 5,
        center.dx + 18,
        center.dy - 24,
      );
    canvas.drawPath(rightBranch, wreathPaint);

    // Leaves
    for (int i = 0; i < 4; i++) {
      final y = center.dy + 10 - (i * 9);
      canvas.drawCircle(Offset(center.dx - 26, y), 2, wreathPaint);
      canvas.drawCircle(Offset(center.dx + 26, y), 2, wreathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
