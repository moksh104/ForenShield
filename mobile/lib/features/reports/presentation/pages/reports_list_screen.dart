import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../providers/reports_provider.dart';
import '../widgets/reports_dashboard_header.dart';
import '../widgets/security_heat_map_widget.dart';

/// Cybersecurity analytics reports list screen.
class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final reports = ref.watch(reportsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
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
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.insights_outlined,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Security Intelligence Reports',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ref.read(reportsProvider.notifier).loadReports();
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // 1. Analytics dashboard header
              ReportsDashboardHeader(reports: reports),

              const SizedBox(height: AppSpacing.lg),

              // 2. Incident density heat map
              const SecurityHeatMapWidget(),

              const SizedBox(height: AppSpacing.xl),

              // 3. Reports catalog title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Incident reports',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: foren.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${reports.length} Published',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xs),

              // 4. Empty State or Reports list cards
              if (reports.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: GlassEffect(
                    borderRadius: AppRadius.borderRadiusLg,
                    border: Border.all(color: foren.borderSubtle),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 48,
                            color: foren.textSecondary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No Incident Reports Published Yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Complete an investigation case in the Investigation Lab and formulate a final verdict to generate an authoritative incident report.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: foren.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          FilledButton.icon(
                            onPressed: () {
                              context.push(RouteConstants.investigation);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: theme.scaffoldBackgroundColor,
                            ),
                            icon: const Icon(Icons.travel_explore, size: 18),
                            label: const Text(
                              'OPEN INVESTIGATION LAB',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...reports.map((report) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _ReportCard(
                      reportNumber: report.caseNumber,
                      title: report.title,
                      category: report.category,
                      severity: report.severity,
                      generatedAt: report.generatedAt,
                      summary: report.summary,
                      score: report.score,
                      xpEarned: report.xpEarned,
                      accentColor: _severityColor(report.severity, foren),
                      onTap: () {
                        context.push('${RouteConstants.reportDetail}/${report.id}');
                      },
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Color _severityColor(String severity, ForenColors foren) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return foren.critical.t500;
      case 'high':
        return foren.warning.t500;
      case 'medium':
        return foren.info.t500;
      default:
        return foren.simulation.t500;
    }
  }
}

class _ReportCard extends StatefulWidget {
  final String reportNumber;
  final String title;
  final String category;
  final String severity;
  final String generatedAt;
  final String summary;
  final int score;
  final int xpEarned;
  final Color accentColor;
  final VoidCallback onTap;

  const _ReportCard({
    required this.reportNumber,
    required this.title,
    required this.category,
    required this.severity,
    required this.generatedAt,
    required this.summary,
    this.score = 100,
    this.xpEarned = 0,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        child: GlassEffect(
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.6)
                : foren.borderSubtle,
            width: 1.0,
          ),
          borderRadius: AppRadius.borderRadiusLg,
          child: InkWell(
            borderRadius: AppRadius.borderRadiusLg,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withValues(alpha: 0.15),
                          borderRadius: AppRadius.borderRadiusXs,
                          border: Border.all(
                            color: widget.accentColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          widget.severity.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: widget.accentColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      if (widget.xpEarned > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: foren.success.t500.withValues(alpha: 0.12),
                            borderRadius: AppRadius.borderRadiusXs,
                          ),
                          child: Text(
                            '+${widget.xpEarned} XP',
                            style: TextStyle(
                              color: foren.success.t500,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        widget.reportNumber,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.category,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: foren.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foren.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: foren.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        widget.generatedAt,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foren.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Open report →',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
