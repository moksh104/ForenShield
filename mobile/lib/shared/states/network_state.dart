import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Reusable generic NetworkState widget.
/// Used for offline internet connection warnings or server unreachable states.
class NetworkState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String reconnectLabel;
  final VoidCallback? onReconnect;

  const NetworkState({
    super.key,
    this.title = 'No Internet Connection',
    this.message =
        'Please check your Wi-Fi or cellular network settings and try again.',
    this.icon = Icons.wifi_off_rounded,
    this.reconnectLabel = 'Reconnect',
    this.onReconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: AppColors.warning),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (onReconnect != null) ...[
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: onReconnect,
                  icon: const Icon(Icons.wifi_find_rounded, size: 18),
                  label: Text(reconnectLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.black,
                    padding: AppSpacing.buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.buttonRadius,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
