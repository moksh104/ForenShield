import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch.dart';

class PrivacyControlsPage extends ConsumerWidget {
  const PrivacyControlsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('Privacy Controls'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'Manage how your data is collected, used, and shared to provide a customized experience.',
              style: TextStyle(color: foren.textSecondary, fontSize: 13),
            ),
          ),
          SettingsSection(
            title: 'Data Collection & Usage',
            children: [
              SettingsSwitch(
                icon: Icons.analytics_outlined,
                title: 'Usage Statistics',
                subtitle: 'Help improve the app by sharing usage data',
                value: settings.usageStatistics,
                onChanged: notifier.toggleUsageStatistics,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.bug_report_outlined,
                title: 'Crash Reports',
                subtitle: 'Automatically send crash logs',
                value: settings.crashReports,
                onChanged: notifier.toggleCrashReports,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.auto_awesome_outlined,
                title: 'Personalized Recommendations',
                subtitle: 'Tailor content based on activity',
                value: settings.personalizedRecommendations,
                onChanged: notifier.togglePersonalizedRecommendations,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.share_outlined,
                title: 'Data Sharing',
                subtitle: 'Share anonymized threat data globally',
                value: settings.dataSharing,
                onChanged: notifier.toggleDataSharing,
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SettingsSection(
            title: 'Permissions',
            children: [
              SettingsSwitch(
                icon: Icons.location_on_outlined,
                title: 'Location Access',
                subtitle: 'Used for localized threat mapping',
                value: settings.locationAccess,
                onChanged: notifier.toggleLocationAccess,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.camera_alt_outlined,
                title: 'Camera Access',
                subtitle: 'For scanning QR codes and MFA',
                value: settings.cameraPermission,
                onChanged: notifier.toggleCameraPermission,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.mic_none_outlined,
                title: 'Microphone Access',
                subtitle: 'For voice-assisted incident reporting',
                value: settings.microphonePermission,
                onChanged: notifier.toggleMicrophonePermission,
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
