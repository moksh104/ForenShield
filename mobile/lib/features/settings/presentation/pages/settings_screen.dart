import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../authentication/providers/auth_state_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch.dart';
import '../widgets/settings_tile.dart';
import 'about_page.dart';
import 'device_management_page.dart';
import 'login_history_page.dart';
import 'storage_management_page.dart';

/// Complete Settings Module Screen for ForenShield.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoggingOut = false;

  void _notify(String message) {
    if (!mounted) return;
    final foren = Theme.of(context).extension<ForenColors>() ?? ForenColors.dark;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: foren.success.t500,
      ),
    );
  }

  // ── Account Dialogs ────────────────────────────────────────────────────────

  void _showChangePasswordDialog() {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Change Password',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.check_circle_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: foren.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (newCtrl.text.isNotEmpty && newCtrl.text == confirmCtrl.text) {
                Navigator.pop(ctx);
                _notify('Password updated successfully');
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: const Text('Passwords do not match'),
                    backgroundColor: foren.critical.t500,
                  ),
                );
              }
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await SettingsDialog.showConfirmation(
      context: context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to end your current session?',
      confirmText: 'Logout',
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);
    await ref.read(authStateProvider.notifier).logout();
    if (!mounted) return;

    context.goNamed(RouteConstants.login);
  }

  // ── Appearance Pickers ─────────────────────────────────────────────────────

  void _showThemeDialog() async {
    final settings = ref.read(settingsProvider);
    final selected = await SettingsDialog.showOptionPicker<ThemeMode>(
      context: context,
      title: 'Select Theme Mode',
      currentValue: settings.themeMode,
      options: [
        {'label': 'Dark Cyber Theme (Default)', 'value': ThemeMode.dark},
        {'label': 'Light Mode', 'value': ThemeMode.light},
        {'label': 'System Default', 'value': ThemeMode.system},
      ],
    );

    if (selected != null) {
      ref.read(settingsProvider.notifier).setThemeMode(selected);
      _notify('Theme mode updated');
    }
  }

  void _showFontScaleDialog() async {
    final settings = ref.read(settingsProvider);
    final selected = await SettingsDialog.showFontScalePicker(
      context: context,
      currentScale: settings.fontScale,
    );

    if (selected != null) {
      ref.read(settingsProvider.notifier).setFontScale(selected);
      _notify('Font scale set to ${(selected * 100).toInt()}%');
    }
  }

  // ── Security Pickers ───────────────────────────────────────────────────────

  void _showSessionTimeoutDialog() async {
    final settings = ref.read(settingsProvider);
    final selected = await SettingsDialog.showOptionPicker<int>(
      context: context,
      title: 'Automatic Session Timeout',
      currentValue: settings.autoLogoutMinutes,
      options: [
        {'label': '5 Minutes', 'value': 5},
        {'label': '15 Minutes (Default)', 'value': 15},
        {'label': '30 Minutes', 'value': 30},
        {'label': 'Never', 'value': 0},
      ],
    );

    if (selected != null) {
      ref.read(settingsProvider.notifier).setAutoLogoutMinutes(selected);
      _notify('Session timeout set');
    }
  }

  // ── Application Pickers ────────────────────────────────────────────────────

  void _showLanguageDialog() async {
    final settings = ref.read(settingsProvider);
    final selected = await SettingsDialog.showOptionPicker<String>(
      context: context,
      title: 'Select Application Language',
      currentValue: settings.selectedLanguage,
      options: [
        {'label': 'English (US)', 'value': 'English (US)'},
        {'label': 'Spanish (Español)', 'value': 'Spanish (Español)'},
        {'label': 'French (Français)', 'value': 'French (Français)'},
        {'label': 'German (Deutsch)', 'value': 'German (Deutsch)'},
        {'label': 'Japanese (日本語)', 'value': 'Japanese (日本語)'},
      ],
    );

    if (selected != null) {
      ref.read(settingsProvider.notifier).setLanguage(selected);
      _notify('Language set to $selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // ── SECTION 1: ACCOUNT SETTINGS ─────────────────────────────────
          SettingsSection(
            title: 'Account Settings',
            headerIcon: Icons.person_rounded,
            children: [
              SettingsTile(
                icon: Icons.account_circle_outlined,
                title: 'Profile Information',
                subtitle: 'View and update your agent credentials',
                onTap: () => context.pushNamed(RouteConstants.profile),
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.lock_reset_rounded,
                title: 'Change Password',
                subtitle: 'Update your login password',
                onTap: _showChangePasswordDialog,
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.logout_rounded,
                iconColor: foren.critical.t300,
                title: 'Logout',
                subtitle: 'Terminate current active session',
                isDestructive: true,
                trailing: _isLoggingOut
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                onTap: _handleLogout,
                showDivider: false,
              ),
            ],
          ),

          // ── SECTION 2: NOTIFICATION SETTINGS ─────────────────────────────
          SettingsSection(
            title: 'Notification Preferences',
            headerIcon: Icons.notifications_active_rounded,
            children: [
              SettingsSwitch(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive real-time push alerts',
                value: settings.pushNotifications,
                onChanged: notifier.togglePushNotifications,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.volume_up_outlined,
                title: 'Notification Sound',
                subtitle: 'Play audio alert on new notification',
                value: settings.soundEnabled,
                onChanged: notifier.toggleSoundEnabled,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.vibration_rounded,
                title: 'Vibration Alerts',
                subtitle: 'Haptic feedback on threat alerts',
                value: settings.vibrationEnabled,
                onChanged: notifier.toggleVibrationEnabled,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Weekly summary and critical alerts',
                value: settings.emailAlerts,
                onChanged: notifier.toggleEmailAlerts,
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.category_outlined,
                title: 'Topic Subscriptions',
                subtitle:
                    '${settings.topicSubscriptions.length} active topics',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => Consumer(
                      builder: (context, ref, _) {
                        final s = ref.watch(settingsProvider);
                        final n = ref.read(settingsProvider.notifier);

                        return AlertDialog(
                          backgroundColor: theme.colorScheme.surface,
                          title: const Text('Topic Subscriptions'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              'Threat Intelligence',
                              'Academy Updates',
                              'Security Bulletins',
                              'System Maintenance'
                            ].map((topic) {
                              final isSubbed =
                                  s.topicSubscriptions.contains(topic);
                              return CheckboxListTile(
                                title: Text(topic),
                                value: isSubbed,
                                onChanged: (_) =>
                                    n.toggleTopicSubscription(topic),
                              );
                            }).toList(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Done'),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
                showDivider: false,
              ),
            ],
          ),

          // ── SECTION 3: APPEARANCE SETTINGS ──────────────────────────────
          SettingsSection(
            title: 'Appearance',
            headerIcon: Icons.palette_outlined,
            children: [
              SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Theme Mode',
                subtitle: settings.themeMode == ThemeMode.dark
                    ? 'Dark Cyber Theme'
                    : (settings.themeMode == ThemeMode.light
                        ? 'Light Mode'
                        : 'System Default'),
                onTap: _showThemeDialog,
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.format_size_rounded,
                title: 'Font Scaling',
                subtitle: '${(settings.fontScale * 100).toInt()}% font scale',
                onTap: _showFontScaleDialog,
                showDivider: false,
              ),
            ],
          ),

          // ── SECTION 4: SECURITY SETTINGS ────────────────────────────────
          SettingsSection(
            title: 'Security',
            headerIcon: Icons.security_rounded,
            children: [
              SettingsSwitch(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric Authentication',
                subtitle: 'Unlock with Fingerprint / Face ID',
                value: settings.biometricLogin,
                onChanged: notifier.toggleBiometricLogin,
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.timer_outlined,
                title: 'Session Timeout',
                subtitle: settings.autoLogoutMinutes == 0
                    ? 'Never'
                    : '${settings.autoLogoutMinutes} Minutes',
                onTap: _showSessionTimeoutDialog,
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.devices_other_rounded,
                title: 'Device Management',
                subtitle: 'Manage active sessions across devices',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const DeviceManagementPage(),
                  ),
                ),
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.history_rounded,
                title: 'Login Audit History',
                subtitle: 'View security login attempt logs',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const LoginHistoryPage(),
                  ),
                ),
                showDivider: false,
              ),
            ],
          ),

          // ── SECTION 5: PRIVACY SETTINGS ─────────────────────────────────
          SettingsSection(
            title: 'Privacy & Data',
            headerIcon: Icons.privacy_tip_outlined,
            children: [
              SettingsSwitch(
                icon: Icons.share_outlined,
                title: 'Data Sharing',
                subtitle: 'Allow threat intelligence sharing',
                value: settings.dataCollectionEnabled,
                onChanged: notifier.toggleDataCollection,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.analytics_outlined,
                title: 'Usage Analytics',
                subtitle: 'Help improve app performance',
                value: settings.analyticsEnabled,
                onChanged: notifier.toggleAnalytics,
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.cleaning_services_rounded,
                title: 'Clear Cache',
                subtitle: 'Remove temporary files & images',
                onTap: () async {
                  final cleared = await notifier.clearCache();
                  _notify('Cleared $cleared MB of cached temporary files.');
                },
                showDivider: false,
              ),
            ],
          ),

          // ── SECTION 6: APPLICATION SETTINGS ─────────────────────────────
          SettingsSection(
            title: 'Application',
            headerIcon: Icons.app_settings_alt_rounded,
            children: [
              SettingsTile(
                icon: Icons.language_rounded,
                title: 'Language Selection',
                subtitle: settings.selectedLanguage,
                onTap: _showLanguageDialog,
                showDivider: true,
              ),
              SettingsSwitch(
                icon: Icons.system_update_rounded,
                title: 'Auto-Update Preferences',
                subtitle: 'Automatically download patch updates',
                value: settings.autoUpdates,
                onChanged: notifier.toggleAutoUpdates,
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.storage_rounded,
                title: 'Storage Management',
                subtitle: 'Inspect app storage & downloaded courses',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const StorageManagementPage(),
                  ),
                ),
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About ForenShield',
                subtitle: 'Version 2.4.0 (Build 2026.08)',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const AboutPage(),
                  ),
                ),
                showDivider: false,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
