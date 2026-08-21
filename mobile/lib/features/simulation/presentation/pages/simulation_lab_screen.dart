import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/components/foren_navigation.dart';
import '../../../../routes/route_constants.dart';
import '../../../../shared/widgets/foren_brand_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/states/empty_state.dart';
import '../../domain/entities/simulation_scenario.dart';
import '../../providers/simulation_provider.dart';

class SimulationLabScreen extends ConsumerStatefulWidget {
  const SimulationLabScreen({super.key});

  @override
  ConsumerState<SimulationLabScreen> createState() =>
      _SimulationLabScreenState();
}

class _SimulationLabScreenState extends ConsumerState<SimulationLabScreen> {
  String _selectedTab = 'All Scenarios';

  static const List<String> _tabs = [
    'All Scenarios',
    'Network Security',
    'Web Security',
    'DFIR',
    'Malware Analysis',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurfaceVariant;
    final borderColor = colorScheme.outlineVariant;
    final foren = theme.extension<ForenColors>()!;

    final scenariosAsync = ref.watch(simulationScenariosProvider);

    List<SimulationScenario> filteredScenarios = [];
    if (scenariosAsync.hasValue && scenariosAsync.value != null) {
      filteredScenarios = scenariosAsync.value!;
      if (_selectedTab != 'All Scenarios') {
        filteredScenarios = filteredScenarios.where((s) {
          if (_selectedTab == 'Network Security')
            return s.category == ScenarioCategory.network;
          if (_selectedTab == 'Web Security')
            return s.category == ScenarioCategory.webSec;
          if (_selectedTab == 'DFIR') {
            return s.category == ScenarioCategory.dfir;
          }
          if (_selectedTab == 'Malware Analysis')
            return s.category == ScenarioCategory.malware;
          return true;
        }).toList();
      }
    }

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
            // ── 1. Top Header Bar ──
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
                  const ForenShieldBrandHeader(),
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
                  // ── 2. Title Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
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
                  const SizedBox(height: AppSpacing.lg),

                  // ── 3. Category Filter Bar ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
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
                            onTap: () => setState(() => _selectedTab = tab),
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
                  const SizedBox(height: AppSpacing.lg),

                  // ── 4. Scenarios List ──
                  scenariosAsync.when(
                    data: (_) {
                      if (filteredScenarios.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: EmptyState(
                            title: 'No Scenarios Found',
                            message: 'Try selecting a different category.',
                            icon: Icons.search_off_rounded,
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          children: filteredScenarios.map((scenario) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _buildScenarioCard(
                                context,
                                scenario,
                                foren,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.all(40),
                      child: EmptyState(
                        title: 'Failed to load scenarios',
                        message: err.toString(),
                        icon: Icons.error_outline,
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

  Widget _buildScenarioCard(
    BuildContext context,
    SimulationScenario scenario,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color difficultyBg;
    Color difficultyText;
    String difficultyLabel;

    switch (scenario.difficulty) {
      case ScenarioDifficulty.easy:
        difficultyLabel = 'Beginner';
        difficultyBg = isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFFEFF6FF);
        difficultyText = isDark
            ? const Color(0xFF60A5FA)
            : const Color(0xFF1E3A8A);
        break;
      case ScenarioDifficulty.medium:
        difficultyLabel = 'Intermediate';
        difficultyBg = isDark
            ? const Color(0xFF431407)
            : const Color(0xFFFFF7ED);
        difficultyText = isDark
            ? const Color(0xFFF97316)
            : const Color(0xFFEA580C);
        break;
      case ScenarioDifficulty.hard:
      case ScenarioDifficulty.critical:
        difficultyLabel = scenario.difficulty == ScenarioDifficulty.critical
            ? 'Critical'
            : 'Advanced';
        difficultyBg = isDark
            ? const Color(0xFF450A0A)
            : const Color(0xFFFEF2F2);
        difficultyText = isDark
            ? const Color(0xFFF87171)
            : const Color(0xFFDC2626);
        break;
    }

    return GestureDetector(
      onTap: () {
        context.push('${RouteConstants.simulationRun}/${scenario.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(color: foren.borderSubtle),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario.title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scenario.description,
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: difficultyBg,
                    borderRadius: AppRadius.borderRadiusXs,
                  ),
                  child: Text(
                    difficultyLabel,
                    style: TextStyle(
                      color: difficultyText,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: foren.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  ' min',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                if (scenario.isCompleted) ...[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  Icon(
                    Icons.stars_rounded,
                    size: 14,
                    color: foren.academy.t500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${scenario.xpReward} XP',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: foren.textDisabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
