/// Represents a single achievement in the ForenShield achievement engine.
class AchievementModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String badge;
  final int xp;
  final bool unlocked;
  final DateTime? unlockedAt;
  final DateTime? createdAt;

  const AchievementModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.badge,
    required this.xp,
    required this.unlocked,
    this.unlockedAt,
    this.createdAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      badge: (json['badge'] ?? '🏆').toString(),
      xp: json['xp'] is int
          ? json['xp']
          : int.tryParse(json['xp']?.toString() ?? '0') ?? 0,
      unlocked: json['unlocked'] == true ||
          json['unlocked'] == 1 ||
          json['unlocked'] == 't' ||
          json['unlocked'] == 'true',
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.tryParse(json['unlocked_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'badge': badge,
      'xp': xp,
      'unlocked': unlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  AchievementModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? badge,
    int? xp,
    bool? unlocked,
    DateTime? unlockedAt,
    DateTime? createdAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      badge: badge ?? this.badge,
      xp: xp ?? this.xp,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
