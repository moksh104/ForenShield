import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/extensions/build_context_extension.dart';
import '../../../../routes/route_constants.dart';
import '../../models/report_case.dart';
import '../../providers/reports_provider.dart';
import '../../services/incident_report_pdf_generator.dart';
import '../../../../core/services/upload_service.dart';

/// Detailed Incident & Forensic Intelligence Report View Screen.
class ReportDetailScreen extends ConsumerWidget {
  final String reportId;

  const ReportDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final reportAsync = ref.watch(reportDetailAsyncProvider(reportId));

    return reportAsync.when(
      loading: () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
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
          title: const Text(
            'LOADING REPORT...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              letterSpacing: 0.8,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Retrieving authoritative incident dossier…',
                style: TextStyle(color: foren.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
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
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: foren.critical.t500,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Failed to load report',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  err.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foren.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(reportDetailAsyncProvider(reportId)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('RETRY'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (report) => _buildReportScaffold(context, ref, theme, foren, primaryColor, report),
    );
  }

  Widget _buildReportScaffold(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ForenColors foren,
    Color primaryColor,
    ReportCase report,
  ) {
    final accentColor = _severityColor(report.severity, foren);

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
            context.go(RouteConstants.reports);
          },
        ),
        title: Text(
          report.caseNumber,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
            letterSpacing: 0.8,
          ),
        ),
      ),
      bottomNavigationBar: GlassEffect(
        border: Border(top: BorderSide(color: foren.borderSubtle)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          context.showInfoSnackBar('Generating authoritative PDF dossier…');
                          await IncidentReportPdfGenerator.exportAndPrint(report);
                        } catch (e) {
                          if (context.mounted) {
                            context.showErrorSnackBar('Export error: ${e.toString()}');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: theme.scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                      ),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: Text(
                        'Export PDF',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.scaffoldBackgroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uploadService = ref.read(uploadServiceProvider);
                        final file = await uploadService.pickFile();

                        if (!context.mounted) return;

                        if (file != null) {
                          context.showInfoSnackBar('Uploading attachment...');
                          final compressed = await uploadService.compressImage(file);
                          final url = await uploadService.uploadImage(
                            compressed ?? file,
                            folder: 'forenshield/reports',
                          );

                          if (!context.mounted) return;

                          if (url != null) {
                            context.showSuccessSnackBar(
                              'Attachment uploaded successfully.',
                            );
                          } else {
                            context.showErrorSnackBar(
                              'Failed to upload attachment. Please try again.',
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(color: foren.borderSubtle),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                      ),
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: Text(
                        'Attach',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ParticleBackground(
        numberOfParticles: 35,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: Stack(
          children: [
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // 1. Report Header Briefing Card
                  GlassEffect(
                    blurX: 16.0,
                    blurY: 16.0,
                    opacity: 0.12,
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.45),
                      width: 1.0,
                    ),
                    borderRadius: AppRadius.borderRadiusLg,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.borderRadiusXs,
                                  border: Border.all(
                                    color: accentColor.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(
                                  'SEVERITY: ${report.severity.toUpperCase()}',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              Text(
                                report.category.toUpperCase(),
                                style: TextStyle(
                                  color: foren.textSecondary,
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            report.title,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Geist',
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
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

                  const SizedBox(height: AppSpacing.lg),

                  // 2. Metrics Telemetry Grid (3 Rows)
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
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          label: 'Score Accuracy',
                          value: '${report.score}%',
                          accentColor: foren.warning.t500,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _MetricCard(
                          label: 'XP Awarded',
                          value: '+${report.xpEarned} XP',
                          accentColor: foren.success.t500,
                        ),
                      ),
                    ],
                  ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          label: 'Lead Analyst',
                          value: report.analyst,
                          accentColor: primaryColor,
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
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // 3. Verdict & Root Cause Analysis
                  if (report.verdict != null) ...[
                    _SectionCard(
                      title: 'ROOT CAUSE VERDICT & EVALUATION',
                      icon: Icons.gavel_outlined,
                      accentColor: foren.investigation.t500,
                      foren: foren,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: foren.investigation.t500.withValues(alpha: 0.10),
                            borderRadius: AppRadius.borderRadiusMd,
                            border: Border.all(
                              color: foren.investigation.t500.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IDENTIFIED ROOT CAUSE:',
                                style: TextStyle(
                                  color: foren.investigation.t500,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                report.verdict!.rootCause,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (report.verdict!.explanation.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  report.verdict!.explanation,
                                  style: TextStyle(
                                    color: foren.textSecondary,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // 4. Investigation Timeline
                  if (report.timeline.isNotEmpty) ...[
                    _SectionCard(
                      title: 'CHRONOLOGICAL INCIDENT TIMELINE',
                      icon: Icons.timeline_outlined,
                      accentColor: foren.info.t500,
                      foren: foren,
                      children: report.timeline.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(top: 3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _severityColor(item.severity, foren),
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 38,
                                    color: foren.borderSubtle.withValues(alpha: 0.4),
                                  ),
                                ],
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          item.timestamp,
                                          style: TextStyle(
                                            color: foren.textSecondary,
                                            fontSize: 10,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.description,
                                      style: TextStyle(
                                        color: foren.textSecondary,
                                        fontSize: 12,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // 5. Forensic Evidence Log
                  if (report.evidence.isNotEmpty) ...[
                    _SectionCard(
                      title: 'RECOVERED FORENSIC EVIDENCE',
                      icon: Icons.shield_outlined,
                      accentColor: foren.simulation.t500,
                      foren: foren,
                      children: report.evidence.map((ev) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: foren.surfaceRaised1.withValues(alpha: 0.5),
                            borderRadius: AppRadius.borderRadiusSm,
                            border: Border.all(
                              color: foren.borderSubtle.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: foren.simulation.t500.withValues(alpha: 0.15),
                                      borderRadius: AppRadius.borderRadiusXs,
                                    ),
                                    child: Text(
                                      ev.type.toUpperCase(),
                                      style: TextStyle(
                                        color: foren.simulation.t500,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      ev.title,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ev.timestamp,
                                    style: TextStyle(
                                      color: foren.textSecondary,
                                      fontSize: 10,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                              if (ev.content.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  ev.content,
                                  style: TextStyle(
                                    color: foren.textSecondary,
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                    height: 1.3,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // 6. Analyst Decision & Action Log (Simulation Attempt Trace)
                  if (report.analystActions.isNotEmpty) ...[
                    _SectionCard(
                      title: 'ANALYST SIMULATION DECISIONS',
                      icon: Icons.psychology_outlined,
                      accentColor: primaryColor,
                      foren: foren,
                      children: report.analystActions.map((act) {
                        final isPositive = act.scoreDelta >= 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                isPositive ? Icons.check_circle_outline : Icons.cancel_outlined,
                                size: 14,
                                color: isPositive ? foren.success.t500 : foren.critical.t500,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            act.actionLabel,
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          act.scoreDelta > 0
                                              ? '+${act.scoreDelta} pts'
                                              : '${act.scoreDelta} pts',
                                          style: TextStyle(
                                            color: isPositive ? foren.success.t500 : foren.critical.t500,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (act.consequence.isNotEmpty)
                                      Text(
                                        act.consequence,
                                        style: TextStyle(
                                          color: foren.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // 7. Key Findings Section
                  _SectionCard(
                    title: 'KEY FINDINGS & THREAT DIAGNOSIS',
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
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: accentColor,
                                ),
                                const SizedBox(width: AppSpacing.sm),
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
                  ).animate(delay: 450.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.md),

                  // 8. Remediation Actions Section
                  _SectionCard(
                    title: 'REMEDIATION & THREAT MITIGATION',
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
                                const SizedBox(width: AppSpacing.sm),
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
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.md),

                  // 9. Extracted Artifacts Section
                  _SectionCard(
                    title: 'EXTRACTED FORENSIC ARTIFACTS',
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
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    artifact,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 13,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ).animate(delay: 550.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.xxl),
                ],
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

    return GlassEffect(
      blurX: 10.0,
      blurY: 10.0,
      opacity: 0.10,
      border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.35)),
      borderRadius: AppRadius.borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: foren.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
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
                fontFamily: 'Geist',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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

    return GlassEffect(
      blurX: 12.0,
      blurY: 12.0,
      opacity: 0.10,
      border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.35)),
      borderRadius: AppRadius.borderRadiusLg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...children,
          ],
        ),
      ),
    );
  }
}
