/// Centralized registry for all API endpoint routes in ForenShield.
///
/// Organized by feature domain. All paths are appended to the `apiBaseUrl`.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Base Routes ────────────────────────────────────────────────────────────
  static const String _auth = '/auth';
  static const String _academy = '/academy';
  static const String _missionControl = '/mission-control';
  static const String _simulation = '/simulation';
  static const String _investigation = '/investigation';
  static const String _upload = '/upload';

  // ── Authentication ─────────────────────────────────────────────────────────

  /// Login with email and password
  static const String login = '$_auth/login';

  /// Register a new account
  static const String register = '$_auth/register';

  /// Exchange a refresh token for a new access token
  static const String refresh = '$_auth/refresh';

  /// Invalidate the current session
  static const String logout = '$_auth/logout';

  /// Fetch the authenticated user's profile
  static const String currentUser = '$_auth/me';

  // ── Academy ────────────────────────────────────────────────────────────────

  /// Fetch a list of educational lessons
  static const String lessons = '$_academy/lessons';

  /// Fetch a specific lesson by its [id]
  static String lesson(String id) => '$lessons/$id';

  // ── Mission Control ────────────────────────────────────────────────────────

  /// Fetch all active missions and global state
  static const String missions = '$_missionControl/missions';

  /// Fetch a specific mission by its [id]
  static String mission(String id) => '$missions/$id';

  // ── Simulation ─────────────────────────────────────────────────────────────

  /// Fetch available simulation scenarios
  static const String simulations = '$_simulation/scenarios';

  /// Fetch a specific simulation scenario by its [id]
  static String simulation(String id) => '$simulations/$id';

  // ── Investigation ──────────────────────────────────────────────────────────

  /// Fetch investigation cases
  static const String cases = '$_investigation/cases';

  /// Fetch a specific investigation case by its [id]
  static String investigationCase(String id) => '$cases/$id';

  // ── Upload ─────────────────────────────────────────────────────────────────

  /// Placeholder endpoint for future Cloudinary integration (e.g. user avatars)
  static const String uploadAvatar = '$_upload/avatar';

  /// Placeholder endpoint for future Cloudinary integration (e.g. case evidence)
  static const String uploadEvidence = '$_upload/evidence';
}
