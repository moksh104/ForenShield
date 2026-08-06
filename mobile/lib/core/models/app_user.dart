import 'package:equatable/equatable.dart';

/// Represents a core user entity in the ForenShield platform.
class AppUser extends Equatable {
  /// The unique identifier of the user.
  final String id;

  /// The user's full name.
  final String name;

  /// The user's registered email address.
  final String email;

  /// Optional URL pointing to the user's avatar image.
  final String? avatarUrl;

  /// The user's role (e.g., student, instructor, admin).
  final String role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
  });

  /// Parses [AppUser] from a JSON map.
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['displayName'] ?? json['full_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatarUrl']?.toString(),
      role: (json['role'] ?? 'user').toString(),
    );
  }

  /// Converts [AppUser] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role,
    };
  }

  /// Creates a copy of this [AppUser] with given fields replaced.
  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatarUrl, role];
}
