import 'package:flutter/material.dart';
import '../../../core/widgets/badges/rank_badge.dart';

class AchievementBadgeModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final double progress;
  final Color color;

  const AchievementBadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    required this.progress,
    required this.color,
  });
}

class CertificateModel {
  final String title;
  final String subtitle;
  final DateTime issuedAt;
  final bool verified;

  const CertificateModel({
    required this.title,
    required this.subtitle,
    required this.issuedAt,
    required this.verified,
  });
}

class AchievementsOverview {
  final String rankLabel;
  final RankTier rankTier;
  final int totalXp;
  final int currentLevel;
  final int currentXp;
  final int xpForNextLevel;
  final double levelProgress;
  final int currentStreak;
  final double completionPercentage;
  final List<AchievementBadgeModel> badges;
  final List<CertificateModel> certificates;

  const AchievementsOverview({
    required this.rankLabel,
    required this.rankTier,
    required this.totalXp,
    required this.currentLevel,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.levelProgress,
    required this.currentStreak,
    required this.completionPercentage,
    required this.badges,
    required this.certificates,
  });

  int get unlockedBadgeCount => badges.where((badge) => badge.unlocked).length;
  int get earnedCertificateCount => certificates.length;
}
