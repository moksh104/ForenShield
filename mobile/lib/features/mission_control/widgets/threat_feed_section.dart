import 'package:flutter/material.dart';

/// A threat intelligence feed showing recent alerts.
class ThreatFeedSection extends StatelessWidget {
  final List<ThreatItem> threats;

  const ThreatFeedSection({super.key, this.threats = const []});

  static List<ThreatItem> get defaults => const [
        ThreatItem(
          severity: ThreatSeverity.critical,
          title: 'LockBit 3.0 Variant Detected',
          source: 'CISA Advisory',
          time: '1h ago',
        ),
        ThreatItem(
          severity: ThreatSeverity.high,
          title: 'Phishing Campaign Targeting Finance Sector',
          source: 'Threat Intel Feed',
          time: '4h ago',
        ),
        ThreatItem(
          severity: ThreatSeverity.medium,
          title: 'CVE-2024-3049 Exploited in the Wild',
          source: 'NVD',
          time: '12h ago',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayThreats = threats.isEmpty ? defaults : threats;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Threat Intelligence',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF87171),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'LIVE',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFF87171),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayThreats.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                thickness: 1,
                indent: 56,
                endIndent: 16,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
              itemBuilder: (_, index) =>
                  _ThreatTile(item: displayThreats[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreatTile extends StatelessWidget {
  final ThreatItem item;
  const _ThreatTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = item.severity.color;
    final severityLabel = item.severity.label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.warning_amber_outlined,
              color: severityColor,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: severityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        severityLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: severityColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.time,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.38),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.source,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.42),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Represents a single threat intel entry.
class ThreatItem {
  final ThreatSeverity severity;
  final String title;
  final String source;
  final String time;

  const ThreatItem({
    required this.severity,
    required this.title,
    required this.source,
    required this.time,
  });
}

/// Severity levels for [ThreatItem].
enum ThreatSeverity {
  critical,
  high,
  medium,
  low;

  Color get color {
    switch (this) {
      case ThreatSeverity.critical:
        return const Color(0xFFF87171);
      case ThreatSeverity.high:
        return const Color(0xFFFBBF24);
      case ThreatSeverity.medium:
        return const Color(0xFF60A5FA);
      case ThreatSeverity.low:
        return const Color(0xFF94A3B8);
    }
  }

  String get label {
    switch (this) {
      case ThreatSeverity.critical:
        return 'CRITICAL';
      case ThreatSeverity.high:
        return 'HIGH';
      case ThreatSeverity.medium:
        return 'MEDIUM';
      case ThreatSeverity.low:
        return 'LOW';
    }
  }
}
