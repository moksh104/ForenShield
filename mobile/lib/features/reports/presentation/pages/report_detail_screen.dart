import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/foren_theme.dart';
import '../../../../../routes/route_constants.dart';
import '../../providers/reports_provider.dart';

class ReportDetailScreen extends ConsumerWidget {
  final String reportId;

  const ReportDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final report = ref.watch(reportByIdProvider(reportId));

    if (report == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go(RouteConstants.reports);
            },
          ),
        ),
        body: Center(
          child: Text(
            'Report not found.',
            style: TextStyle(color: foren.textDisabled),
          ),
        ),
      );
    }

    final accentColor = _severityColor(report.severity, foren);

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
            context.go(RouteConstants.reports);
          },
        ),
        title: Text(
          report.caseNumber,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export is mock-only in the Academic MVP.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.download_rounded),
            label: const Text(
              'EXPORT REPORT',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
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
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.20),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.borderRadiusLg,
                border: Border.all(
                  color: foren.borderSubtle.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mock Case Report',
                    style: TextStyle(
                      color: foren.textDisabled,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    report.title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    report.summary,
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Severity',
                    value: report.severity,
                    accentColor: accentColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricCard(
                    label: 'Status',
                    value: report.status,
                    accentColor: foren.simulation.t500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Analyst',
                    value: report.analyst,
                    accentColor: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricCard(
                    label: 'Generated',
                    value: report.generatedAt,
                    accentColor: foren.info.t500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'Key Findings',
              icon: Icons.search_outlined,
              accentColor: accentColor,
              foren: foren,
              children: report.findings
                  .map(
                    (finding) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.circle, size: 8, color: accentColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              finding,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionCard(
              title: 'Remediation Actions',
              icon: Icons.verified_user_outlined,
              accentColor: foren.simulation.t500,
              foren: foren,
              children: report.remediationActions
                  .map(
                    (action) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: foren.success.t500,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              action,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionCard(
              title: 'Artifacts',
              icon: Icons.folder_open_outlined,
              accentColor: foren.warning.t500,
              foren: foren,
              children: report.artifacts
                  .map(
                    (artifact) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: foren.warning.t500,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              artifact,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
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

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: foren.textDisabled,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final ForenColors foren;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.foren,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}
