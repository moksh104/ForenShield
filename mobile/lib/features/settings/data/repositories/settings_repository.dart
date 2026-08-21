import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/settings_model.dart';

/// Repository for persisting and managing user settings and storage actions.
class SettingsRepository {
  final StorageService _storage = StorageService();

  static const String _keyFontScale = 'settings_font_scale';
  static const String _keySoundEnabled = 'settings_sound_enabled';
  static const String _keyVibrationEnabled = 'settings_vibration_enabled';
  static const String _keyTopicSubscriptions = 'settings_topic_subscriptions';
  static const String _keySelectedLanguage = 'settings_selected_language';

  static const String _keyMissionAlerts = 'settings_mission_alerts';
  static const String _keyCyberAcademyAlerts = 'settings_cyber_academy_alerts';
  static const String _keyThreatIntelligenceAlerts =
      'settings_threat_alerts_detailed';
  static const String _keyReportsAlerts = 'settings_reports_alerts';
  static const String _keyAchievementsAlerts = 'settings_achievements_alerts';
  static const String _keySecurityAlerts = 'settings_security_alerts';
  static const String _keySystemNotifications = 'settings_system_notifications';

  static const String _keyCrashReports = 'settings_crash_reports';
  static const String _keyUsageStatistics = 'settings_usage_statistics';
  static const String _keyPersonalizedRecs = 'settings_personalized_recs';
  static const String _keyDataSharing = 'settings_data_sharing';
  static const String _keyLocationAccess = 'settings_location_access';
  static const String _keyCameraPermission = 'settings_camera_permission';
  static const String _keyMicrophonePermission =
      'settings_microphone_permission';
  static const String _keyNotificationPermission =
      'settings_notification_permission';

  /// Loads full settings model from persistent local storage.
  Future<SettingsModel> loadSettings() async {
    final themeStr = await _storage.read(StorageKeys.themeMode);
    ThemeMode mode = ThemeMode.light;
    if (themeStr == 'dark') mode = ThemeMode.dark;
    if (themeStr == 'system') mode = ThemeMode.system;

    return SettingsModel(
      themeMode: mode,
      fontScale: (await _storage.readDouble(_keyFontScale)) ?? 1.0,
      pushNotifications:
          (await _storage.readBool(StorageKeys.settingsPushNotifications)) ??
          true,
      missionAlerts: (await _storage.readBool(_keyMissionAlerts)) ?? true,
      cyberAcademyAlerts:
          (await _storage.readBool(_keyCyberAcademyAlerts)) ?? true,
      threatIntelligenceAlerts:
          (await _storage.readBool(_keyThreatIntelligenceAlerts)) ?? true,
      reportsAlerts: (await _storage.readBool(_keyReportsAlerts)) ?? true,
      achievementsAlerts:
          (await _storage.readBool(_keyAchievementsAlerts)) ?? true,
      securityAlerts: (await _storage.readBool(_keySecurityAlerts)) ?? true,
      systemNotifications:
          (await _storage.readBool(_keySystemNotifications)) ?? true,
      soundEnabled: (await _storage.readBool(_keySoundEnabled)) ?? true,
      vibrationEnabled: (await _storage.readBool(_keyVibrationEnabled)) ?? true,
      emailAlerts:
          (await _storage.readBool(StorageKeys.settingsEmailAlerts)) ?? true,
      threatAlerts:
          (await _storage.readBool(StorageKeys.settingsThreatAlerts)) ?? true,
      topicSubscriptions:
          (await _storage.readStringList(_keyTopicSubscriptions)) ??
          ['Threat Intelligence', 'Academy Updates', 'Security Bulletins'],
      biometricLogin:
          (await _storage.readBool(StorageKeys.settingsBiometricLogin)) ??
          false,
      autoLogoutMinutes:
          (await _storage.readInt(StorageKeys.settingsAutoLogoutMinutes)) ?? 15,
      analyticsEnabled:
          (await _storage.readBool(StorageKeys.settingsAnalyticsEnabled)) ??
          false,
      crashReports: (await _storage.readBool(_keyCrashReports)) ?? false,
      usageStatistics: (await _storage.readBool(_keyUsageStatistics)) ?? false,
      personalizedRecommendations:
          (await _storage.readBool(_keyPersonalizedRecs)) ?? true,
      dataSharing: (await _storage.readBool(_keyDataSharing)) ?? false,
      locationAccess: (await _storage.readBool(_keyLocationAccess)) ?? false,
      cameraPermission:
          (await _storage.readBool(_keyCameraPermission)) ?? false,
      microphonePermission:
          (await _storage.readBool(_keyMicrophonePermission)) ?? false,
      notificationPermission:
          (await _storage.readBool(_keyNotificationPermission)) ?? true,
      dataCollectionEnabled:
          (await _storage.readBool(
            StorageKeys.settingsDataCollectionEnabled,
          )) ??
          true,
      autoUpdates:
          (await _storage.readBool(StorageKeys.settingsAutoUpdates)) ?? true,
      selectedLanguage:
          (await _storage.read(_keySelectedLanguage)) ?? 'English (US)',
      developerMode:
          (await _storage.readBool(StorageKeys.settingsDeveloperMode)) ?? false,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    String modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.system) modeStr = 'system';
    await _storage.write(StorageKeys.themeMode, modeStr);
  }

  Future<void> saveFontScale(double scale) async =>
      await _storage.writeDouble(_keyFontScale, scale);
  Future<void> savePushNotifications(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsPushNotifications, val);

  Future<void> saveMissionAlerts(bool val) async =>
      await _storage.writeBool(_keyMissionAlerts, val);
  Future<void> saveCyberAcademyAlerts(bool val) async =>
      await _storage.writeBool(_keyCyberAcademyAlerts, val);
  Future<void> saveThreatIntelligenceAlerts(bool val) async =>
      await _storage.writeBool(_keyThreatIntelligenceAlerts, val);
  Future<void> saveReportsAlerts(bool val) async =>
      await _storage.writeBool(_keyReportsAlerts, val);
  Future<void> saveAchievementsAlerts(bool val) async =>
      await _storage.writeBool(_keyAchievementsAlerts, val);
  Future<void> saveSecurityAlerts(bool val) async =>
      await _storage.writeBool(_keySecurityAlerts, val);
  Future<void> saveSystemNotifications(bool val) async =>
      await _storage.writeBool(_keySystemNotifications, val);

  Future<void> saveSoundEnabled(bool val) async =>
      await _storage.writeBool(_keySoundEnabled, val);
  Future<void> saveVibrationEnabled(bool val) async =>
      await _storage.writeBool(_keyVibrationEnabled, val);
  Future<void> saveThreatAlerts(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsThreatAlerts, val);
  Future<void> saveEmailAlerts(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsEmailAlerts, val);
  Future<void> saveTopicSubscriptions(List<String> topics) async =>
      await _storage.writeStringList(_keyTopicSubscriptions, topics);
  Future<void> saveBiometricLogin(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsBiometricLogin, val);
  Future<void> saveAutoLogoutMinutes(int minutes) async =>
      await _storage.writeInt(StorageKeys.settingsAutoLogoutMinutes, minutes);

  Future<void> saveAnalyticsEnabled(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsAnalyticsEnabled, val);
  Future<void> saveCrashReports(bool val) async =>
      await _storage.writeBool(_keyCrashReports, val);
  Future<void> saveUsageStatistics(bool val) async =>
      await _storage.writeBool(_keyUsageStatistics, val);
  Future<void> savePersonalizedRecommendations(bool val) async =>
      await _storage.writeBool(_keyPersonalizedRecs, val);
  Future<void> saveDataSharing(bool val) async =>
      await _storage.writeBool(_keyDataSharing, val);
  Future<void> saveLocationAccess(bool val) async =>
      await _storage.writeBool(_keyLocationAccess, val);
  Future<void> saveCameraPermission(bool val) async =>
      await _storage.writeBool(_keyCameraPermission, val);
  Future<void> saveMicrophonePermission(bool val) async =>
      await _storage.writeBool(_keyMicrophonePermission, val);
  Future<void> saveNotificationPermission(bool val) async =>
      await _storage.writeBool(_keyNotificationPermission, val);

  Future<void> saveDataCollectionEnabled(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsDataCollectionEnabled, val);
  Future<void> saveAutoUpdates(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsAutoUpdates, val);
  Future<void> saveLanguage(String lang) async =>
      await _storage.write(_keySelectedLanguage, lang);
  Future<void> saveDeveloperMode(bool val) async =>
      await _storage.writeBool(StorageKeys.settingsDeveloperMode, val);

  /// Calculates the current cache size in MB.

  Future<void> clearAllSettings() async {
    final keys = [
      StorageKeys.themeMode,
      _keyFontScale,
      StorageKeys.settingsPushNotifications,
      _keyMissionAlerts,
      _keyCyberAcademyAlerts,
      _keyThreatIntelligenceAlerts,
      _keyReportsAlerts,
      _keyAchievementsAlerts,
      _keySecurityAlerts,
      _keySystemNotifications,
      _keySoundEnabled,
      _keyVibrationEnabled,
      StorageKeys.settingsEmailAlerts,
      StorageKeys.settingsThreatAlerts,
      _keyTopicSubscriptions,
      StorageKeys.settingsBiometricLogin,
      StorageKeys.settingsAutoLogoutMinutes,
      StorageKeys.settingsAnalyticsEnabled,
      _keyCrashReports,
      _keyUsageStatistics,
      _keyPersonalizedRecs,
      _keyDataSharing,
      _keyLocationAccess,
      _keyCameraPermission,
      _keyMicrophonePermission,
      _keyNotificationPermission,
      StorageKeys.settingsDataCollectionEnabled,
      StorageKeys.settingsAutoUpdates,
      _keySelectedLanguage,
      StorageKeys.settingsDeveloperMode,
    ];
    for (var key in keys) {
      await _storage.delete(key);
    }
  }

  Future<double> getCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (!tempDir.existsSync()) return 0.0;

      double totalSize = 0;
      final files = tempDir.listSync(recursive: true);
      for (final file in files) {
        if (file is File) {
          totalSize += file.lengthSync();
        }
      }
      return totalSize / (1024 * 1024);
    } catch (e) {
      return 0.0;
    }
  }

  /// Clears the application cache and returns the freed space in MB.
  Future<double> clearAppCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (!tempDir.existsSync()) return 0.0;

      final initialSize = await getCacheSize();

      final files = tempDir.listSync(recursive: true);
      for (final file in files) {
        try {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            // we typically leave subdirs or try to delete them if empty
            await file.delete(recursive: true);
          }
        } catch (_) {}
      }

      return initialSize;
    } catch (e) {
      return 0.0;
    }
  }
}
