import 'package:flutter/material.dart';

/// Immutable model representing all user settings and preferences.
class SettingsModel {
  final ThemeMode themeMode;
  final double fontScale;
  final bool pushNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool emailAlerts;
  final bool threatAlerts;
  final List<String> topicSubscriptions;
  final bool biometricLogin;
  final int autoLogoutMinutes;
  final bool analyticsEnabled;
  final bool dataCollectionEnabled;
  final bool autoUpdates;
  final String selectedLanguage;
  final bool developerMode;

  const SettingsModel({
    this.themeMode = ThemeMode.light,
    this.fontScale = 1.0,
    this.pushNotifications = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.emailAlerts = true,
    this.threatAlerts = true,
    this.topicSubscriptions = const [
      'Threat Intelligence',
      'Academy Updates',
      'Security Bulletins'
    ],
    this.biometricLogin = false,
    this.autoLogoutMinutes = 15,
    this.analyticsEnabled = false,
    this.dataCollectionEnabled = true,
    this.autoUpdates = true,
    this.selectedLanguage = 'English (US)',
    this.developerMode = false,
  });

  SettingsModel copyWith({
    ThemeMode? themeMode,
    double? fontScale,
    bool? pushNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? emailAlerts,
    bool? threatAlerts,
    List<String>? topicSubscriptions,
    bool? biometricLogin,
    int? autoLogoutMinutes,
    bool? analyticsEnabled,
    bool? dataCollectionEnabled,
    bool? autoUpdates,
    String? selectedLanguage,
    bool? developerMode,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      threatAlerts: threatAlerts ?? this.threatAlerts,
      topicSubscriptions: topicSubscriptions ?? this.topicSubscriptions,
      biometricLogin: biometricLogin ?? this.biometricLogin,
      autoLogoutMinutes: autoLogoutMinutes ?? this.autoLogoutMinutes,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      dataCollectionEnabled:
          dataCollectionEnabled ?? this.dataCollectionEnabled,
      autoUpdates: autoUpdates ?? this.autoUpdates,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      developerMode: developerMode ?? this.developerMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'fontScale': fontScale,
      'pushNotifications': pushNotifications,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'emailAlerts': emailAlerts,
      'threatAlerts': threatAlerts,
      'topicSubscriptions': topicSubscriptions,
      'biometricLogin': biometricLogin,
      'autoLogoutMinutes': autoLogoutMinutes,
      'analyticsEnabled': analyticsEnabled,
      'dataCollectionEnabled': dataCollectionEnabled,
      'autoUpdates': autoUpdates,
      'selectedLanguage': selectedLanguage,
      'developerMode': developerMode,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    ThemeMode mode = ThemeMode.light;
    final themeStr = json['themeMode'] as String?;
    if (themeStr == 'dark') mode = ThemeMode.dark;
    if (themeStr == 'system') mode = ThemeMode.system;

    return SettingsModel(
      themeMode: mode,
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      emailAlerts: json['emailAlerts'] as bool? ?? true,
      threatAlerts: json['threatAlerts'] as bool? ?? true,
      topicSubscriptions: (json['topicSubscriptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Threat Intelligence', 'Academy Updates', 'Security Bulletins'],
      biometricLogin: json['biometricLogin'] as bool? ?? false,
      autoLogoutMinutes: json['autoLogoutMinutes'] as int? ?? 15,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? false,
      dataCollectionEnabled: json['dataCollectionEnabled'] as bool? ?? true,
      autoUpdates: json['autoUpdates'] as bool? ?? true,
      selectedLanguage: json['selectedLanguage'] as String? ?? 'English (US)',
      developerMode: json['developerMode'] as bool? ?? false,
    );
  }
}

/// UI Model for Device Sessions (Placeholder/Mock UI)
class DeviceSessionModel {
  final String id;
  final String deviceName;
  final String deviceType;
  final String ipAddress;
  final String location;
  final DateTime lastActive;
  final bool isCurrentDevice;

  const DeviceSessionModel({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    required this.ipAddress,
    required this.location,
    required this.lastActive,
    this.isCurrentDevice = false,
  });
}

/// UI Model for Login History (Mock UI Data)
class LoginHistoryModel {
  final String id;
  final String ipAddress;
  final String location;
  final String device;
  final DateTime timestamp;
  final bool isSuccessful;

  const LoginHistoryModel({
    required this.id,
    required this.ipAddress,
    required this.location,
    required this.device,
    required this.timestamp,
    this.isSuccessful = true,
  });
}
