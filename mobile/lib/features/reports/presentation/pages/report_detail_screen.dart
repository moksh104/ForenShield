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
import '../../../../routes/route_constants.dart';
import '../../providers/reports_provider.dart';
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

    final report = ref.watch(reportByIdProvider(reportId));

    if (report == null) {
      return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.find_in_page_outlined,
                size: 48,
                color: foren.textSecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Report not found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foren.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Exporting report artifact to PDF / JSON format...',
                            ),
                            backgroundColor: foren.success.t500,
                          ),
                        );
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
                        'Export',
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Uploading attachment...'),
                            ),
                          );
                          final compressed = await uploadService.compressImage(
                            file,
                          );
                          final url = await uploadService.uploadImage(
                            compressed ?? file,
                            folder: 'forenshield/reports',
                          );

                          if (!context.mounted) return;

                          if (url != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Attachment uploaded successfully! URL: $url',
                                ),
                                backgroundColor: foren.success.t500,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Failed to upload attachment',
                                ),
                                backgroundColor: foren.critical.t500,
                              ),
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
        numberOfParticles: 40,
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
                              fontSize: 22,
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

                  // 2. Metrics Telemetry Grid (2x2)
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
                          label: 'Analyst',
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
                  ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // 3. Key Findings Section
                  _SectionCard(
                        title: 'KEY FINDINGS & THREAT DIAGNOSIS',
                        icon: Icons.search_outlined,
                        accentColor: accentColor,
                        foren: foren,
                        children: report.findings
                            .map(
                              (finding) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.xs,
                                ),
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
                      )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.08, end: 0),

                  const SizedBox(height: AppSpacing.md),

                  // 4. Remediation Actions Section
                  _SectionCard(
                        title: 'REMEDIATION & THREAT MITIGATION',
                        icon: Icons.verified_user_outlined,
                        accentColor: foren.simulation.t500,
                        foren: foren,
                        children: report.remediationActions
                            .map(
                              (action) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.xs,
                                ),
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
                      )
                      .animate(delay: 350.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.08, end: 0),

                  const SizedBox(height: AppSpacing.md),

                  // 5. Extracted Artifacts Section
                  _SectionCard(
                        title: 'EXTRACTED FORENSIC ARTIFACTS',
                        icon: Icons.folder_open_outlined,
                        accentColor: foren.warning.t500,
                        foren: foren,
                        children: report.artifacts
                            .map(
                              (artifact) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.xs,
                                ),
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
                      )
                      .animate(delay: 450.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.08, end: 0),

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
