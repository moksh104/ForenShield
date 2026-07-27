import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/storage_service.dart';

/// App Settings State.
class SettingsState {
  final ThemeMode themeMode;
  final bool pushNotifications;
  final bool threatAlerts;
  final bool emailAlerts;
  final bool analyticsEnabled;
  final bool biometricLogin;
  final bool autoUpdates;
  final bool developerMode;

  const SettingsState({
    this.themeMode = ThemeMode.dark,
    this.pushNotifications = true,
    this.threatAlerts = true,
    this.emailAlerts = true,
    this.analyticsEnabled = false,
    this.biometricLogin = false,
    this.autoUpdates = true,
    this.developerMode = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? pushNotifications,
    bool? threatAlerts,
    bool? emailAlerts,
    bool? analyticsEnabled,
    bool? biometricLogin,
    bool? autoUpdates,
    bool? developerMode,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      threatAlerts: threatAlerts ?? this.threatAlerts,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      biometricLogin: biometricLogin ?? this.biometricLogin,
      autoUpdates: autoUpdates ?? this.autoUpdates,
      developerMode: developerMode ?? this.developerMode,
    );
  }
}

/// StateNotifier for Settings persistence.
class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storage = StorageService();

  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final themeStr = await _storage.read(StorageKeys.themeMode);
    ThemeMode mode = ThemeMode.dark;
    if (themeStr == 'light') mode = ThemeMode.light;
    if (themeStr == 'system') mode = ThemeMode.system;

    final push = await _storage.readBool(StorageKeys.settingsPushNotifications) ?? true;
    final threat = await _storage.readBool(StorageKeys.settingsThreatAlerts) ?? true;
    final email = await _storage.readBool(StorageKeys.settingsEmailAlerts) ?? true;
    final analytics = await _storage.readBool(StorageKeys.settingsAnalyticsEnabled) ?? false;
    final bio = await _storage.readBool(StorageKeys.settingsBiometricLogin) ?? false;
    final autoUpd = await _storage.readBool(StorageKeys.settingsAutoUpdates) ?? true;
    final dev = await _storage.readBool(StorageKeys.settingsDeveloperMode) ?? false;

    state = SettingsState(
      themeMode: mode,
      pushNotifications: push,
      threatAlerts: threat,
      emailAlerts: email,
      analyticsEnabled: analytics,
      biometricLogin: bio,
      autoUpdates: autoUpd,
      developerMode: dev,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String modeStr = 'dark';
    if (mode == ThemeMode.light) modeStr = 'light';
    if (mode == ThemeMode.system) modeStr = 'system';
    await _storage.write(StorageKeys.themeMode, modeStr);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> togglePushNotifications(bool val) async {
    await _storage.writeBool(StorageKeys.settingsPushNotifications, val);
    state = state.copyWith(pushNotifications: val);
  }

  Future<void> toggleThreatAlerts(bool val) async {
    await _storage.writeBool(StorageKeys.settingsThreatAlerts, val);
    state = state.copyWith(threatAlerts: val);
  }

  Future<void> toggleEmailAlerts(bool val) async {
    await _storage.writeBool(StorageKeys.settingsEmailAlerts, val);
    state = state.copyWith(emailAlerts: val);
  }

  Future<void> toggleAnalytics(bool val) async {
    await _storage.writeBool(StorageKeys.settingsAnalyticsEnabled, val);
    state = state.copyWith(analyticsEnabled: val);
  }

  Future<void> toggleBiometricLogin(bool val) async {
    await _storage.writeBool(StorageKeys.settingsBiometricLogin, val);
    state = state.copyWith(biometricLogin: val);
  }

  Future<void> toggleAutoUpdates(bool val) async {
    await _storage.writeBool(StorageKeys.settingsAutoUpdates, val);
    state = state.copyWith(autoUpdates: val);
  }

  Future<void> toggleDeveloperMode(bool val) async {
    await _storage.writeBool(StorageKeys.settingsDeveloperMode, val);
    state = state.copyWith(developerMode: val);
  }

  Future<void> resetSettings() async {
    await _storage.delete(StorageKeys.themeMode);
    await _storage.delete(StorageKeys.settingsPushNotifications);
    await _storage.delete(StorageKeys.settingsThreatAlerts);
    await _storage.delete(StorageKeys.settingsEmailAlerts);
    await _storage.delete(StorageKeys.settingsAnalyticsEnabled);
    await _storage.delete(StorageKeys.settingsBiometricLogin);
    await _storage.delete(StorageKeys.settingsAutoUpdates);
    await _storage.delete(StorageKeys.settingsDeveloperMode);

    state = const SettingsState();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});
