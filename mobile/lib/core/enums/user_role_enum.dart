/// Represents the RBAC role of a user within ForenShield.
enum UserRole {
  trainee('Trainee'),
  analyst('Analyst'),
  investigator('Investigator'),
  instructor('Instructor'),
  admin('Administrator');

  final String displayName;
  const UserRole(this.displayName);

  /// Checks if this role has elevated privileges (instructor or above).
  bool get hasElevatedPrivileges =>
      this == UserRole.instructor || this == UserRole.admin;

  /// Parses a string from the backend into a valid UserRole.
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.trainee,
    );
  }
}
