import 'package:equatable/equatable.dart';

/// User data model for the ForenShield PHP REST API.
///
/// The API returns JSON with camelCase or snake_case keys depending on the
/// Laravel serialisation convention configured on the backend.
/// Field names in [fromJson] must match the backend response exactly.
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
  List<Object?> get props => [
    id,
    email,
    displayName,
    avatarUrl,
    totalXp,
    rank,
    currentStreak,
    createdAt,
  ];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      displayName:
          (json['displayName'] ?? json['full_name'] ?? json['name'] ?? '')
              .toString(),
      avatarUrl:
          json['avatarUrl']?.toString() ?? json['avatar_url']?.toString(),
      totalXp: json['totalXp'] is int
          ? json['totalXp']
          : (json['xp'] is int
                ? json['xp']
                : int.tryParse(
                        json['totalXp']?.toString() ??
                            json['xp']?.toString() ??
                            '0',
                      ) ??
                      0),
      rank: (json['rank'] ?? 'Trainee').toString(),
      currentStreak: json['currentStreak'] is int
          ? json['currentStreak']
          : (json['streak'] is int
                ? json['streak']
                : int.tryParse(
                        json['currentStreak']?.toString() ??
                            json['streak']?.toString() ??
                            '0',
                      ) ??
                      0),
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : (json['created_at'] != null
                ? (DateTime.tryParse(json['created_at'].toString()) ??
                      DateTime.now())
                : DateTime.now()),
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
