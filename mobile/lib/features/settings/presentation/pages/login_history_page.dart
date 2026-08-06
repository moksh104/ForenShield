import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/settings_model.dart';
import '../widgets/settings_card.dart';

/// Login History Page displaying security audit log (UI Mock Data).
class LoginHistoryPage extends StatelessWidget {
  const LoginHistoryPage({super.key});

  List<LoginHistoryModel> get _mockHistory => [
        LoginHistoryModel(
          id: 'log_1',
          ipAddress: '127.0.0.1',
          location: 'Bangalore, India',
          device: 'Chrome / Windows',
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
          isSuccessful: true,
        ),
        LoginHistoryModel(
          id: 'log_2',
          ipAddress: '49.207.192.12',
          location: 'Mumbai, India',
          device: 'ForenShield Mobile (Android)',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isSuccessful: true,
        ),
        LoginHistoryModel(
          id: 'log_3',
          ipAddress: '185.220.101.4',
          location: 'Frankfurt, Germany (Tor Proxy)',
          device: 'Unknown Client',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isSuccessful: false,
        ),
        LoginHistoryModel(
          id: 'log_4',
          ipAddress: '103.22.140.5',
          location: 'Singapore',
          device: 'MacBook Pro Client',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isSuccessful: true,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Login Audit History'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'Security audit log of recent authentication events associated with your account credentials.',
              style: TextStyle(color: foren.textSecondary, fontSize: 13),
            ),
          ),
          SettingsCard(
            children: _mockHistory.map<Widget>((LoginHistoryModel item) {
              final isLast = item == _mockHistory.last;

              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: item.isSuccessful
                            ? foren.success.t500.withValues(alpha: 0.15)
                            : foren.critical.t500.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.isSuccessful
                            ? Icons.check_circle_outline_rounded
                            : Icons.gpp_bad_rounded,
                        color: item.isSuccessful
                            ? foren.success.t300
                            : foren.critical.t300,
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.device,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          item.isSuccessful ? 'SUCCESS' : 'FAILED',
                          style: TextStyle(
                            color: item.isSuccessful
                                ? foren.success.t300
                                : foren.critical.t300,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '${item.ipAddress} · ${item.location}\n${item.timestamp.toLocal().toString().split('.')[0]}',
                      style: TextStyle(color: foren.textSecondary, fontSize: 11),
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
