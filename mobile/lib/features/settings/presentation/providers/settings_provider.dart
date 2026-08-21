import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/settings_model.dart';
import '../../data/repositories/settings_repository.dart';

/// StateNotifier for Settings persistence and state management.
class SettingsNotifier extends StateNotifier<SettingsModel> {
  final SettingsRepository _repository = SettingsRepository();

  SettingsNotifier() : super(const SettingsModel()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.loadSettings();
    state = settings;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repository.saveThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setFontScale(double scale) async {
    await _repository.saveFontScale(scale);
    state = state.copyWith(fontScale: scale);
  }

  Future<void> togglePushNotifications(bool val) async {
    await _repository.savePushNotifications(val);
    state = state.copyWith(pushNotifications: val);
  }

  Future<void> toggleSoundEnabled(bool val) async {
    await _repository.saveSoundEnabled(val);
    state = state.copyWith(soundEnabled: val);
  }

  Future<void> toggleVibrationEnabled(bool val) async {
    await _repository.saveVibrationEnabled(val);
    state = state.copyWith(vibrationEnabled: val);
  }

  Future<void> toggleThreatAlerts(bool val) async {
    await _repository.saveThreatAlerts(val);
    state = state.copyWith(threatAlerts: val);
  }

  Future<void> toggleEmailAlerts(bool val) async {
    await _repository.saveEmailAlerts(val);
    state = state.copyWith(emailAlerts: val);
  }

  Future<void> toggleTopicSubscription(String topic) async {
    final updated = List<String>.from(state.topicSubscriptions);
    if (updated.contains(topic)) {
      updated.remove(topic);
    } else {
      updated.add(topic);
    }
    await _repository.saveTopicSubscriptions(updated);
    state = state.copyWith(topicSubscriptions: updated);
  }

  Future<void> toggleBiometricLogin(bool val) async {
    await _repository.saveBiometricLogin(val);
    state = state.copyWith(biometricLogin: val);
  }

  Future<void> setAutoLogoutMinutes(int minutes) async {
    await _repository.saveAutoLogoutMinutes(minutes);
    state = state.copyWith(autoLogoutMinutes: minutes);
  }

  Future<void> toggleAnalytics(bool val) async {
    await _repository.saveAnalyticsEnabled(val);
    state = state.copyWith(analyticsEnabled: val);
  }

  Future<void> toggleCrashReports(bool val) async {
    await _repository.saveCrashReports(val);
    state = state.copyWith(crashReports: val);
  }

  Future<void> toggleUsageStatistics(bool val) async {
    await _repository.saveUsageStatistics(val);
    state = state.copyWith(usageStatistics: val);
  }

  Future<void> togglePersonalizedRecommendations(bool val) async {
    await _repository.savePersonalizedRecommendations(val);
    state = state.copyWith(personalizedRecommendations: val);
  }

  Future<void> toggleDataSharing(bool val) async {
    await _repository.saveDataSharing(val);
    state = state.copyWith(dataSharing: val);
  }

  Future<void> toggleLocationAccess(bool val) async {
    await _repository.saveLocationAccess(val);
    state = state.copyWith(locationAccess: val);
  }

  Future<void> toggleCameraPermission(bool val) async {
    await _repository.saveCameraPermission(val);
    state = state.copyWith(cameraPermission: val);
  }

  Future<void> toggleMicrophonePermission(bool val) async {
    await _repository.saveMicrophonePermission(val);
    state = state.copyWith(microphonePermission: val);
  }

  Future<void> toggleNotificationPermission(bool val) async {
    await _repository.saveNotificationPermission(val);
    state = state.copyWith(notificationPermission: val);
  }

  Future<void> toggleMissionAlerts(bool val) async {
    await _repository.saveMissionAlerts(val);
    state = state.copyWith(missionAlerts: val);
  }

  Future<void> toggleCyberAcademyAlerts(bool val) async {
    await _repository.saveCyberAcademyAlerts(val);
    state = state.copyWith(cyberAcademyAlerts: val);
  }

  Future<void> toggleThreatIntelligenceAlerts(bool val) async {
    await _repository.saveThreatIntelligenceAlerts(val);
    state = state.copyWith(threatIntelligenceAlerts: val);
  }

  Future<void> toggleReportsAlerts(bool val) async {
    await _repository.saveReportsAlerts(val);
    state = state.copyWith(reportsAlerts: val);
  }

  Future<void> toggleAchievementsAlerts(bool val) async {
    await _repository.saveAchievementsAlerts(val);
    state = state.copyWith(achievementsAlerts: val);
  }

  Future<void> toggleSecurityAlerts(bool val) async {
    await _repository.saveSecurityAlerts(val);
    state = state.copyWith(securityAlerts: val);
  }

  Future<void> toggleSystemNotifications(bool val) async {
    await _repository.saveSystemNotifications(val);
    state = state.copyWith(systemNotifications: val);
  }

  Future<void> toggleDataCollection(bool val) async {
    await _repository.saveDataCollectionEnabled(val);
    state = state.copyWith(dataCollectionEnabled: val);
  }

  Future<void> toggleAutoUpdates(bool val) async {
    await _repository.saveAutoUpdates(val);
    state = state.copyWith(autoUpdates: val);
  }

  Future<void> setLanguage(String lang) async {
    await _repository.saveLanguage(lang);
    state = state.copyWith(selectedLanguage: lang);
  }

  Future<void> toggleDeveloperMode(bool val) async {
    await _repository.saveDeveloperMode(val);
    state = state.copyWith(developerMode: val);
  }

  Future<void> resetSettings() async {
    await _repository.clearAllSettings();
    state = const SettingsModel(); // restores default instantiation
  }

  Future<double> getCacheSize() async {
    return await _repository.getCacheSize();
  }

  Future<double> clearCache() async {
    return await _repository.clearAppCache();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>(
  (ref) {
    return SettingsNotifier();
  },
);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

final fontScaleProvider = Provider<double>((ref) {
  return ref.watch(settingsProvider).fontScale;
});
