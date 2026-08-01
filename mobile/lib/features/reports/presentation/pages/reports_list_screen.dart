import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
import '../../providers/reports_provider.dart';
import '../widgets/reports_dashboard_header.dart';
import '../widgets/security_heat_map_widget.dart';

/// Enterprise Cybersecurity Analytics Reports List Screen.
class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  /// Performance & Emergency Switch Compliance
  static const bool enableAdvancedEffects = true;
  static const int particleCount = 40;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final reports = ref.watch(reportsProvider);

    final Widget contentBody = Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
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
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.insights_outlined, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'Security Intelligence Reports',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w800,
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
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // 1. Cybersecurity Analytics Dashboard Header
                ReportsDashboardHeader(reports: reports)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.1, end: 0),

                const SizedBox(height: AppSpacing.lg),

                // 2. Incident Density Heat Map Grid
                const SecurityHeatMapWidget()
                    .animate(delay: 150.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.08, end: 0),

                const SizedBox(height: AppSpacing.xl),

                // 3. Case Reports Catalog Title
                Text(
                  'CYBER INCIDENT REPORTS CATALOG',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 1.0,
                  ),
                )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: AppSpacing.xs),

                // 4. Reports List Cards
                ...reports.asMap().entries.map((entry) {
                  final index = entry.key;
                  final report = entry.value;

                  return Padding(
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
                    )
                        .animate(delay: Duration(milliseconds: 250 + (index * 60)))
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.08, end: 0),
                  );
                }),
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
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    final Widget cardBody = GlassEffect(
      blurX: 12.0,
      blurY: 12.0,
      opacity: 0.10,
      border: Border.all(
        color: _isHovered ? widget.accentColor : foren.borderSubtle,
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
                      style: TextStyle(
                        color: widget.accentColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.reportNumber,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Geist',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.category,
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.summary,
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
                    color: foren.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.generatedAt,
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Open Report →',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        child: ReportsListScreen.enableAdvancedEffects
            ? GlowEffect(
                glowColor: _isHovered ? widget.accentColor : Colors.transparent,
                blurRadius: 16,
                spreadRadius: 1,
                animate: _isHovered,
                borderRadius: AppRadius.borderRadiusLg,
                child: cardBody,
              )
            : cardBody,
      ),
    );
  }
}
