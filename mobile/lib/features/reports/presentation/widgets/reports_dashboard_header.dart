import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../models/report_case.dart';
import '../../providers/nvd_provider.dart';

/// Cybersecurity analytics dashboard header.
///
/// The four metric tiles show live NVD CVE statistics (Critical, High, Medium,
/// Low counts) fetched from `api/nvd.php`. Falls back gracefully to `--`
/// placeholders when data is unavailable.
class ReportsDashboardHeader extends ConsumerWidget {
  final List<ReportCase> reports;

  const ReportsDashboardHeader({super.key, required this.reports});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    // NVD live stats
    final nvdState = ref.watch(nvdProvider);
    final nvdStats = nvdState.stats;

    final totalReports = reports.length;

    // ── Metric values ──────────────────────────────────────────────────────
    // Use live NVD counts when available, zero otherwise (shows as '--').
    final criticalCves = nvdStats?.critical ?? 0;
    final highCves = nvdStats?.high ?? 0;
    final mediumCves = nvdStats?.medium ?? 0;
    final lowCves = nvdStats?.low ?? 0;

    // Determine whether we are still fetching for the first time
    final isFirstLoad =
        nvdState.status == NvdStatus.initial ||
        nvdState.status == NvdStatus.loading;
    final isError = nvdState.status == NvdStatus.error && !nvdState.hasData;

    return GlassEffect(
      borderRadius: AppRadius.borderRadiusXl,
      border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.4)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top status + count row ───────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isError
                            ? foren.warning.t500
                            : foren.success.t500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      isError
                          ? 'Threat intelligence unavailable'
                          : 'Threat intelligence active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foren.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderRadiusSm,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '$totalReports reported incidents',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Key metrics (NVD CVE counts) ─────────────────────────────
            isFirstLoad
                ? const _MetricsLoading()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HeaderMetric(
                        label: 'Critical CVEs',
                        value: criticalCves.toDouble(),
                        suffix: '',
                        color: foren.critical.t500,
                        isUnavailable: isError,
                      ),
                      _HeaderMetric(
                        label: 'High CVEs',
                        value: highCves.toDouble(),
                        suffix: '',
                        color: foren.warning.t500,
                        isUnavailable: isError,
                      ),
                      _HeaderMetric(
                        label: 'Medium CVEs',
                        value: mediumCves.toDouble(),
                        suffix: '',
                        color: primaryColor,
                        isUnavailable: isError,
                      ),
                      _HeaderMetric(
                        label: 'Low CVEs',
                        value: lowCves.toDouble(),
                        suffix: '',
                        color: foren.success.t500,
                        isUnavailable: isError,
                      ),
                    ],
                  ),

            // ── Error notice (only when no data at all) ──────────────────
            if (isError) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 12,
                    color: foren.textDisabled,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    nvdState.errorMessage ??
                        'Unable to load live vulnerability reports.',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foren.textDisabled,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],

            // ── Stale-cache notice (data available but refresh failed) ───
            if (nvdState.status == NvdStatus.error && nvdState.hasData) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 12,
                    color: foren.warning.t500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    nvdState.errorMessage ??
                        'Unable to refresh. Showing cached data.',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foren.warning.t500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],

            // ── NVD source attribution ───────────────────────────────────
            if (nvdState.status == NvdStatus.success) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Source: NVD CVE API v2.0${nvdStats!.fromCache ? ' · cached' : ''}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foren.textDisabled,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Loading Skeleton ──────────────────────────────────────────────────────────

/// Shown while the NVD stats are loading for the first time.
class _MetricsLoading extends StatelessWidget {
  const _MetricsLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(4, (_) {
        return Column(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foren.textDisabled,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 52,
              height: 8,
              decoration: BoxDecoration(
                color: foren.borderSubtle,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Metric Tile ───────────────────────────────────────────────────────────────

class _HeaderMetric extends StatelessWidget {
  final String label;
  final double value;
  final String suffix;
  final Color color;

  /// When true, shows '--' instead of the animated value.
  final bool isUnavailable;

  const _HeaderMetric({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
    this.isUnavailable = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      children: [
        isUnavailable
            ? Text(
                '--',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: foren.textDisabled,
                  fontWeight: FontWeight.w800,
                ),
              )
            : TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: value),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, animatedVal, child) {
                  return Text(
                    '${animatedVal.toInt()}$suffix',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                },
              ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: foren.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
