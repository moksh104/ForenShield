import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/achievement_model.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../providers/achievement_providers.dart';
import '../widgets/achievement_dialog.dart';
import '../widgets/achievement_grid.dart';

/// Achievement screen with filter (All / Unlocked / Locked) and grid display.
class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen> {
  String _filter = 'all'; // all | unlocked | locked

  List<AchievementModel> _applyFilter(List<AchievementModel> all) {
    switch (_filter) {
      case 'unlocked':
        return all.where((a) => a.unlocked).toList();
      case 'locked':
        return all.where((a) => !a.unlocked).toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: false,
      ),
      body: achievementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: foren.critical.t300),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Failed to load achievements',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                err.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: foren.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(achievementsProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (AchievementResult result) {
          final filtered = _applyFilter(result.achievements);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(achievementsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // Stats Header
                _StatsHeader(
                  unlockedCount: result.unlockedCount,
                  total: result.total,
                  totalXp: result.totalXpEarned,
                ),
                const SizedBox(height: AppSpacing.md),

                // Filter Chips
                Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _filter == 'all',
                      onTap: () => setState(() => _filter = 'all'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      label: 'Unlocked',
                      isSelected: _filter == 'unlocked',
                      onTap: () => setState(() => _filter = 'unlocked'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      label: 'Locked',
                      isSelected: _filter == 'locked',
                      onTap: () => setState(() => _filter = 'locked'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Grid
                if (filtered.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      child: Column(
                        children: [
                          Icon(Icons.emoji_events_rounded,
                              size: 48, color: foren.textDisabled),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            _filter == 'unlocked'
                                ? 'No achievements unlocked yet'
                                : 'No locked achievements remaining',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  AchievementGrid(
                    achievements: filtered,
                    onAchievementTap: (achievement) {
                      AchievementDialog.show(context, achievement);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final int unlockedCount;
  final int total;
  final int totalXp;

  const _StatsHeader({
    required this.unlockedCount,
    required this.total,
    required this.totalXp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final progress = total > 0 ? unlockedCount / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.12),
            theme.colorScheme.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$unlockedCount / $total',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Unlocked',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$totalXp',
                    style: TextStyle(
                      color: foren.success.t300,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'XP Earned',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: foren.surfaceRaised1,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
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
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : foren.borderDefault,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.primary
                : foren.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
