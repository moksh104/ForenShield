import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement_models.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/badges/rank_badge.dart';
import '../../../features/authentication/providers/auth_state_provider.dart';

final achievementsProvider = Provider<AchievementsOverview>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  final currentXp = user?.totalXp ?? 0;
  final currentLevel = _calculateLevel(currentXp);
  final xpForNextLevel = _xpForLevel(currentLevel + 1);
  final levelProgress = currentXp / xpForNextLevel;
  final completionPercentage = (currentXp / 10000).clamp(0.0, 1.0);
  final streak = user?.currentStreak ?? 0;

  return AchievementsOverview(
    rankLabel: user?.rank ?? 'Trainee',
    rankTier: _rankTierForLabel(user?.rank ?? 'Trainee'),
    totalXp: currentXp,
    currentLevel: currentLevel,
    currentXp: currentXp,
    xpForNextLevel: xpForNextLevel,
    levelProgress: levelProgress,
    currentStreak: streak,
    completionPercentage: completionPercentage,
    badges: _defaultBadges(currentXp, streak),
    certificates: _defaultCertificates(),
  );
});

int _calculateLevel(int xp) {
  return (xp / 500).floor() + 1;
}

int _xpForLevel(int level) {
  return level * 500;
}

RankTier _rankTierForLabel(String label) {
  switch (label) {
    case 'Trainee':
      return RankTier.bronze;
    case 'Analyst':
      return RankTier.silver;
    case 'Investigator':
      return RankTier.gold;
    case 'Specialist':
      return RankTier.platinum;
    case 'Senior Analyst':
      return RankTier.diamond;
    default:
      return RankTier.diamond;
  }
}

List<AchievementBadgeModel> _defaultBadges(int xp, int streak) {
  return [
    AchievementBadgeModel(
      id: 'xp_master',
      title: 'XP Master',
      description: 'Earn at least 1,000 XP.',
      icon: Icons.star,
      unlocked: xp >= 1000,
      progress: (xp / 1000).clamp(0.0, 1.0),
      color: ForenSemanticColors.success.t500,
    ),
    AchievementBadgeModel(
      id: 'streak_keeper',
      title: 'Streak Keeper',
      description: 'Maintain a 7-day learning streak.',
      icon: Icons.local_fire_department,
      unlocked: streak >= 7,
      progress: (streak / 7).clamp(0.0, 1.0),
      color: ForenSemanticColors.warning.t500,
    ),
    AchievementBadgeModel(
      id: 'course_completer',
      title: 'Course Completer',
      description: 'Complete 100% of a learning path.',
      icon: Icons.school,
      unlocked: xp >= 500,
      progress: (xp / 500).clamp(0.0, 1.0),
      color: ForenFeatureColors.profile.t500,
    ),
  ];
}

List<CertificateModel> _defaultCertificates() {
  return [
    CertificateModel(
      title: 'Cybersecurity Fundamentals',
      subtitle: 'Verified completion certificate',
      issuedAt: DateTime(2025, 12, 1),
      verified: true,
    ),
    CertificateModel(
      title: 'Incident Response',
      subtitle: 'Completion certificate',
      issuedAt: DateTime(2026, 1, 14),
      verified: true,
    ),
  ];
}
