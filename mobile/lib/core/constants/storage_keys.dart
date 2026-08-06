/// Centralized storage key constants for ForenShield.
///
/// All [SharedPreferences] keys are defined here as the single source of truth.
/// This prevents key duplication and typo-driven bugs across the codebase.
/// The backend stack uses PHP REST API + JWT; tokens are stored here locally.
class StorageKeys {
  StorageKeys._();

  // ── Onboarding ──────────────────────────────────────────────────────────────
  /// `bool` — true if the user has completed the onboarding flow at least once.
  static const String hasSeenOnboarding = 'forenshield_onboarding_complete';

  // ── Authentication ──────────────────────────────────────────────────────────
  /// `String` — JWT access token.
  static const String authAccessToken = 'forenshield_auth_access_token';

  /// `bool` — true if user is logged in.
  static const String isLoggedIn = 'isLoggedIn';

  /// `String` — JWT refresh token.
  static const String authRefreshToken = 'forenshield_auth_refresh_token';

  /// `String` — User ID.
  static const String userId = 'user_id';

  /// `String` — User Email.
  static const String userEmail = 'user_email';

  // ── User Preferences ────────────────────────────────────────────────────────
  /// `String` — locale code override (e.g. 'en', 'fr'). Null = system default.
  static const String preferredLocale = 'forenshield_preferred_locale';

  /// `String` — theme mode: 'dark' | 'light' | 'system'.
  static const String themeMode = 'forenshield_theme_mode';

  // ── App State ───────────────────────────────────────────────────────────────
  /// `String` — last active route, used for deep-link restoration.
  static const String lastRoute = 'forenshield_last_route';

  // ── Profile Persistence ──────────────────────────────────────────────────────
  static const String profileFullName = 'profile_full_name';
  static const String profileEmail = 'profile_email';
  static const String profileBio = 'profile_bio';
  static const String profilePhone = 'profile_phone';
  static const String profileAvatarPath = 'profile_avatar_path';

  // ── Settings Switches ────────────────────────────────────────────────────────
  static const String settingsPushNotifications = 'settings_push_notifications';
  static const String settingsThreatAlerts = 'settings_threat_alerts';
  static const String settingsEmailAlerts = 'settings_email_alerts';
  static const String settingsAnalyticsEnabled = 'settings_analytics_enabled';
  static const String settingsBiometricLogin = 'settings_biometric_login';
  static const String settingsAutoUpdates = 'settings_auto_updates';
  static const String settingsDeveloperMode = 'settings_developer_mode';
  static const String settingsAutoLogoutMinutes = 'settings_auto_logout_minutes';
  static const String settingsDataCollectionEnabled = 'settings_data_collection_enabled';
}
