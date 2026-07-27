import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../providers/investigation_provider.dart';
import '../widgets/case_card.dart';
import '../widgets/investigation_filter_bar.dart';

/// Investigation Cases List Screen for Forensic Laboratory.
class CaseListScreen extends ConsumerWidget {
  const CaseListScreen({super.key});

  static const List<String> _statusFilters = [
    'All',
    'In Progress',
    'Open',
    'Solved',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final state = ref.watch(investigationProvider);
    final notifier = ref.read(investigationProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Investigation Laboratory',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InvestigationFilterBar(
              statusFilters: _statusFilters,
              selectedStatus: state.selectedStatusFilter,
              onStatusSelected: (status) => notifier.filterStatus(status),
              onSearchSubmitted: (q) => notifier.search(q),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _buildCasesContent(context, ref, state, notifier, foren),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCasesContent(
    BuildContext context,
    WidgetRef ref,
    InvestigationState state,
    InvestigationNotifier notifier,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);
    final invColor = foren.investigation.t500;

    switch (state.status) {
      case InvestigationStatus.initial:
      case InvestigationStatus.loading:
        return Center(
          child: CircularProgressIndicator(color: invColor),
        );

      case InvestigationStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: foren.critical.t500, size: 48),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.errorMessage ?? 'Failed to load investigation cases.',
                style: TextStyle(color: foren.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => notifier.loadCases(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: invColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                ),
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
                'No investigation cases match criteria.',
                style: TextStyle(color: foren.textDisabled),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () {
                  notifier.filterStatus('All');
                  notifier.search('');
                },
                child: const Text('Reset Filters'),
              ),
            ],
          ),
        );

      case InvestigationStatus.refreshing:
      case InvestigationStatus.success:
        return RefreshIndicator(
          onRefresh: () => notifier.refreshCases(),
          color: invColor,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemCount: state.cases.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final caseEntity = state.cases[index];
              return CaseCard(
                caseEntity: caseEntity,
                onTap: () {
                  context.push('${RouteConstants.caseDetail}/${caseEntity.id}');
                },
                onContinueTap: () {
                  context.push('${RouteConstants.caseDetail}/${caseEntity.id}');
                },
              );
            },
          ),
        );
    }
  }
}
