import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/cisa_kev_entity.dart';

/// Displays a single CISA Known Exploited Vulnerability (KEV) entry as a
/// compact card suitable for a horizontal scroll list.
///
/// Populated fields:
///  - CVE ID (prominent label)
///  - Vendor & Product
///  - Vulnerability Name
///  - Severity badge (colour-coded)
///  - Date Added
///  - Required Action (truncated to 2 lines)
///
/// Reuses existing ForenShield theme tokens — no ad-hoc colours or sizing.
class KevThreatCard extends StatelessWidget {
  final CisaKevEntry entry;

  const KevThreatCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final cs = theme.colorScheme;
    final severityColor = _severityColor(foren, entry.severity);

    return Container(
      width: 268,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: severityColor.withValues(alpha: 0.30)),
        boxShadow: AppShadows.forBrightness(
          brightness: theme.brightness,
          level: ElevationLevel.low,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Row 1: CVE ID + Severity badge ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CVE ID pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: severityColor.withValues(alpha: 0.30),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  entry.cveId,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 10.5,
                    letterSpacing: 0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const Spacer(),

              // Severity badge
              _SeverityBadge(severity: entry.severity, color: severityColor),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Row 2: Vendor · Product ──────────────────────────────────────
          Text(
            '${entry.vendor}  ·  ${entry.product}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: foren.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // ── Row 3: Vulnerability Name ────────────────────────────────────
          Text(
            entry.vulnerabilityName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: cs.onSurface,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              height: 1.30,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Divider ──────────────────────────────────────────────────────
          Divider(height: 1, thickness: 0.8, color: foren.borderSubtle),

          const SizedBox(height: AppSpacing.sm),

          // ── Row 4: Date Added ────────────────────────────────────────────
          if (entry.dateAdded.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 11,
                  color: foren.textDisabled,
                ),
                const SizedBox(width: 4),
                Text(
                  'Added: ${entry.dateAdded}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foren.textDisabled,
                    fontSize: 10,
                  ),
                ),
                if (entry.knownRansomware.toLowerCase() == 'known') ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: foren.critical.t500.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Ransomware',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foren.critical.t500,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),

          const SizedBox(height: 6),

          // ── Row 5: Required Action ───────────────────────────────────────
          Text(
            entry.requiredAction,
            style: theme.textTheme.bodySmall?.copyWith(
              color: foren.textSecondary,
              fontSize: 10.5,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Returns a severity-appropriate colour from the ForenShield palette.
  Color _severityColor(ForenColors foren, String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return foren.critical.t500;
      case 'HIGH':
        return foren.warning.t500;
      case 'MEDIUM':
        return const Color(0xFFF59E0B); // amber-500
      case 'LOW':
        return foren.success.t500;
      default:
        return foren.textSecondary;
    }
  }
}

// ── Severity Badge ────────────────────────────────────────────────────────────

class _SeverityBadge extends StatelessWidget {
  final String severity;
  final Color color;

  const _SeverityBadge({required this.severity, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = severity == 'N/A' ? 'N/A' : severity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 9.5,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
