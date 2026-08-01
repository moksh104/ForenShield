import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/effects/scanner_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
import '../providers/investigation_provider.dart';
import '../widgets/case_card.dart';
import '../widgets/investigation_dashboard_header.dart';
import '../widgets/investigation_filter_bar.dart';

/// Investigation Cases List Screen for Forensic Command Center.
class CaseListScreen extends ConsumerWidget {
  const CaseListScreen({super.key});

  /// Performance & Emergency Switch Compliance
  static const bool enableAdvancedEffects = true;
  static const int particleCount = 40;

  static const List<String> _statusFilters = [
    'All',
    'In Progress',
    'Open',
    'Solved',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(investigationProvider);
    final notifier = ref.read(investigationProvider.notifier);

    final Widget contentBody = Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderRadiusSm,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.biotech_outlined, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'Investigation Laboratory',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 18,
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
            child: Column(
              children: [
                // Digital Forensics Command Center Header
                if (state.cases.isNotEmpty)
                  InvestigationDashboardHeader(cases: state.cases)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0),

                const SizedBox(height: AppSpacing.md),

                // Glassmorphic Filter & Search Bar
                InvestigationFilterBar(
                  statusFilters: _statusFilters,
                  selectedStatus: state.selectedStatusFilter,
                  onStatusSelected: (status) => notifier.filterStatus(status),
                  onSearchSubmitted: (q) => notifier.search(q),
                )
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: AppSpacing.md),

                // Main Content List / States
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildCasesContent(context, ref, state, notifier),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (enableAdvancedEffects) {
      return ParticleBackground(
        numberOfParticles: particleCount,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: contentBody,
      );
    }

    return contentBody;
  }

  Widget _buildCasesContent(
    BuildContext context,
    WidgetRef ref,
    InvestigationState state,
    InvestigationNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final primaryColor = theme.colorScheme.primary;

    switch (state.status) {
      case InvestigationStatus.initial:
      case InvestigationStatus.loading:
        return Center(
          key: const ValueKey('loading'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: ScannerEffect(
                  color: primaryColor,
                  child: const Center(
                    child: Icon(Icons.biotech, size: 54, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'INITIALIZING FORENSIC SANDBOX & SCANNERS...',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        );

      case InvestigationStatus.error:
        return Center(
          key: const ValueKey('error'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GlassEffect(
              blurX: 16.0,
              blurY: 16.0,
              opacity: 0.12,
              border: Border.all(color: foren.critical.t500, width: 1.0),
              borderRadius: AppRadius.borderRadiusXl,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlowEffect(
                      glowColor: foren.critical.t500,
                      blurRadius: 24,
                      animate: true,
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: foren.critical.t500.withValues(alpha: 0.15),
                        ),
                        child: Icon(Icons.error_outline, color: foren.critical.t500, size: 48),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'FORENSIC REPOSITORY LINK FAILED',
                      style: TextStyle(
                        color: foren.critical.t500,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      state.errorMessage ?? 'Failed to load investigation cases from server.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: foren.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: invColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                      ),
                      onPressed: () => notifier.loadCases(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('RETRY UPLINK', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case InvestigationStatus.empty:
        return Center(
          key: const ValueKey('empty'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GlassEffect(
              blurX: 16.0,
              blurY: 16.0,
              opacity: 0.12,
              border: Border.all(color: AppColors.logoGold, width: 1.0),
              borderRadius: AppRadius.borderRadiusXl,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder_off_outlined, color: AppColors.logoGold, size: 48),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'NO CASES MATCHING CRITERIA',
                      style: TextStyle(
                        color: AppColors.logoGold,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton(
                      onPressed: () {
                        notifier.filterStatus('All');
                        notifier.search('');
                      },
                      child: const Text('RESET CRITERIA'),
                    ),
                  ],
                ),
              ),
            ),
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
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
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
              )
                  .animate(delay: Duration(milliseconds: 150 + (index * 60)))
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.08, end: 0);
            },
          ),
        );
    }
  }
}
