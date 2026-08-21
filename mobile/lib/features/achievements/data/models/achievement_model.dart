import 'package:flutter/material.dart';

enum AchievementRarity { common, uncommon, rare, epic, legendary }

class AchievementModel {
  final int id;
  final String code;
  final String title;
  final String description;
  final String icon;
  final String category;
  final int xpReward;
  final AchievementRarity rarity;
  final String targetMetric;
  final int threshold;
  final int progress;
  final bool isCompleted;
  final DateTime? unlockedAt;

  const AchievementModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.xpReward,
    required this.rarity,
    required this.targetMetric,
    required this.threshold,
    required this.progress,
    required this.isCompleted,
    this.unlockedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as int,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '🏆',
      category: json['category'] as String? ?? 'general',
      xpReward: json['xp_reward'] as int? ?? 0,
      rarity: _parseRarity(json['rarity'] as String?),
      targetMetric: json['target_metric'] as String? ?? '',
      threshold: json['threshold'] as int? ?? 1,
      progress: json['progress'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'] as String)
          : null,
    );
  }

  static AchievementRarity _parseRarity(String? rarityStr) {
    switch (rarityStr?.toLowerCase()) {
      case 'legendary':
        return AchievementRarity.legendary;
      case 'epic':
        return AchievementRarity.epic;
      case 'rare':
        return AchievementRarity.rare;
      case 'uncommon':
        return AchievementRarity.uncommon;
      case 'common':
      default:
        return AchievementRarity.common;
    }
  }

  Color getRarityColor() {
    switch (rarity) {
      case AchievementRarity.legendary:
        return const Color(0xFFFFD700); // Gold
      case AchievementRarity.epic:
        return const Color(0xFF9C27B0); // Purple
      case AchievementRarity.rare:
        return const Color(0xFF2196F3); // Blue
      case AchievementRarity.uncommon:
        return const Color(0xFF4CAF50); // Green
      case AchievementRarity.common:
        return const Color(0xFF9E9E9E); // Gray
    }
  }
}
