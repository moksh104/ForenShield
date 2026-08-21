import 'package:flutter/material.dart';

/// Immutable model representing all user settings and preferences.
class SettingsModel {
  final ThemeMode themeMode;
  final double fontScale;
  final bool pushNotifications;
  final bool missionAlerts;
  final bool cyberAcademyAlerts;
  final bool threatIntelligenceAlerts;
  final bool reportsAlerts;
  final bool achievementsAlerts;
  final bool securityAlerts;
  final bool systemNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool emailAlerts;
  final bool threatAlerts;
  final List<String> topicSubscriptions;
  final bool biometricLogin;
  final int autoLogoutMinutes;

  final bool analyticsEnabled;
  final bool crashReports;
  final bool usageStatistics;
  final bool personalizedRecommendations;
  final bool dataSharing;
  final bool locationAccess;
  final bool cameraPermission;
  final bool microphonePermission;
  final bool notificationPermission;

  final bool dataCollectionEnabled;
  final bool autoUpdates;
  final String selectedLanguage;
  final bool developerMode;

  const SettingsModel({
    this.themeMode = ThemeMode.light,
    this.fontScale = 1.0,
    this.pushNotifications = true,
    this.missionAlerts = true,
    this.cyberAcademyAlerts = true,
    this.threatIntelligenceAlerts = true,
    this.reportsAlerts = true,
    this.achievementsAlerts = true,
    this.securityAlerts = true,
    this.systemNotifications = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.emailAlerts = true,
    this.threatAlerts = true,
    this.topicSubscriptions = const [
      'Threat Intelligence',
      'Academy Updates',
      'Security Bulletins',
    ],
    this.biometricLogin = false,
    this.autoLogoutMinutes = 15,
    this.analyticsEnabled = false,
    this.crashReports = false,
    this.usageStatistics = false,
    this.personalizedRecommendations = true,
    this.dataSharing = false,
    this.locationAccess = false,
    this.cameraPermission = false,
    this.microphonePermission = false,
    this.notificationPermission = true,
    this.dataCollectionEnabled = true,
    this.autoUpdates = true,
    this.selectedLanguage = 'English (US)',
    this.developerMode = false,
  });

  SettingsModel copyWith({
    ThemeMode? themeMode,
    double? fontScale,
    bool? pushNotifications,
    bool? missionAlerts,
    bool? cyberAcademyAlerts,
    bool? threatIntelligenceAlerts,
    bool? reportsAlerts,
    bool? achievementsAlerts,
    bool? securityAlerts,
    bool? systemNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? emailAlerts,
    bool? threatAlerts,
    List<String>? topicSubscriptions,
    bool? biometricLogin,
    int? autoLogoutMinutes,
    bool? analyticsEnabled,
    bool? crashReports,
    bool? usageStatistics,
    bool? personalizedRecommendations,
    bool? dataSharing,
    bool? locationAccess,
    bool? cameraPermission,
    bool? microphonePermission,
    bool? notificationPermission,
    bool? dataCollectionEnabled,
    bool? autoUpdates,
    String? selectedLanguage,
    bool? developerMode,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      missionAlerts: missionAlerts ?? this.missionAlerts,
      cyberAcademyAlerts: cyberAcademyAlerts ?? this.cyberAcademyAlerts,
      threatIntelligenceAlerts:
          threatIntelligenceAlerts ?? this.threatIntelligenceAlerts,
      reportsAlerts: reportsAlerts ?? this.reportsAlerts,
      achievementsAlerts: achievementsAlerts ?? this.achievementsAlerts,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      threatAlerts: threatAlerts ?? this.threatAlerts,
      topicSubscriptions: topicSubscriptions ?? this.topicSubscriptions,
      biometricLogin: biometricLogin ?? this.biometricLogin,
      autoLogoutMinutes: autoLogoutMinutes ?? this.autoLogoutMinutes,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReports: crashReports ?? this.crashReports,
      usageStatistics: usageStatistics ?? this.usageStatistics,
      personalizedRecommendations:
          personalizedRecommendations ?? this.personalizedRecommendations,
      dataSharing: dataSharing ?? this.dataSharing,
      locationAccess: locationAccess ?? this.locationAccess,
      cameraPermission: cameraPermission ?? this.cameraPermission,
      microphonePermission: microphonePermission ?? this.microphonePermission,
      notificationPermission:
          notificationPermission ?? this.notificationPermission,
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
      'missionAlerts': missionAlerts,
      'cyberAcademyAlerts': cyberAcademyAlerts,
      'threatIntelligenceAlerts': threatIntelligenceAlerts,
      'reportsAlerts': reportsAlerts,
      'achievementsAlerts': achievementsAlerts,
      'securityAlerts': securityAlerts,
      'systemNotifications': systemNotifications,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'emailAlerts': emailAlerts,
      'threatAlerts': threatAlerts,
      'topicSubscriptions': topicSubscriptions,
      'biometricLogin': biometricLogin,
      'autoLogoutMinutes': autoLogoutMinutes,
      'analyticsEnabled': analyticsEnabled,
      'crashReports': crashReports,
      'usageStatistics': usageStatistics,
      'personalizedRecommendations': personalizedRecommendations,
      'dataSharing': dataSharing,
      'locationAccess': locationAccess,
      'cameraPermission': cameraPermission,
      'microphonePermission': microphonePermission,
      'notificationPermission': notificationPermission,
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
      missionAlerts: json['missionAlerts'] as bool? ?? true,
      cyberAcademyAlerts: json['cyberAcademyAlerts'] as bool? ?? true,
      threatIntelligenceAlerts:
          json['threatIntelligenceAlerts'] as bool? ?? true,
      reportsAlerts: json['reportsAlerts'] as bool? ?? true,
      achievementsAlerts: json['achievementsAlerts'] as bool? ?? true,
      securityAlerts: json['securityAlerts'] as bool? ?? true,
      systemNotifications: json['systemNotifications'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      emailAlerts: json['emailAlerts'] as bool? ?? true,
      threatAlerts: json['threatAlerts'] as bool? ?? true,
      topicSubscriptions:
          (json['topicSubscriptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [
            'Threat Intelligence',
            'Academy Updates',
            'Security Bulletins',
          ],
      biometricLogin: json['biometricLogin'] as bool? ?? false,
      autoLogoutMinutes: json['autoLogoutMinutes'] as int? ?? 15,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? false,
      crashReports: json['crashReports'] as bool? ?? false,
      usageStatistics: json['usageStatistics'] as bool? ?? false,
      personalizedRecommendations:
          json['personalizedRecommendations'] as bool? ?? true,
      dataSharing: json['dataSharing'] as bool? ?? false,
      locationAccess: json['locationAccess'] as bool? ?? false,
      cameraPermission: json['cameraPermission'] as bool? ?? false,
      microphonePermission: json['microphonePermission'] as bool? ?? false,
      notificationPermission: json['notificationPermission'] as bool? ?? true,
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

  factory DeviceSessionModel.fromJson(Map<String, dynamic> json) {
    return DeviceSessionModel(
      id: json['id'] ?? '',
      deviceName: json['device_name'] ?? 'Unknown Device',
      deviceType: json['platform'] ?? 'Unknown Platform',
      ipAddress: json['ip_address'] ?? 'Unknown IP',
      location: json['location'] ?? 'Unknown Location',
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'])
          : DateTime.now(),
      isCurrentDevice: json['is_current'] == true || json['is_current'] == 1,
    );
  }
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

  factory LoginHistoryModel.fromJson(Map<String, dynamic> json) {
    return LoginHistoryModel(
      id: json['id']?.toString() ?? '',
      ipAddress: json['ip_address'] ?? 'Unknown IP',
      location: json['location'] ?? 'Unknown Location',
      device: json['device_name'] ?? 'Unknown Device',
      timestamp: json['login_time'] != null
          ? DateTime.parse(json['login_time'])
          : DateTime.now(),
      isSuccessful: json['status'] == 'success',
    );
  }
}
