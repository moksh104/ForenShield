import 'package:flutter/material.dart';

/// A vertical timeline section showing recent user activity.
class RecentActivitySection extends StatelessWidget {
  final List<ActivityItem> items;

  const RecentActivitySection({super.key, this.items = const []});

  static List<ActivityItem> get defaults => const [
        ActivityItem(
          icon: Icons.check_circle_outline,
          title: 'Completed: Chain of Custody Lab',
          subtitle: 'Academy · Module 2',
          time: '2h ago',
          color: Color(0xFF34D399),
        ),
        ActivityItem(
          icon: Icons.search_outlined,
          title: 'Ran hash verification scan',
          subtitle: 'Evidence · evidence_disk_01.img',
          time: '5h ago',
          color: Color(0xFF60A5FA),
        ),
        ActivityItem(
          icon: Icons.flag_outlined,
          title: 'Opened new case: #FSC-0091',
          subtitle: 'Investigation · Ransomware',
          time: '7h ago',
          color: Color(0xFFFBBF24),
        ),
        ActivityItem(
          icon: Icons.login_outlined,
          title: 'Session started',
          subtitle: 'Login · Mumbai, IN',
          time: '8h ago',
          color: Color(0xFF94A3B8),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayItems = items.isEmpty ? defaults : items;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
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
              itemCount: displayItems.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                thickness: 1,
                indent: 56,
                endIndent: 16,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                return _ActivityTile(
                  item: displayItems[index],
                  isLast: index == displayItems.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem item;
  final bool isLast;
  const _ActivityTile({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  item.subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            item.time,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for a single activity timeline item.
class ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}
