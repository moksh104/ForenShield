/// Centralized registry for all API endpoint routes in ForenShield.
///
/// Organized by feature domain. All paths are appended to the `apiBaseUrl`.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Authentication ─────────────────────────────────────────────────────────

  /// Login with email and password
  static const String login = '/login.php';

  /// Register a new account
  static const String register = '/register.php';

  /// Invalidate the current session
  static const String logout = '/logout.php';

  /// Exchange a refresh token for a new access token
  static const String refresh = '/refresh_token.php';

  /// Send password reset request
  static const String forgotPassword = '/forgot_password.php';

  /// Verify 6-digit OTP code
  static const String verifyOtp = '/verify_otp.php';

  /// Fetch the authenticated user's profile
  static const String currentUser = '/current_user.php';

  // ── Upload ─────────────────────────────────────────────────────────────────

  /// Upload an image to Cloudinary
  static const String uploadImage = '/upload_image.php';

  /// Delete an image from Cloudinary
  static const String deleteImage = '/delete_image.php';

  // ── Profile ────────────────────────────────────────────────────────────────

  static const String profile = '/profile.php';
  static const String updateProfile = '/update_profile.php';

  // ── Leaderboard ────────────────────────────────────────────────────────────

  static const String leaderboard = '/leaderboard.php';
  static const String leaderboardGlobal = '/leaderboard/global.php';
  static const String leaderboardWeekly = '/leaderboard/weekly.php';
  static const String leaderboardMonthly = '/leaderboard/monthly.php';
  static const String leaderboardTopInvestigators =
      '/leaderboard/top_investigators.php';
  static const String leaderboardTopLearners = '/leaderboard/top_learners.php';
  static const String leaderboardProfileRank = '/leaderboard/profile_rank.php';

  // ── XP / Progression ───────────────────────────────────────────────────────

  // ── Achievements ───────────────────────────────────────────────────────────

  static const String achievementsList = '/achievements/list.php';
  static const String achievementsUnlock = '/achievements/unlock.php';
  static const String achievementsProgress = '/achievements/progress.php';
  static const String achievementsCheck = '/achievements/check.php';

  // ── Mission Control ────────────────────────────────────────────────────────

  static const String missionControl = '/mission_control.php';

  // ── Investigation ──────────────────────────────────────────────────────────

  static const String investigationCases = '/investigation_cases.php';
  static const String investigationCaseDetail =
      '/investigation_case_detail.php';
  static const String investigationEvidence = '/investigation_evidence.php';
  static const String investigationVerdict = '/investigation_verdict.php';

  // ── Cyber Academy ──────────────────────────────────────────────────────────

  static const String academyCourses = '/academy_courses.php';
  static const String academyCourseDetail = '/academy_course_detail.php';
  static const String academyLesson = '/academy_lesson.php';
  static const String academyQuizSubmit = '/academy_quiz_submit.php';

  static const String lessons = '/academy_courses.php';
  static String lesson(String id) => '/academy_lesson.php';

  // ── Reports ────────────────────────────────────────────────────────────────

  static const String reports = '/reports.php';

  // ── Live Intelligence ──────────────────────────────────────────────────────

  /// CISA Known Exploited Vulnerabilities feed
  static const String cisaKev = '/cisa_kev.php';

  /// MITRE ATT&CK technique catalogue
  static const String mitreAttack = '/mitre_attack.php';

  /// NVD vulnerability statistics
  static const String nvd = '/nvd.php';

  /// VirusTotal file/URL/IP analysis (backend-proxied; API key is server-side only)
  static const String virusTotal = '/virustotal.php';

  // ── Settings ───────────────────────────────────────────────────────────────

  /// List active device sessions
  static const String settingsDevices = '/settings/devices.php';

  /// Revoke a specific device session
  static const String settingsRevokeDevice = '/settings/revoke_device.php';

  /// Fetch login history
  static const String settingsLoginHistory = '/settings/login_history.php';

  /// Delete account (requires password confirmation)
  static const String settingsDeleteAccount = '/settings/delete_account.php';

  /// Export user data archive
  static const String settingsExportData = '/settings/export_data.php';

  // ── Notifications ──────────────────────────────────────────────────────────

  /// Save user FCM registration token
  static const String saveFcmToken = '/save_fcm_token.php';

  /// Fetch notifications and mark as read
  static const String notifications = '/notifications.php';

  /// Dedicated endpoint for marking notifications as read
  static const String markAsRead = '/mark_as_read.php';
}
