import 'package:equatable/equatable.dart';

/// User model
class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final int totalXp;
  final String rank;
  final int currentStreak;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.totalXp,
    required this.rank,
    required this.currentStreak,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, avatarUrl, totalXp, rank, currentStreak, createdAt];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalXp: json['totalXp'] as int? ?? 0,
      rank: json['rank'] as String? ?? 'Trainee',
      currentStreak: json['currentStreak'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'totalXp': totalXp,
      'rank': rank,
      'currentStreak': currentStreak,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    int? totalXp,
    String? rank,
    int? currentStreak,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalXp: totalXp ?? this.totalXp,
      rank: rank ?? this.rank,
      currentStreak: currentStreak ?? this.currentStreak,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      displayName: '',
      totalXp: 0,
      rank: 'Trainee',
      currentStreak: 0,
      createdAt: DateTime.now(),
    );
  }
}
