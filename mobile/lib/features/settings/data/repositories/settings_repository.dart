import 'package:flutter/material.dart';
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

  /// Loads full settings model from persistent local storage.
  Future<SettingsModel> loadSettings() async {
    final themeStr = await _storage.read(StorageKeys.themeMode);
    ThemeMode mode = ThemeMode.light;
    if (themeStr == 'dark') mode = ThemeMode.dark;
    if (themeStr == 'system') mode = ThemeMode.system;

    final fontScale = (await _storage.readDouble(_keyFontScale)) ?? 1.0;
    final push = (await _storage.readBool(StorageKeys.settingsPushNotifications)) ?? true;
    final sound = (await _storage.readBool(_keySoundEnabled)) ?? true;
    final vibration = (await _storage.readBool(_keyVibrationEnabled)) ?? true;
    final threat = (await _storage.readBool(StorageKeys.settingsThreatAlerts)) ?? true;
    final email = (await _storage.readBool(StorageKeys.settingsEmailAlerts)) ?? true;
    final topicsList = (await _storage.readStringList(_keyTopicSubscriptions)) ??
        ['Threat Intelligence', 'Academy Updates', 'Security Bulletins'];
    final bio = (await _storage.readBool(StorageKeys.settingsBiometricLogin)) ?? false;
    final autoLogout = (await _storage.readInt(StorageKeys.settingsAutoLogoutMinutes)) ?? 15;
    final analytics = (await _storage.readBool(StorageKeys.settingsAnalyticsEnabled)) ?? false;
    final dataColl = (await _storage.readBool(StorageKeys.settingsDataCollectionEnabled)) ?? true;
    final autoUpd = (await _storage.readBool(StorageKeys.settingsAutoUpdates)) ?? true;
    final lang = (await _storage.read(_keySelectedLanguage)) ?? 'English (US)';
    final dev = (await _storage.readBool(StorageKeys.settingsDeveloperMode)) ?? false;

    return SettingsModel(
      themeMode: mode,
      fontScale: fontScale,
      pushNotifications: push,
      soundEnabled: sound,
      vibrationEnabled: vibration,
      emailAlerts: email,
      threatAlerts: threat,
      topicSubscriptions: topicsList,
      biometricLogin: bio,
      autoLogoutMinutes: autoLogout,
      analyticsEnabled: analytics,
      dataCollectionEnabled: dataColl,
      autoUpdates: autoUpd,
      selectedLanguage: lang,
      developerMode: dev,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    String modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.system) modeStr = 'system';
    await _storage.write(StorageKeys.themeMode, modeStr);
  }

  Future<void> saveFontScale(double scale) async {
    await _storage.writeDouble(_keyFontScale, scale);
  }

  Future<void> savePushNotifications(bool val) async {
    await _storage.writeBool(StorageKeys.settingsPushNotifications, val);
  }

  Future<void> saveSoundEnabled(bool val) async {
    await _storage.writeBool(_keySoundEnabled, val);
  }

  Future<void> saveVibrationEnabled(bool val) async {
    await _storage.writeBool(_keyVibrationEnabled, val);
  }

  Future<void> saveThreatAlerts(bool val) async {
    await _storage.writeBool(StorageKeys.settingsThreatAlerts, val);
  }

  Future<void> saveEmailAlerts(bool val) async {
    await _storage.writeBool(StorageKeys.settingsEmailAlerts, val);
  }

  Future<void> saveTopicSubscriptions(List<String> topics) async {
    await _storage.writeStringList(_keyTopicSubscriptions, topics);
  }

  Future<void> saveBiometricLogin(bool val) async {
    await _storage.writeBool(StorageKeys.settingsBiometricLogin, val);
  }

  Future<void> saveAutoLogoutMinutes(int minutes) async {
    await _storage.writeInt(StorageKeys.settingsAutoLogoutMinutes, minutes);
  }

  Future<void> saveAnalyticsEnabled(bool val) async {
    await _storage.writeBool(StorageKeys.settingsAnalyticsEnabled, val);
  }

  Future<void> saveDataCollectionEnabled(bool val) async {
    await _storage.writeBool(StorageKeys.settingsDataCollectionEnabled, val);
  }

  Future<void> saveAutoUpdates(bool val) async {
    await _storage.writeBool(StorageKeys.settingsAutoUpdates, val);
  }

  Future<void> saveLanguage(String lang) async {
    await _storage.write(_keySelectedLanguage, lang);
  }

  Future<void> saveDeveloperMode(bool val) async {
    await _storage.writeBool(StorageKeys.settingsDeveloperMode, val);
  }

  /// Simulates cache clearing operation.
  Future<int> clearAppCache() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 42; // cleared 42 MB
  }
}
