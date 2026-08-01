import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/profile_entity.dart';

/// Activity Timeline & Recent Forensic Log Section.
class ActivityTimeline extends StatelessWidget {
  final List<XpHistoryItemEntity> xpHistory;

  const ActivityTimeline({
    super.key,
    required this.xpHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final historyList = xpHistory.isNotEmpty
        ? xpHistory
        : const [
            XpHistoryItemEntity(
              id: '1',
              title: 'Completed Memory Dump Analysis Lab',
              source: 'Investigation Lab',
              xpAmount: 250,
              timestamp: '2 hours ago',
            ),
            XpHistoryItemEntity(
              id: '2',
              title: 'Solved Ransomware Threat Vector Simulation',
              source: 'Simulation Lab',
              xpAmount: 180,
              timestamp: 'Yesterday',
            ),
            XpHistoryItemEntity(
              id: '3',
              title: 'Unlocked Specialist Badge: Packet Sniffer',
              source: 'Cyber Academy',
              xpAmount: 300,
              timestamp: '3 days ago',
            ),
          ];

    return GlassEffect(
      blurX: 14.0,
      blurY: 14.0,
      opacity: 0.10,
      border: Border.all(
        color: AppColors.logoGold.withValues(alpha: 0.35),
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusXl,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timeline_outlined, color: AppColors.logoGold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'ANALYST ACTIVITY TIMELINE',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Text(
                  'RECENT LOGS',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                final isLast = index == historyList.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline Indicator Node & Line
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.logoGold,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.logoGold.withValues(alpha: 0.6),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 1.5,
                                color: foren.borderSubtle.withValues(alpha: 0.5),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Activity Item Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: foren.surfaceRaised1.withValues(alpha: 0.5),
                              borderRadius: AppRadius.borderRadiusMd,
                              border: Border.all(
                                color: foren.borderSubtle.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.source} · ${item.timestamp}',
                                        style: TextStyle(
                                          color: foren.textSecondary,
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.15),
                                    borderRadius: AppRadius.borderRadiusSm,
                                    border: Border.all(
                                      color: primaryColor.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Text(
                                    '+${item.xpAmount} XP',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
