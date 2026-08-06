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
  static const String leaderboard = '/leaderboard.php';
  static const String updateXp = '/update_xp.php';
  static const String achievements = '/achievements.php';
  static const String updateProfile = '/update_profile.php';

  // ── Mission Control ────────────────────────────────────────────────────────

  static const String missionControl = '/mission_control.php';

  // ── Investigation ──────────────────────────────────────────────────────────

  static const String investigationCases = '/investigation_cases.php';
  static const String investigationCaseDetail = '/investigation_case_detail.php';
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

  // ── Notifications ──────────────────────────────────────────────────────────

  /// Save user FCM registration token
  static const String saveFcmToken = '/save_fcm_token.php';

  /// Fetch notifications and mark as read
  static const String notifications = '/notifications.php';

  /// Dedicated endpoint for marking notifications as read
  static const String markAsRead = '/mark_as_read.php';
}
