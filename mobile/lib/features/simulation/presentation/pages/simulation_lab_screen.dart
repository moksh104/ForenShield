import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/components/foren_navigation.dart';
import '../../../../routes/route_constants.dart';
import '../../data/datasources/simulation_mock_data.dart';

/// Simulation Lab Screen matching exact white-theme design spec screenshot.
class SimulationLabScreen extends StatefulWidget {
  const SimulationLabScreen({super.key});

  @override
  State<SimulationLabScreen> createState() => _SimulationLabScreenState();
}

class _SimulationLabScreenState extends State<SimulationLabScreen> {
  String _selectedTab = 'All Simulations';

  static const List<String> _tabs = [
    'All Simulations',
    'Phishing',
    'Fraud',
    'Scams',
    'Malware',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurfaceVariant;
    final borderColor = colorScheme.outlineVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: ForenBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteConstants.missionControl);
              break;
            case 1:
              context.go(RouteConstants.academy);
              break;
            case 2:
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
                  const SizedBox(width: AppSpacing.xs),

                  // Brand Shield Logo Mark
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surface,
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
                                color: colorScheme.surface,
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
                  // ── 2. Title Section + My Results Button ──
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
                                'Simulation Lab',
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Outfit',
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Practice real-world cyber attacks in a safe and controlled environment.',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: AppSpacing.md),

                        // My Results Button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: AppRadius.borderRadiusSm,
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bar_chart_rounded,
                                  size: 16,
                                  color: textPrimary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'My Results',
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
                                  const SizedBox(width: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final tab = _tabs[index];
                                final isSelected = tab == _selectedTab;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedTab = tab),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : colorScheme.surface,
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
                              color: colorScheme.surface,
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

                  // ── 4. Simulations 2x2 Grid ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSimulationCard(
                                context,
                                title: 'Phishing Attack\nSimulation',
                                description:
                                    'Identify phishing emails and avoid credential theft.',
                                level: 'Beginner',
                                levelBg: const Color(0xFFEFF6FF),
                                levelColor: primaryColor,
                                iconType: _SimIconType.phishing,
                                iconBg: const Color(0xFFEFF6FF),
                                iconColor: primaryColor,
                                scenarios: '8 Scenarios',
                                duration: '15 - 20 min',
                                onTap: () {
                                  final s = SimulationMockData.scenarios.first;
                                  context.push(
                                    '${RouteConstants.simulationRun}/${s.id}',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _buildSimulationCard(
                                context,
                                title: 'QR Code Scam\nSimulation',
                                description:
                                    'Detect malicious QR codes and understand the risks.',
                                level: 'Beginner',
                                levelBg: const Color(0xFFF0FDF4),
                                levelColor: const Color(0xFF16A34A),
                                iconType: _SimIconType.qrCode,
                                iconBg: const Color(0xFFF0FDF4),
                                iconColor: const Color(0xFF16A34A),
                                scenarios: '6 Scenarios',
                                duration: '10 - 15 min',
                                onTap: () {
                                  final s = SimulationMockData.scenarios[1];
                                  context.push(
                                    '${RouteConstants.simulationRun}/${s.id}',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSimulationCard(
                                context,
                                title: 'OTP Fraud\nSimulation',
                                description:
                                    'Learn how OTP fraud happens and stay safe.',
                                level: 'Intermediate',
                                levelBg: const Color(0xFFFFF7ED),
                                levelColor: const Color(0xFFEA580C),
                                iconType: _SimIconType.otpFraud,
                                iconBg: const Color(0xFFFFF7ED),
                                iconColor: const Color(0xFFEA580C),
                                scenarios: '7 Scenarios',
                                duration: '15 - 20 min',
                                onTap: () {
                                  final s = SimulationMockData.scenarios.last;
                                  context.push(
                                    '${RouteConstants.simulationRun}/${s.id}',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _buildSimulationCard(
                                context,
                                title: 'Fake Shopping\nWebsite',
                                description:
                                    'Spot fake websites and protect your data.',
                                level: 'Intermediate',
                                levelBg: const Color(0xFFFAF5FF),
                                levelColor: const Color(0xFF9333EA),
                                iconType: _SimIconType.fakeStore,
                                iconBg: const Color(0xFFFAF5FF),
                                iconColor: const Color(0xFF9333EA),
                                scenarios: '6 Scenarios',
                                duration: '15 - 20 min',
                                onTap: () {
                                  final s = SimulationMockData.scenarios.first;
                                  context.push(
                                    '${RouteConstants.simulationRun}/${s.id}',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 5. Your Progress Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Progress',
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
                        color: colorScheme.surface,
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildProgressMetric(
                            context,
                            icon: Icons.sports_esports_outlined,
                            iconBg: const Color(0xFFEFF6FF),
                            iconColor: primaryColor,
                            value: '12',
                            label: 'Simulations\nCompleted',
                          ),
                          _buildVerticalDivider(borderColor),
                          _buildProgressMetric(
                            context,
                            icon: Icons.emoji_events_outlined,
                            iconBg: const Color(0xFFF0FDF4),
                            iconColor: const Color(0xFF16A34A),
                            value: '85%',
                            label: 'Average\nScore',
                          ),
                          _buildVerticalDivider(borderColor),
                          _buildProgressMetric(
                            context,
                            icon: Icons.local_fire_department_outlined,
                            iconBg: const Color(0xFFFFF7ED),
                            iconColor: const Color(0xFFEA580C),
                            value: '7',
                            label: 'Current\nStreak',
                          ),
                          _buildVerticalDivider(borderColor),
                          _buildProgressMetric(
                            context,
                            icon: Icons.military_tech_outlined,
                            iconBg: const Color(0xFFFAF5FF),
                            iconColor: const Color(0xFF9333EA),
                            value: '3',
                            label: 'Badges\nEarned',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── 6. Recent Simulations Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Simulations',
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
                        color: colorScheme.surface,
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildRecentSimulationRow(
                            context,
                            title: 'Phishing Attack Simulation',
                            subtitle: 'Completed on 24 Apr 2025',
                            score: '90%',
                            icon: Icons.mark_email_unread_outlined,
                            iconBg: const Color(0xFFEFF6FF),
                            iconColor: primaryColor,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: colorScheme.outlineVariant,
                          ),
                          _buildRecentSimulationRow(
                            context,
                            title: 'QR Code Scam Simulation',
                            subtitle: 'Completed on 21 Apr 2025',
                            score: '80%',
                            icon: Icons.qr_code_2_rounded,
                            iconBg: const Color(0xFFF0FDF4),
                            iconColor: const Color(0xFF16A34A),
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

  // ── Simulation Grid Card Builder ──
  Widget _buildSimulationCard(
    BuildContext context, {
    required String title,
    required String description,
    required String level,
    required Color levelBg,
    required Color levelColor,
    required _SimIconType iconType,
    required Color iconBg,
    required Color iconColor,
    required String scenarios,
    required String duration,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final colorScheme = theme.colorScheme;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurfaceVariant;
    final effectiveIconBg = iconColor.withValues(alpha: 0.15);
    final effectiveLevelBg = levelColor.withValues(alpha: 0.15);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Chevron
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: _buildSimIcon(iconType, iconColor)),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              title,
              style: TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),

            // Description
            Text(
              description,
              style: TextStyle(color: textSecondary, fontSize: 11, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Level Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: effectiveLevelBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                level,
                style: TextStyle(
                  color: levelColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Footer Metadata (Scenarios | Duration)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 13,
                      color: textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      scenarios,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 10.5,
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
                      size: 13,
                      color: textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      duration,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 10.5,
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
    );
  }

  Widget _buildSimIcon(_SimIconType type, Color iconColor) {
    switch (type) {
      case _SimIconType.phishing:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.mail_outline_rounded, size: 24, color: iconColor),
            Positioned(
              top: 2,
              right: 2,
              child: Icon(Icons.phishing, size: 14, color: iconColor),
            ),
          ],
        );
      case _SimIconType.qrCode:
        return Icon(Icons.qr_code_2_rounded, size: 26, color: iconColor);
      case _SimIconType.otpFraud:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.smartphone_outlined, size: 26, color: iconColor),
            Icon(Icons.lock_outline_rounded, size: 12, color: iconColor),
          ],
        );
      case _SimIconType.fakeStore:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 24, color: iconColor),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.warning_amber_rounded,
                size: 14,
                color: iconColor,
              ),
            ),
          ],
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
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurfaceVariant;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(child: Icon(icon, size: 18, color: iconColor)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              color: textPrimary,
              fontSize: 17,
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

  // ── Recent Simulation Item ──
  Widget _buildRecentSimulationRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String score,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurfaceVariant;

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
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(child: Icon(icon, size: 18, color: iconColor)),
          ),
          const SizedBox(width: AppSpacing.md),
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
          const SizedBox(width: AppSpacing.sm),

          // Score Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              score,
              style: const TextStyle(
                color: Color(0xFF16A34A),
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

enum _SimIconType { phishing, qrCode, otpFraud, fakeStore }
