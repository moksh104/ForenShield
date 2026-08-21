import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/settings_model.dart';
import '../providers/device_management_provider.dart';
import '../widgets/settings_dialog.dart';

/// Device Management Page
class DeviceManagementPage extends ConsumerStatefulWidget {
  const DeviceManagementPage({super.key});

  @override
  ConsumerState<DeviceManagementPage> createState() =>
      _DeviceManagementPageState();
}

class _DeviceManagementPageState extends ConsumerState<DeviceManagementPage> {
  Future<void> _revokeSession(DeviceSessionModel session) async {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    final confirmed = await SettingsDialog.showConfirmation(
      context: context,
      title: 'Revoke Session?',
      message:
          'This will log out the user session on ${session.deviceName} immediately.',
      confirmText: 'Revoke',
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(revokeDeviceProvider(session.id).future);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Revoked session for ${session.deviceName}'),
          backgroundColor: foren.success.t500,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to revoke session. Please try again.'),
          backgroundColor: foren.critical.t500,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final sessionsAsync = ref.watch(deviceSessionsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Device Management'),
        centerTitle: false,
      ),
      body: sessionsAsync.when(
        data: (sessions) => ListView(
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
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'You are currently signed in on ${sessions.length} device${sessions.length == 1 ? '' : 's'}. Revoke any sessions you do not recognize.',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sessions List
            ...sessions.map(
              (session) => _buildSessionCard(session, theme, foren),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: foren.critical.t500),
              const SizedBox(height: 16),
              const Text('Failed to load device sessions.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(deviceSessionsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    DeviceSessionModel session,
    ThemeData theme,
    ForenColors foren,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: foren.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: session.isCurrentDevice
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : foren.surfaceRaised1,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(session.deviceType),
                  color: session.isCurrentDevice
                      ? theme.colorScheme.primary
                      : foren.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.deviceName,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.deviceType,
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (session.isCurrentDevice)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Current',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: () => _revokeSession(session),
                  icon: Icon(
                    Icons.remove_circle_outline_rounded,
                    color: foren.critical.t500,
                    size: 20,
                  ),
                  tooltip: 'Revoke Session',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetaItem(Icons.public, session.ipAddress, theme, foren),
              _buildMetaItem(
                Icons.schedule,
                'Last active: ${DateFormat('MMM d, h:mm a').format(session.lastActive.toLocal())}',
                theme,
                foren,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(
    IconData icon,
    String label,
    ThemeData theme,
    ForenColors foren,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14, color: foren.textDisabled),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: foren.textDisabled, fontSize: 12)),
      ],
    );
  }

  IconData _getIconForType(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('web')) return Icons.language_rounded;
    if (lower.contains('mac')) return Icons.desktop_mac_rounded;
    if (lower.contains('windows')) return Icons.desktop_windows_rounded;
    if (lower.contains('android') || lower.contains('ios')) {
      return Icons.smartphone_rounded;
    }
    return Icons.devices_other_rounded;
  }
}
