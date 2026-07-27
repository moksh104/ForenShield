import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../providers/settings_provider.dart';

/// App Settings Screen for ForenShield.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void _notifySaved(String message) {
    if (!mounted) return;
    final foren = Theme.of(context).extension<ForenColors>()!;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: foren.success.t500,
      ),
    );
  }

  void _showThemeModeDialog() {
    final theme = Theme.of(context);
    final settings = ref.read(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Select Theme Mode',
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        children: [
          ListTile(
            title: Text('Dark Cyber Theme (Default)', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
            trailing: settings.themeMode == ThemeMode.dark ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
            onTap: () {
              notifier.setThemeMode(ThemeMode.dark);
              Navigator.pop(ctx);
              _notifySaved('Settings Saved');
            },
          ),
          ListTile(
            title: Text('Light Theme', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
            trailing: settings.themeMode == ThemeMode.light ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
            onTap: () {
              notifier.setThemeMode(ThemeMode.light);
              Navigator.pop(ctx);
              _notifySaved('Settings Saved');
            },
          ),
          ListTile(
            title: Text('System Default', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
            trailing: settings.themeMode == ThemeMode.system ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
            onTap: () {
              notifier.setThemeMode(ThemeMode.system);
              Navigator.pop(ctx);
              _notifySaved('Settings Saved');
            },
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog() {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final notifier = ref.read(settingsProvider.notifier);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Reset All Settings?',
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to restore all settings, preferences, and flags to their default values?',
          style: TextStyle(color: foren.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.resetSettings();
              Navigator.pop(ctx);
              _notifySaved('Settings Reset to Defaults');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: foren.critical.t500,
              foregroundColor: theme.colorScheme.onSurface,
            ),
            child: const Text('Reset Defaults'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final textController = TextEditingController();
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Send Feedback', style: TextStyle(color: theme.colorScheme.onSurface)),
        content: TextField(
          controller: textController,
          maxLines: 3,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Share your suggestions or report issues...',
            hintStyle: TextStyle(color: foren.textDisabled),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _notifySaved('Thank you for your feedback!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: theme.scaffoldBackgroundColor,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final criticalColor = foren.critical.t500;

    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    String themeName = 'Dark';
    if (settings.themeMode == ThemeMode.light) themeName = 'Light';
    if (settings.themeMode == ThemeMode.system) themeName = 'System';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SettingsHeader(title: 'PREFERENCES'),
              const SizedBox(height: AppSpacing.xs),
              _SettingsTile(
                title: 'Theme Mode',
                subtitle: '$themeName Theme Active',
                icon: Icons.dark_mode_outlined,
                trailing: Text(themeName, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w700)),
                onTap: _showThemeModeDialog,
              ),
              _SettingsTile(
                title: 'App Language',
                subtitle: 'English (US)',
                icon: Icons.language,
                trailing: Text('EN', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: AppSpacing.lg),

              const _SettingsHeader(title: 'NOTIFICATIONS'),
              const SizedBox(height: AppSpacing.xs),
              SwitchListTile(
                dense: true,
                title: Text('Push Notifications', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
                subtitle: Text('Receive lab updates & streak reminders', style: TextStyle(color: foren.textDisabled, fontSize: 11)),
                value: settings.pushNotifications,
                activeTrackColor: primaryColor,
                onChanged: (v) {
                  notifier.togglePushNotifications(v);
                  _notifySaved('Settings Saved');
                },
              ),
              SwitchListTile(
                dense: true,
                title: Text('Security Threat Alerts', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
                subtitle: Text('Immediate alert for high-severity IOC threats', style: TextStyle(color: foren.textDisabled, fontSize: 11)),
                value: settings.threatAlerts,
                activeTrackColor: criticalColor,
                onChanged: (v) {
                  notifier.toggleThreatAlerts(v);
                  _notifySaved('Settings Saved');
                },
              ),
              SwitchListTile(
                dense: true,
                title: Text('Email Digest', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
                value: settings.emailAlerts,
                activeTrackColor: primaryColor,
                onChanged: (v) {
                  notifier.toggleEmailAlerts(v);
                  _notifySaved('Settings Saved');
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              const _SettingsHeader(title: 'PRIVACY & SECURITY'),
              const SizedBox(height: AppSpacing.xs),
              SwitchListTile(
                dense: true,
                title: Text('Biometric Authentication', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
                subtitle: Text('Require Fingerprint / Face ID on launch', style: TextStyle(color: foren.textDisabled, fontSize: 11)),
                value: settings.biometricLogin,
                activeTrackColor: primaryColor,
                onChanged: (v) {
                  notifier.toggleBiometricLogin(v);
                  _notifySaved('Settings Saved');
                },
              ),
              SwitchListTile(
                dense: true,
                title: Text('Telemetry & Analytics', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
                subtitle: Text('Anonymous telemetry to improve lab performance', style: TextStyle(color: foren.textDisabled, fontSize: 11)),
                value: settings.analyticsEnabled,
                activeTrackColor: primaryColor,
                onChanged: (v) {
                  notifier.toggleAnalytics(v);
                  _notifySaved('Settings Saved');
                },
              ),
              SwitchListTile(
                dense: true,
                title: Text('Auto Updates', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
                subtitle: Text('Automatically download latest threat intelligence', style: TextStyle(color: foren.textDisabled, fontSize: 11)),
                value: settings.autoUpdates,
                activeTrackColor: primaryColor,
                onChanged: (v) {
                  notifier.toggleAutoUpdates(v);
                  _notifySaved('Settings Saved');
                },
              ),
              SwitchListTile(
                dense: true,
                title: Text('Developer Mode', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13)),
                subtitle: Text('Enable extended debug console & raw logs', style: TextStyle(color: foren.textDisabled, fontSize: 11)),
                value: settings.developerMode,
                activeTrackColor: primaryColor,
                onChanged: (v) {
                  notifier.toggleDeveloperMode(v);
                  _notifySaved('Settings Saved');
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              const _SettingsHeader(title: 'RESET & RESTORE'),
              const SizedBox(height: AppSpacing.xs),
              _SettingsTile(
                title: 'Reset All Settings',
                subtitle: 'Restore all preferences and flags to default',
                icon: Icons.restart_alt,
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: criticalColor),
                onTap: _showResetConfirmationDialog,
              ),
              const SizedBox(height: AppSpacing.lg),

              const _SettingsHeader(title: 'HELP & ABOUT'),
              const SizedBox(height: AppSpacing.xs),
              _SettingsTile(
                title: 'Send Feedback & Bug Report',
                subtitle: 'Help us improve ForenShield',
                icon: Icons.feedback_outlined,
                onTap: _showFeedbackDialog,
              ),
              const _SettingsTile(
                title: 'About ForenShield',
                subtitle: 'v1.0.0 (Build 1) · Enterprise Edition',
                icon: Icons.info_outline,
              ),
              const _SettingsTile(
                title: 'Developer & Team',
                subtitle: 'ForenShield Security Research Team',
                icon: Icons.code_outlined,
              ),
              const _SettingsTile(
                title: 'GitHub Repository',
                subtitle: 'github.com/moksh104/ForenShield',
                icon: Icons.open_in_new_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final foren = Theme.of(context).extension<ForenColors>()!;

    return Text(
      title,
      style: TextStyle(
        color: foren.textDisabled,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
          side: BorderSide(color: foren.borderSubtle.withValues(alpha: 0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: Icon(icon, color: foren.textSecondary, size: 18),
          title: Text(title, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: TextStyle(color: foren.textDisabled, fontSize: 11)),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
