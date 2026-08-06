import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../../core/components/foren_navigation.dart';
import '../../domain/entities/investigation_entity.dart';
import '../providers/investigation_provider.dart';

/// Investigation Lab Cases Screen matching exact white-theme design spec screenshot.
class CaseListScreen extends ConsumerStatefulWidget {
  const CaseListScreen({super.key});

  @override
  ConsumerState<CaseListScreen> createState() => _CaseListScreenState();
}

class _CaseListScreenState extends ConsumerState<CaseListScreen> {
  static const List<String> _tabs = [
    'All Cases',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? AppColors.borderSubtle
        : const Color(0xFFE2E8F0);
    final foren = theme.extension<ForenColors>()!;

    final state = ref.watch(investigationProvider);
    final notifier = ref.read(investigationProvider.notifier);

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFFAFAFC),
      bottomNavigationBar: ForenBottomNav(
        currentIndex: 3,
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
              break;
            case 4:
              context.go(RouteConstants.profile);
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
                    color: textPrimary,
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RouteConstants.missionControl);
                      }
                    },
                  ),
                  const SizedBox(width: 4),

                  // Brand Shield Logo Mark
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.surface
                          : AppColors.lightSurface,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primary, Color(0xFF1D4ED8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              Text(
                                'F',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Brand Name + Tagline
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'FOREN',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            'SHIELD',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'LEARN · INVESTIGATE · DEFEND',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Search Button
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.search_rounded,
                        size: 22,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Notification Bell
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.settings),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.notifications_none_outlined,
                            size: 22,
                            color: textPrimary,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? theme.scaffoldBackgroundColor
                                    : Colors.white,
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
                  // ── 2. Title Section + My Cases Button ──
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
                                'Investigation Lab',
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Outfit',
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Analyze digital evidence, build timelines and solve real-world cyber cases.',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // My Cases Button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surface : Colors.white,
                              borderRadius: AppRadius.borderRadiusSm,
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.folder_open_outlined,
                                  size: 16,
                                  color: textPrimary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'My Cases',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 13,
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

                  // ── 3. Category Filter Bar (Tabs + Filter) ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 38,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _tabs.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final tab = _tabs[index];
                                final isSelected =
                                    tab == state.selectedStatusFilter;
                                return GestureDetector(
                                  onTap: () => notifier.filterStatus(tab),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : (isDark
                                                ? AppColors.surface
                                                : Colors.white),
                                      borderRadius: AppRadius.borderRadiusSm,
                                      border: Border.all(
                                        color: isSelected
                                            ? primaryColor
                                            : borderColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        tab,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : textSecondary,
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Filter Button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surface : Colors.white,
                              borderRadius: AppRadius.borderRadiusSm,
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_outlined,
                                  size: 16,
                                  color: textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
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

                  // ── 4. Cases List View ──
                  _buildCasesContent(context, state, notifier, foren),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 5. Your Investigation Progress Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Investigation Progress',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surface : Colors.white,
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(color: borderColor),
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
                      child: Row(
                        children: [
                          _buildProgressMetric(
                            context,
                            icon: Icons.folder_outlined,
                            iconBg: const Color(0xFFEFF6FF),
                            iconColor: primaryColor,
                            value: '8',
                            label: 'Cases\nSolved',
                          ),
                          _buildVerticalDivider(borderColor),
                          _buildProgressMetric(
                            context,
                            icon: Icons.check_circle_outline,
                            iconBg: const Color(0xFFF0FDF4),
                            iconColor: const Color(0xFF16A34A),
                            value: '52',
                            label: 'Evidence\nFound',
                          ),
                          _buildVerticalDivider(borderColor),
                          _buildProgressMetric(
                            context,
                            icon: Icons.access_time_rounded,
                            iconBg: const Color(0xFFFFF7ED),
                            iconColor: const Color(0xFFEA580C),
                            value: '12h 30m',
                            label: 'Total\nTime',
                            isSmallValueText: true,
                          ),
                          _buildVerticalDivider(borderColor),
                          _buildProgressMetric(
                            context,
                            icon: Icons.military_tech_outlined,
                            iconBg: const Color(0xFFFAF5FF),
                            iconColor: const Color(0xFF9333EA),
                            value: '4',
                            label: 'Badges\nEarned',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 6. Recent Activity Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Activity',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surface : Colors.white,
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildRecentActivityRow(
                            context,
                            title: 'Completed: Phishing Email Analysis',
                            subtitle: 'Score: 85% • 24 Apr 2025',
                            score: '85%',
                            icon: Icons.check_circle_outline,
                            iconBg: const Color(0xFFF0FDF4),
                            iconColor: const Color(0xFF16A34A),
                            badgeBg: const Color(0xFFF0FDF4),
                            badgeTextColor: const Color(0xFF16A34A),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark
                                ? AppColors.borderSubtle
                                : const Color(0xFFF1F5F9),
                          ),
                          _buildRecentActivityRow(
                            context,
                            title: 'Started: USB Forensics Investigation',
                            subtitle: '24 Apr 2025',
                            score: '60%',
                            icon: Icons.folder_open_outlined,
                            iconBg: const Color(0xFFEFF6FF),
                            iconColor: primaryColor,
                            badgeBg: const Color(0xFFEFF6FF),
                            badgeTextColor: primaryColor,
                          ),
                        ],
                      ),
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

  Widget _buildCasesContent(
    BuildContext context,
    InvestigationState state,
    InvestigationNotifier notifier,
    ForenColors foren,
  ) {
    final primaryColor = AppColors.primary;

    switch (state.status) {
      case InvestigationStatus.initial:
      case InvestigationStatus.loading:
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        );

      case InvestigationStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: foren.critical.t500, size: 48),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.errorMessage ?? 'Failed to load cases.',
                style: TextStyle(color: foren.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => notifier.loadCases(),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case InvestigationStatus.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_off_outlined,
                color: foren.textDisabled,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No cases found matching criteria.',
                style: TextStyle(color: foren.textDisabled),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () {
                  notifier.filterStatus('All');
                  notifier.search('');
                },
                child: const Text('Reset filters'),
              ),
            ],
          ),
        );

      case InvestigationStatus.refreshing:
      case InvestigationStatus.success:
        return Column(
          children: state.cases.map((c) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: _buildCaseCard(context, c),
            );
          }).toList(),
        );
    }
  }

  // ── Case Card Item ──
  Widget _buildCaseCard(BuildContext context, CaseEntity c) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);
    final foren = theme.extension<ForenColors>()!;

    final config = _getCaseConfig(c.title, c.difficulty);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(
          color: isDark ? foren.borderSubtle : const Color(0xFFE2E8F0),
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
      child: InkWell(
        onTap: () => context.push('${RouteConstants.caseDetail}/${c.id}'),
        borderRadius: AppRadius.borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left Topic Icon Container ──
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: config.iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: _buildCaseIcon(config.iconType, config.iconColor),
                ),
              ),
              const SizedBox(width: 14),

              // ── Middle Column ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Case Tag (e.g. Case #01)
                    Text(
                      c.caseCode.isNotEmpty ? c.caseCode : 'Case #01',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Title
                    Text(
                      c.title,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    // Subtitle / Description
                    Text(
                      c.description,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 11.5,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Footer Metadata (Evidence Items | Time)
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              size: 14,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${c.evidenceList.isNotEmpty ? c.evidenceList.length : (c.title.contains("USB")
                                        ? 5
                                        : c.title.contains("Phishing")
                                        ? 6
                                        : c.title.contains("Network")
                                        ? 7
                                        : 5)} Evidence Items',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              config.durationStr,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // ── Right Column: Level Badge + Progress Text + Chevron ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: config.badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      c.difficulty,
                      style: TextStyle(
                        color: config.badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Progress Row + Chevron
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(c.progress * 100).toInt()}%',
                            style: TextStyle(
                              color: config.progressColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            'Progress',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseIcon(_CaseIconType type, Color iconColor) {
    switch (type) {
      case _CaseIconType.usb:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.folder_open_outlined, size: 28, color: iconColor),
            Icon(Icons.lock_outline_rounded, size: 14, color: iconColor),
          ],
        );
      case _CaseIconType.phishing:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.mail_outline_rounded, size: 26, color: iconColor),
            Positioned(
              top: 2,
              right: 2,
              child: Icon(Icons.phishing, size: 14, color: iconColor),
            ),
          ],
        );
      case _CaseIconType.network:
        return Icon(Icons.desktop_windows_outlined, size: 28, color: iconColor);
      case _CaseIconType.mobile:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.smartphone_outlined, size: 26, color: iconColor),
            Positioned(
              bottom: 2,
              right: 2,
              child: Icon(Icons.search, size: 14, color: iconColor),
            ),
          ],
        );
    }
  }

  _CaseConfig _getCaseConfig(String title, String difficulty) {
    final t = title.toLowerCase();
    if (t.contains('usb')) {
      return const _CaseConfig(
        iconType: _CaseIconType.usb,
        iconBg: Color(0xFFEFF6FF),
        iconColor: Color(0xFF2563EB),
        badgeBg: Color(0xFFEFF6FF),
        badgeColor: Color(0xFF2563EB),
        progressColor: Color(0xFF2563EB),
        durationStr: '45 - 60 min',
      );
    } else if (t.contains('phishing')) {
      return const _CaseConfig(
        iconType: _CaseIconType.phishing,
        iconBg: Color(0xFFF0FDF4),
        iconColor: Color(0xFF16A34A),
        badgeBg: Color(0xFFF0FDF4),
        badgeColor: Color(0xFF16A34A),
        progressColor: Color(0xFF16A34A),
        durationStr: '30 - 45 min',
      );
    } else if (t.contains('network')) {
      return const _CaseConfig(
        iconType: _CaseIconType.network,
        iconBg: Color(0xFFFFF7ED),
        iconColor: Color(0xFFEA580C),
        badgeBg: Color(0xFFFFF7ED),
        badgeColor: Color(0xFFEA580C),
        progressColor: Color(0xFFEA580C),
        durationStr: '60 - 90 min',
      );
    } else {
      return const _CaseConfig(
        iconType: _CaseIconType.mobile,
        iconBg: Color(0xFFFAF5FF),
        iconColor: Color(0xFF9333EA),
        badgeBg: Color(0xFFFAF5FF),
        badgeColor: Color(0xFF9333EA),
        progressColor: Color(0xFF9333EA),
        durationStr: '45 - 60 min',
      );
    }
  }

  // ── Progress Metric Item ──
  Widget _buildProgressMetric(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
    bool isSmallValueText = false,
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

    return Expanded(
      child: Column(
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
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textPrimary,
              fontSize: isSmallValueText ? 14 : 17,
              fontWeight: FontWeight.w800,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: textSecondary, fontSize: 10, height: 1.2),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(Color color) {
    return Container(width: 1, height: 48, color: color);
  }

  // ── Recent Activity Row ──
  Widget _buildRecentActivityRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String score,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color badgeBg,
    required Color badgeTextColor,
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
    final effectiveBadgeBg = isDark
        ? badgeTextColor.withValues(alpha: 0.15)
        : badgeBg;

    return Padding(
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
                    fontWeight: FontWeight.w700,
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
          const SizedBox(width: 8),

          // Score / Progress Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: effectiveBadgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              score,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 6),
          Icon(Icons.chevron_right_rounded, size: 18, color: textSecondary),
        ],
      ),
    );
  }
}

enum _CaseIconType { usb, phishing, network, mobile }

class _CaseConfig {
  final _CaseIconType iconType;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeColor;
  final Color progressColor;
  final String durationStr;

  const _CaseConfig({
    required this.iconType,
    required this.iconBg,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeColor,
    required this.progressColor,
    required this.durationStr,
  });
}
