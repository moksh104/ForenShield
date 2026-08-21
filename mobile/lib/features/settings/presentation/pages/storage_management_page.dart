import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/settings_tile.dart';

/// Storage Management Page for inspecting app cache, evidence files, and clearing cache.
class StorageManagementPage extends ConsumerStatefulWidget {
  const StorageManagementPage({super.key});

  @override
  ConsumerState<StorageManagementPage> createState() =>
      _StorageManagementPageState();
}

class _StorageManagementPageState extends ConsumerState<StorageManagementPage> {
  bool _isClearingCache = false;
  double _cacheSizeMB = 0.0;
  final double _evidenceFilesMB = 12.8; // Mock data since not implemented
  final double _offlineCoursesMB = 8.5; // Mock data since not implemented

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    final size = await ref.read(settingsProvider.notifier).getCacheSize();
    if (mounted) {
      setState(() {
        _cacheSizeMB = size;
      });
    }
  }

  Future<void> _clearCache() async {
    final confirmed = await SettingsDialog.showConfirmation(
      context: context,
      title: 'Clear Application Cache?',
      message:
          'This will remove temporary log files, cached evidence thumbnails, and HTTP response caches. Offline courses will not be deleted.',
      confirmText: 'Clear Cache',
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isClearingCache = true);
    final cleared = await ref.read(settingsProvider.notifier).clearCache();
    if (!mounted) return;

    setState(() {
      _cacheSizeMB = 0.0;
      _isClearingCache = false;
    });

    final foren =
        Theme.of(context).extension<ForenColors>() ?? ForenColors.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cleared $cleared MB of cached temporary files.'),
        backgroundColor: foren.success.t500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final totalUsedMB = _cacheSizeMB + _evidenceFilesMB + _offlineCoursesMB;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Storage Management'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Total Usage Summary Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: foren.borderDefault),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sd_storage_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Total App Storage',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${totalUsedMB.toStringAsFixed(1)} MB',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Linear Progress Bar breakdown
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: totalUsedMB / 500.0,
                    minHeight: 10,
                    backgroundColor: foren.surfaceRaised1,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cache: ${_cacheSizeMB.toStringAsFixed(1)} MB',
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'Evidence: ${_evidenceFilesMB.toStringAsFixed(1)} MB',
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'Academy: ${_offlineCoursesMB.toStringAsFixed(1)} MB',
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Detailed Breakdown Card
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.cached_rounded,
                title: 'Temporary HTTP & Image Cache',
                subtitle: _cacheSizeMB == 0
                    ? 'Cache is empty (0.0 MB)'
                    : '${_cacheSizeMB.toStringAsFixed(1)} MB temporary storage',
                trailing: _isClearingCache
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : OutlinedButton(
                        onPressed: _cacheSizeMB == 0 ? null : _clearCache,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: foren.critical.t300,
                          side: BorderSide(
                            color: _cacheSizeMB == 0
                                ? foren.borderDefault
                                : foren.critical.t300,
                          ),
                        ),
                        child: const Text('Clear'),
                      ),
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.folder_zip_rounded,
                title: 'Investigation Evidence Files',
                subtitle:
                    '${_evidenceFilesMB.toStringAsFixed(1)} MB local RAM dumps & artifacts',
                trailing: Text(
                  '12 Files',
                  style: TextStyle(color: foren.textSecondary, fontSize: 12),
                ),
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.school_rounded,
                title: 'Downloaded Academy Modules',
                subtitle:
                    '${_offlineCoursesMB.toStringAsFixed(1)} MB offline course content',
                trailing: Text(
                  '3 Courses',
                  style: TextStyle(color: foren.textSecondary, fontSize: 12),
                ),
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
