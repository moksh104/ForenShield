import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/widgets/chips/difficulty_chip.dart';
import '../../../../core/widgets/chips/xp_chip.dart';
import '../../../../routes/route_constants.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
import '../../data/datasources/simulation_mock_data.dart';
import '../../domain/entities/simulation_scenario.dart';
import '../widgets/simulation_dashboard_header.dart';

/// Premium Cyber Simulation Lab & Training Operations Environment.
class SimulationLabScreen extends StatefulWidget {
  const SimulationLabScreen({super.key});

  /// Performance & Emergency Switch Compliance
  static const bool enableAdvancedEffects = true;
  static const int particleCount = 40;

  @override
  State<SimulationLabScreen> createState() => _SimulationLabScreenState();
}

class _SimulationLabScreenState extends State<SimulationLabScreen> {
  ScenarioCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final scenarios = SimulationMockData.scenarios.where((s) {
      if (_selectedCategory == null) return true;
      return s.category == _selectedCategory;
    }).toList();

    final featured = SimulationMockData.scenarios.first;

    final Widget contentBody = Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(RouteConstants.missionControl);
          },
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderRadiusSm,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.terminal_outlined, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'Cyber Simulation Lab',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                fontFamily: 'Geist',
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundGrid()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Simulation Dashboard Telemetry Header
                  SimulationDashboardHeader(scenarios: SimulationMockData.scenarios)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0),

                  const SizedBox(height: AppSpacing.lg),

                  // 2. HERO BANNER (Featured Scenario Showcase)
                  GlassEffect(
                    blurX: 16.0,
                    blurY: 16.0,
                    opacity: 0.12,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.45),
                      width: 1.0,
                    ),
                    borderRadius: AppRadius.borderRadiusLg,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DifficultyChip(
                                level: _mapDifficulty(featured.difficulty),
                              ),
                              const SizedBox(width: 8),
                              XPChip(xp: featured.xpReward),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.logoGold.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.borderRadiusXs,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.timer_outlined, size: 11, color: AppColors.logoGold),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${featured.estimatedMinutes} MINS',
                                      style: const TextStyle(
                                        color: AppColors.logoGold,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            featured.title,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Geist',
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            featured.description,
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => context.push(
                                '${RouteConstants.simulationRun}/${featured.id}',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: theme.scaffoldBackgroundColor,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.borderRadiusMd,
                                ),
                              ),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text(
                                'LAUNCH FEATURED SIMULATION LAB',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(delay: 100.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.08, end: 0),

                  const SizedBox(height: AppSpacing.xl),

                  // 3. CATEGORY FILTER BAR
                  Text(
                    'SIMULATION SCENARIO TRACKS',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                      letterSpacing: 1.0,
                    ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.xs),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All Tracks',
                          isSelected: _selectedCategory == null,
                          onTap: () => setState(() => _selectedCategory = null),
                        ),
                        _FilterChip(
                          label: 'Phishing & Email',
                          isSelected: _selectedCategory == ScenarioCategory.network,
                          onTap: () => setState(
                            () => _selectedCategory = ScenarioCategory.network,
                          ),
                        ),
                        _FilterChip(
                          label: 'Web & QR Fraud',
                          isSelected: _selectedCategory == ScenarioCategory.webSec,
                          onTap: () => setState(
                            () => _selectedCategory = ScenarioCategory.webSec,
                          ),
                        ),
                        _FilterChip(
                          label: 'OTP Scams & Incident',
                          isSelected: _selectedCategory == ScenarioCategory.dfir,
                          onTap: () => setState(
                            () => _selectedCategory = ScenarioCategory.dfir,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // 4. SCENARIO CATALOG LIST
                  ...scenarios.asMap().entries.map((entry) {
                    final index = entry.key;
                    final scenario = entry.value;
                    final riskScore = _calculateRiskScore(scenario.difficulty);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _ScenarioCardTile(
                        scenario: scenario,
                        riskScore: riskScore,
                        onTap: () => context.push(
                          '${RouteConstants.simulationRun}/${scenario.id}',
                        ),
                      )
                          .animate(delay: Duration(milliseconds: 300 + (index * 60)))
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.08, end: 0),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (SimulationLabScreen.enableAdvancedEffects) {
      return ParticleBackground(
        numberOfParticles: SimulationLabScreen.particleCount,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: contentBody,
      );
    }

    return contentBody;
  }

  int _calculateRiskScore(ScenarioDifficulty difficulty) {
    switch (difficulty) {
      case ScenarioDifficulty.easy:
        return 42;
      case ScenarioDifficulty.medium:
        return 65;
      case ScenarioDifficulty.hard:
        return 88;
      case ScenarioDifficulty.critical:
        return 96;
    }
  }

  DifficultyLevel _mapDifficulty(ScenarioDifficulty difficulty) {
    switch (difficulty) {
      case ScenarioDifficulty.easy:
        return DifficultyLevel.beginner;
      case ScenarioDifficulty.medium:
        return DifficultyLevel.intermediate;
      case ScenarioDifficulty.hard:
        return DifficultyLevel.advanced;
      case ScenarioDifficulty.critical:
        return DifficultyLevel.expert;
    }
  }
}

class _ScenarioCardTile extends StatefulWidget {
  final SimulationScenario scenario;
  final int riskScore;
  final VoidCallback onTap;

  const _ScenarioCardTile({
    required this.scenario,
    required this.riskScore,
    required this.onTap,
  });

  @override
  State<_ScenarioCardTile> createState() => _ScenarioCardTileState();
}

class _ScenarioCardTileState extends State<_ScenarioCardTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final scenario = widget.scenario;

    final Widget cardBody = GlassEffect(
      blurX: 12.0,
      blurY: 12.0,
      opacity: 0.10,
      border: Border.all(
        color: _isHovered ? primaryColor : foren.borderSubtle,
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusLg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DifficultyChip(
                  level: _mapDifficulty(scenario.difficulty),
                ),
                const SizedBox(width: 8),
                XPChip(xp: scenario.xpReward),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.logoGold.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusXs,
                  ),
                  child: Text(
                    'RISK SCORE: ${widget.riskScore}/100',
                    style: const TextStyle(
                      color: AppColors.logoGold,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              scenario.title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'Geist',
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${scenario.objectives.length} MISSION OBJECTIVES',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: widget.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text(
                    'START LAB',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        child: SimulationLabScreen.enableAdvancedEffects
            ? GlowEffect(
                glowColor: _isHovered ? primaryColor : Colors.transparent,
                blurRadius: 16,
                spreadRadius: 1,
                animate: _isHovered,
                borderRadius: AppRadius.borderRadiusLg,
                child: cardBody,
              )
            : cardBody,
      ),
    );
  }

  DifficultyLevel _mapDifficulty(ScenarioDifficulty difficulty) {
    switch (difficulty) {
      case ScenarioDifficulty.easy:
        return DifficultyLevel.beginner;
      case ScenarioDifficulty.medium:
        return DifficultyLevel.intermediate;
      case ScenarioDifficulty.hard:
        return DifficultyLevel.advanced;
      case ScenarioDifficulty.critical:
        return DifficultyLevel.expert;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: primaryColor.withValues(alpha: 0.2),
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: isSelected ? primaryColor : foren.textSecondary,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          fontFamily: 'monospace',
        ),
        side: BorderSide(
          color: isSelected ? primaryColor : foren.borderSubtle,
        ),
        showCheckmark: false,
      ),
    );
  }
}
