import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../providers/achievement_providers.dart';
import '../widgets/achievement_card.dart';
import 'dart:async';

class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  Timer? _debounce;

  // Categories as defined in migrations
  static const _categories = [
    'all',
    'mission',
    'academy',
    'investigation',
    'reports',
    'streak',
    'xp',
  ];
  static const _tabLabels = [
    'All',
    'Missions',
    'Academy',
    'Investigations',
    'Reports',
    'Streak',
    'XP',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
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
                  hintText: 'Search achievements...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
                onChanged: _onSearchChanged,
              )
            : const Text('Achievements'),
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
        children: _categories.map((cat) {
          return _AchievementTab(category: cat, searchQuery: _searchQuery);
        }).toList(),
      ),
    );
  }
}

class _AchievementTab extends ConsumerStatefulWidget {
  final String category;
  final String searchQuery;

  const _AchievementTab({required this.category, required this.searchQuery});

  @override
  ConsumerState<_AchievementTab> createState() => _AchievementTabState();
}

class _AchievementTabState extends ConsumerState<_AchievementTab> {
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
      final args = AchievementNotifierArgs(widget.category, widget.searchQuery);
      ref.read(achievementProvider(args).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    final args = AchievementNotifierArgs(widget.category, widget.searchQuery);
    final achievementAsync = ref.watch(achievementProvider(args));

    return achievementAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: foren.critical.t300,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Failed to load achievements',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => ref.invalidate(achievementProvider(args)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.military_tech_rounded,
                  size: 64,
                  color: foren.textDisabled,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No achievements found',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(achievementProvider(args));
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: entries.length + 1, // +1 for loading indicator
            itemBuilder: (context, index) {
              if (index >= entries.length) {
                final notifier = ref.read(achievementProvider(args).notifier);
                if (notifier.hasMore) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              }

              final entry = entries[index];
              return AchievementCard(achievement: entry);
            },
          ),
        );
      },
    );
  }
}
