import 'package:flutter/material.dart';
import '../../data/models/achievement_model.dart';
import 'achievement_card.dart';

/// Responsive grid layout for achievement cards (2 columns on mobile).
class AchievementGrid extends StatelessWidget {
  final List<AchievementModel> achievements;
  final void Function(AchievementModel)? onAchievementTap;

  const AchievementGrid({
    super.key,
    required this.achievements,
    this.onAchievementTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return AchievementCard(
          achievement: achievement,
          onTap: onAchievementTap != null
              ? () => onAchievementTap!(achievement)
              : null,
        );
      },
    );
  }
}
