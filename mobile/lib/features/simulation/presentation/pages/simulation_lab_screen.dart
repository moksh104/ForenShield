import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/widgets/chips/difficulty_chip.dart';
import '../../../../core/widgets/chips/xp_chip.dart';
import '../../../../routes/route_constants.dart';
import '../../data/datasources/simulation_mock_data.dart';
import '../../domain/entities/simulation_scenario.dart';

class SimulationLabScreen extends StatefulWidget {
  const SimulationLabScreen({super.key});

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
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
        title: Text(
          'Cyber Simulation Lab',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HERO BANNER (Sample Scenario Showcase)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.25),
                      foren.surfaceRaised1,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.4),
                  ),
                ),
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
                        Text(
                          '${featured.estimatedMinutes} mins',
                          style: TextStyle(
                            color: foren.textSecondary,
                            fontSize: 12,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text(
                          'LAUNCH SIMULATION LAB',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // CATEGORY FILTER BAR
              Text(
                'SCENARIO CATALOG',
                style: TextStyle(
                  color: foren.textDisabled,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
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
                      label: 'Network Defense',
                      isSelected: _selectedCategory == ScenarioCategory.network,
                      onTap: () => setState(
                        () => _selectedCategory = ScenarioCategory.network,
                      ),
                    ),
                    _FilterChip(
                      label: 'Web App Sec',
                      isSelected: _selectedCategory == ScenarioCategory.webSec,
                      onTap: () => setState(
                        () => _selectedCategory = ScenarioCategory.webSec,
                      ),
                    ),
                    _FilterChip(
                      label: 'DFIR Forensic',
                      isSelected: _selectedCategory == ScenarioCategory.dfir,
                      onTap: () => setState(
                        () => _selectedCategory = ScenarioCategory.dfir,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // SCENARIO CATALOG LIST
              ...scenarios.map((scenario) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: foren.borderSubtle.withValues(alpha: 0.3),
                      ),
                    ),
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
                            Text(
                              '${scenario.estimatedMinutes}m',
                              style: TextStyle(
                                color: foren.textDisabled,
                                fontSize: 12,
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scenario.description,
                          style: TextStyle(
                            color: foren.textSecondary,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => context.push(
                              '${RouteConstants.simulationRun}/${scenario.id}',
                            ),
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                            ),
                            label: const Text('Start Scenario'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
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
        backgroundColor: foren.surfaceRaised1,
        labelStyle: TextStyle(
          color: isSelected ? primaryColor : foren.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? primaryColor
              : foren.borderSubtle.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
