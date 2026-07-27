import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/foren_theme.dart';
import '../../../../../routes/route_constants.dart';
import '../../providers/reports_provider.dart';

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
          'Reports',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: AppRadius.borderRadiusLg,
                gradient: LinearGradient(
                  colors: [
                    foren.investigation.t500.withValues(alpha: 0.20),
                    foren.surfaceRaised1,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: foren.borderSubtle.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Academic MVP',
                    style: TextStyle(
                      color: foren.textDisabled,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Mock Case Reports',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${reports.length} reports available for review and export.',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...reports.map(
              (report) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _ReportCard(
                  reportNumber: report.caseNumber,
                  title: report.title,
                  category: report.category,
                  severity: report.severity,
                  generatedAt: report.generatedAt,
                  summary: report.summary,
                  accentColor: _severityColor(report.severity, foren),
                  onTap: () {
                    context.push('${RouteConstants.reportDetail}/${report.id}');
                  },
                ),
              ),
            ),
          ],
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

class _ReportCard extends StatelessWidget {
  final String reportNumber;
  final String title;
  final String category;
  final String severity;
  final String generatedAt;
  final String summary;
  final Color accentColor;
  final VoidCallback onTap;

  const _ReportCard({
    required this.reportNumber,
    required this.title,
    required this.category,
    required this.severity,
    required this.generatedAt,
    required this.summary,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.borderRadiusLg,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(
              color: foren.borderSubtle.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      severity.toUpperCase(),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    reportNumber,
                    style: TextStyle(
                      color: foren.textDisabled,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category,
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                summary,
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: foren.textDisabled,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    generatedAt,
                    style: TextStyle(color: foren.textDisabled, fontSize: 11),
                  ),
                  const Spacer(),
                  Text(
                    'Open Report',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
