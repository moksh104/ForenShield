import 'package:flutter/material.dart';

/// A card showcasing the daily forensic challenge or case of the day.
class DailyChallengeCard extends StatelessWidget {
  final String challengeTitle;
  final String challengeType;
  final String pointsReward;
  final String timeLimit;
  final bool isCompleted;
  final VoidCallback? onStartTap;

  const DailyChallengeCard({
    super.key,
    this.challengeTitle = 'Identify the Phishing Vector',
    this.challengeType = 'Email Forensics',
    this.pointsReward = '+250 XP',
    this.timeLimit = '15 min',
    this.isCompleted = false,
    this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accentColor = Color(0xFFA78BFA); // violet

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.3),
          ),
        ),
        child: InkWell(
          onTap: isCompleted ? null : onStartTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      isCompleted ? '✓' : '⚡',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'DAILY CHALLENGE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: accentColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              fontSize: 9,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              pointsReward,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challengeTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            challengeType,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.timer_outlined,
                              size: 11,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.45)),
                          const SizedBox(width: 3),
                          Text(
                            timeLimit,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (isCompleted)
                  Icon(Icons.check_circle_outline,
                      color: Colors.greenAccent.shade400, size: 22)
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
