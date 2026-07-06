/// ForenShield Application Constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'ForenShield';
  static const String appTagline = 'Learn. Investigate. Defend.';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyIsFirstLaunch = 'is_first_launch';

  // Gamification - XP Awards
  static const int xpLessonComplete = 50;
  static const int xpQuizPass = 25;
  static const int xpQuizPerfect = 50;
  static const int xpSimulationComplete = 20;
  static const int xpSimulationCorrectPath = 80;
  static const int xpInvestigationEasy = 150;
  static const int xpInvestigationMedium = 300;
  static const int xpInvestigationHard = 500;
  static const int xpReportGenerated = 25;
  static const int xpStreak3Days = 30;
  static const int xpStreak7Days = 100;
  static const int xpDailyChallenge = 40;

  // Rank Thresholds
  static const Map<String, int> rankThresholds = {
    'Trainee': 0,
    'Analyst': 200,
    'Investigator': 600,
    'Specialist': 1400,
    'Senior Analyst': 2800,
    'Expert': 5000,
    'ForenShield Elite': 9000,
  };

  // UI Constants
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 8.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorUnauthorized = 'Session expired. Please log in again.';

  // Assets
  static const String assetsLottie = 'assets/lottie/';
  static const String assetsImages = 'assets/images/';
  static const String assetsIcons = 'assets/icons/';
}
