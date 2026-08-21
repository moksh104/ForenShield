import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch.dart';

class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Notification Categories'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'Customize which notifications you receive across different modules of ForenShield.',
              style: TextStyle(color: foren.textSecondary, fontSize: 13),
            ),
          ),
          SettingsSection(
            title: 'Core Modules',
            children: [
              SettingsSwitch(
                icon: Icons.dashboard_outlined,
                title: 'Mission Control Alerts',
                subtitle: 'Updates on your dashboard and live feeds',
                value: settings.missionAlerts,
                onChanged: notifier.toggleMissionAlerts,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.school_outlined,
                title: 'Cyber Academy',
                subtitle: 'Course updates and MITRE ATT&CK changes',
                value: settings.cyberAcademyAlerts,
                onChanged: notifier.toggleCyberAcademyAlerts,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.bug_report_outlined,
                title: 'Threat Intelligence',
                subtitle: 'Critical CVE and malware updates',
                value: settings.threatIntelligenceAlerts,
                onChanged: notifier.toggleThreatIntelligenceAlerts,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.insert_chart_outlined,
                title: 'Reports & Analytics',
                subtitle: 'Weekly summary reports availability',
                value: settings.reportsAlerts,
                onChanged: notifier.toggleReportsAlerts,
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SettingsSection(
            title: 'System & Account',
            children: [
              SettingsSwitch(
                icon: Icons.emoji_events_outlined,
                title: 'Achievements',
                subtitle: 'Level ups and leaderboard changes',
                value: settings.achievementsAlerts,
                onChanged: notifier.toggleAchievementsAlerts,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.security_outlined,
                title: 'Security Alerts',
                subtitle: 'New logins and password changes',
                value: settings.securityAlerts,
                onChanged: notifier.toggleSecurityAlerts,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.settings_system_daydream_outlined,
                title: 'System Notifications',
                subtitle: 'App updates and maintenance',
                value: settings.systemNotifications,
                onChanged: notifier.toggleSystemNotifications,
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
