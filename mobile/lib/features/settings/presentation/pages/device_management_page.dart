import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/settings_model.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_dialog.dart';

/// Device Management Page (UI Placeholder as per user specification).
class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({super.key});

  @override
  State<DeviceManagementPage> createState() => _DeviceManagementPageState();
}

class _DeviceManagementPageState extends State<DeviceManagementPage> {
  final List<DeviceSessionModel> _sessions = [
    DeviceSessionModel(
      id: 'session_1',
      deviceName: 'Chrome Web (Windows 11)',
      deviceType: 'Web Browser',
      ipAddress: '127.0.0.1 (Localhost)',
      location: 'Bangalore, IN',
      lastActive: DateTime.now(),
      isCurrentDevice: true,
    ),
    DeviceSessionModel(
      id: 'session_2',
      deviceName: 'Pixel 8 Pro (Android 14)',
      deviceType: 'Mobile App',
      ipAddress: '49.207.192.12',
      location: 'Mumbai, IN',
      lastActive: DateTime.now().subtract(const Duration(hours: 4)),
      isCurrentDevice: false,
    ),
    DeviceSessionModel(
      id: 'session_3',
      deviceName: 'MacBook Pro M3 (macOS Sonoma)',
      deviceType: 'Desktop Client',
      ipAddress: '103.22.140.5',
      location: 'Singapore, SG',
      lastActive: DateTime.now().subtract(const Duration(days: 2)),
      isCurrentDevice: false,
    ),
  ];

  Future<void> _revokeSession(DeviceSessionModel session) async {
    final confirmed = await SettingsDialog.showConfirmation(
      context: context,
      title: 'Revoke Session?',
      message:
          'This will log out the user session on ${session.deviceName} immediately.',
      confirmText: 'Revoke',
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _sessions.removeWhere((s) => s.id == session.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Revoked session for ${session.deviceName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Device Management'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Banner Notice
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.devices_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Active Authorized Sessions across devices connected to your ForenShield identity.',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sessions List Card
          SettingsCard(
            children: _sessions.map<Widget>((DeviceSessionModel session) {
              final isLast = session == _sessions.last;

              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: session.isCurrentDevice
                            ? theme.colorScheme.primary.withValues(alpha: 0.15)
                            : foren.surfaceRaised1,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        session.deviceType.contains('Mobile')
                            ? Icons.smartphone_rounded
                            : Icons.laptop_rounded,
                        color: session.isCurrentDevice
                            ? theme.colorScheme.primary
                            : foren.textSecondary,
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            session.deviceName,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (session.isCurrentDevice)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: foren.success.t500.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'This Device',
                              style: TextStyle(
                                color: foren.success.t300,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      '${session.ipAddress} · ${session.location}',
                      style: TextStyle(color: foren.textSecondary, fontSize: 12),
                    ),
                    trailing: session.isCurrentDevice
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.logout_rounded,
                              color: foren.critical.t300,
                              size: 20,
                            ),
                            onPressed: () => _revokeSession(session),
                          ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: foren.borderSubtle,
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
