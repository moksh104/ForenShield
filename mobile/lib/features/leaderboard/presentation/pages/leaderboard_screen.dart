import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../providers/leaderboard_providers.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/leaderboard_tile.dart';
import 'dart:async';

/// Main Leaderboard Screen with 5 tabs and Search.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  Timer? _debounce;

  static const _periods = [
    'all',
    'weekly',
    'monthly',
    'investigators',
    'learners',
  ];
  static const _tabLabels = [
    'All Time',
    'Weekly',
    'Monthly',
    'Investigators',
    'Learners',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = query;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search user, #rank, >xp...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
                onChanged: _onSearchChanged,
              )
            : const Text('Leaderboard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: foren.textSecondary,
          isScrollable: true,
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
          return _LeaderboardTab(period: period, searchQuery: _searchQuery);
        }).toList(),
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerStatefulWidget {
  final String period;
  final String searchQuery;

  const _LeaderboardTab({required this.period, required this.searchQuery});

  @override
  ConsumerState<_LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends ConsumerState<_LeaderboardTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final args = LeaderboardNotifierArgs(widget.period, widget.searchQuery);
      ref.read(leaderboardProvider(args).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    final args = LeaderboardNotifierArgs(widget.period, widget.searchQuery);
    final leaderboardAsync = ref.watch(leaderboardProvider(args));
    final profileAsync = ref.watch(profileRankProvider);

    return leaderboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        message: err.toString(),
        onRetry: () => ref.invalidate(leaderboardProvider(args)),
      ),
      data: (entries) {
        if (entries.isEmpty && widget.searchQuery.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.leaderboard_rounded,
                  size: 64,
                  color: foren.textDisabled,
                ),
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
                  style: TextStyle(color: foren.textDisabled, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(leaderboardProvider(args));
            ref.invalidate(profileRankProvider);
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount:
                entries.length +
                (widget.searchQuery.isEmpty ? 1 : 0) +
                1, // +1 for loading indicator
            itemBuilder: (context, index) {
              if (widget.searchQuery.isEmpty && index == 0) {
                // Profile Rank Card
                return profileAsync.when(
                  data: (profile) {
                    if (profile.currentUser != null) {
                      return LeaderboardCard(
                        entry: profile.currentUser!,
                        myRank: profile.currentUser!.rank,
                        totalPlayers: profile.totalPlayers,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                );
              }

              final itemIndex = widget.searchQuery.isEmpty ? index - 1 : index;

              if (itemIndex >= entries.length) {
                final notifier = ref.read(leaderboardProvider(args).notifier);
                if (notifier.hasMore) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              }

              final entry = entries[itemIndex];
              final isMe =
                  profileAsync.value?.currentUser?.userId == entry.userId;

              return LeaderboardTile(entry: entry, isCurrentUser: isMe);
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
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: foren.critical.t300,
            ),
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
