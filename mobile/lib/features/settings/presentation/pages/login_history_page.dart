import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/settings_model.dart';
import '../providers/login_history_provider.dart';

/// Login History Page displaying security audit log
class LoginHistoryPage extends ConsumerStatefulWidget {
  const LoginHistoryPage({super.key});

  @override
  ConsumerState<LoginHistoryPage> createState() => _LoginHistoryPageState();
}

class _LoginHistoryPageState extends ConsumerState<LoginHistoryPage> {
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
      ref.read(loginHistoryProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(loginHistoryProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final asyncHistory = ref.watch(loginHistoryProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Login Audit History'),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Security audit log of recent authentication events associated with your account credentials.',
                  style: TextStyle(color: foren.textSecondary, fontSize: 13),
                ),
              ),
            ),
            asyncHistory.when(
              data: (history) {
                if (history.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No login history found.',
                        style: TextStyle(color: foren.textSecondary),
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == history.length) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Center(
                            child:
                                ref.read(loginHistoryProvider.notifier).hasMore
                                ? const CircularProgressIndicator()
                                : Text(
                                    'End of history',
                                    style: TextStyle(
                                      color: foren.textDisabled,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        );
                      }
                      return _buildHistoryItem(
                        history[index],
                        theme,
                        foren,
                        index == history.length - 1,
                      );
                    }, childCount: history.length + 1),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: foren.critical.t500,
                      ),
                      const SizedBox(height: 16),
                      const Text('Failed to load login history.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _onRefresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    LoginHistoryModel item,
    ThemeData theme,
    ForenColors foren,
    bool isLast,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(color: foren.borderSubtle),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: item.isSuccessful
                    ? foren.success.t500.withValues(alpha: 0.15)
                    : foren.critical.t500.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.isSuccessful
                    ? Icons.check_circle_outline_rounded
                    : Icons.gpp_bad_rounded,
                color: item.isSuccessful
                    ? foren.success.t300
                    : foren.critical.t300,
                size: 20,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.device,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  item.isSuccessful ? 'SUCCESS' : 'FAILED',
                  style: TextStyle(
                    color: item.isSuccessful
                        ? foren.success.t300
                        : foren.critical.t300,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              '${item.ipAddress} · ${item.location}\n${DateFormat('MMM d, y, h:mm a').format(item.timestamp.toLocal())}',
              style: TextStyle(color: foren.textSecondary, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}
