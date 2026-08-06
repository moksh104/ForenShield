import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/repositories/leaderboard_repository.dart';
import '../../providers/leaderboard_providers.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/leaderboard_tile.dart';

/// Main Leaderboard Screen with All Time / Weekly / Monthly tabs.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _periods = ['all', 'weekly', 'monthly'];
  static const _tabLabels = ['All Time', 'Weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: foren.textSecondary,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          tabs: _tabLabels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _periods.map((period) {
          return _LeaderboardTab(period: period);
        }).toList(),
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  final String period;

  const _LeaderboardTab({required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final leaderboardAsync = ref.watch(leaderboardProvider(period));

    return leaderboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        message: err.toString(),
        onRetry: () => ref.invalidate(leaderboardProvider(period)),
      ),
      data: (LeaderboardResult result) {
        if (result.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.leaderboard_rounded,
                    size: 64, color: foren.textDisabled),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No leaderboard data yet',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Complete lessons and investigations to earn XP!',
                  style: TextStyle(
                    color: foren.textDisabled,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(leaderboardProvider(period));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: result.entries.length + 1, // +1 for the user card
            itemBuilder: (context, index) {
              if (index == 0) {
                // Current user stats card
                if (result.currentUser != null) {
                  return LeaderboardCard(
                    entry: result.currentUser!,
                    myRank: result.myRank,
                    totalPlayers: result.totalPlayers,
                  );
                }
                return const SizedBox.shrink();
              }

              final entry = result.entries[index - 1];
              final isMe = result.currentUser != null &&
                  entry.userId == result.currentUser!.userId;

              return LeaderboardTile(
                entry: entry,
                isCurrentUser: isMe,
              );
            },
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final foren =
        Theme.of(context).extension<ForenColors>() ?? ForenColors.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48, color: foren.critical.t300),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load leaderboard',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: foren.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
