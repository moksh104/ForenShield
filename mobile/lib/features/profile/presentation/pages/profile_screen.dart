import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../providers/profile_provider.dart';

/// User Profile Screen displaying identity avatar, rank, member status, and navigation grid.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Agent Profile',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.push(RouteConstants.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(context, ref, state, notifier),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ProfileState state,
    ProfileNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    switch (state.status) {
      case ProfileStatus.initial:
      case ProfileStatus.loading:
        return Center(
          child: CircularProgressIndicator(color: primaryColor),
        );

      case ProfileStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: foren.critical.t500, size: 48),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.errorMessage ?? 'Failed to load profile.',
                style: TextStyle(color: foren.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => notifier.loadProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case ProfileStatus.empty:
      case ProfileStatus.refreshing:
      case ProfileStatus.success:
        final profile = state.profile;
        if (profile == null) return const SizedBox.shrink();

        final initials = profile.fullName.isNotEmpty
            ? profile.fullName
                .trim()
                .split(' ')
                .map((e) => e[0])
                .take(2)
                .join()
                .toUpperCase()
            : 'A';

        return RefreshIndicator(
          onRefresh: () => notifier.refreshProfile(),
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Header Avatar & Identity
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showAvatarOptionsBottomSheet(context, ref, profile.avatarUrl),
                        child: Stack(
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor, width: 2),
                              ),
                              child: ClipOval(
                                child: _buildAvatarWidget(
                                  profile.avatarUrl,
                                  initials,
                                  primaryColor,
                                  theme,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 16,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        profile.fullName,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.email,
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          borderRadius: AppRadius.borderRadiusSm,
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '${profile.rankTitle} · Level ${profile.level}',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Info Cards Grid
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: AppRadius.borderRadiusLg,
                    border: Border.all(
                      color: foren.borderSubtle.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileStatItem(label: 'Total XP', value: '${profile.xpPoints} XP'),
                      _ProfileStatItem(label: 'Member Since', value: profile.memberSince),
                      const _ProfileStatItem(label: 'Account Status', value: 'Verified'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Nav Links List
                _NavListTile(
                  icon: Icons.emoji_events_outlined,
                  color: foren.warning.t500,
                  title: 'Achievements & Badges',
                  subtitle: 'Earned rewards, certificates, and XP log',
                  onTap: () => context.push(RouteConstants.achievementsWall),
                ),
                const SizedBox(height: AppSpacing.xs),
                _NavListTile(
                  icon: Icons.insights_outlined,
                  color: foren.success.t500,
                  title: 'Learning & Forensic Statistics',
                  subtitle: 'Streak, solved cases, and total hours',
                  onTap: () => context.push(RouteConstants.profileStats),
                ),
                const SizedBox(height: AppSpacing.xs),
                _NavListTile(
                  icon: Icons.manage_accounts_outlined,
                  color: foren.info.t500,
                  title: 'Account Settings & Security',
                  subtitle: 'Edit profile, change password, and sessions',
                  onTap: () => context.push(RouteConstants.profileAccount),
                ),
                const SizedBox(height: AppSpacing.xs),
                _NavListTile(
                  icon: Icons.settings_outlined,
                  color: foren.textSecondary,
                  title: 'App Settings & Support',
                  subtitle: 'Notifications, theme, and feedback',
                  onTap: () => context.push(RouteConstants.settings),
                ),
              ],
            ),
          ),
        );
    }
  }
}

class _ProfileStatItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: foren.textDisabled,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _NavListTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavListTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
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
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: foren.textDisabled,
            fontSize: 11,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: foren.textDisabled, size: 18),
        onTap: onTap,
      ),
      ),
    );
  }
}

void _showAvatarOptionsBottomSheet(BuildContext context, WidgetRef ref, String currentAvatarUrl) {
  final theme = Theme.of(context);
  final foren = theme.extension<ForenColors>()!;
  final primaryColor = theme.colorScheme.primary;
  final criticalColor = foren.critical.t500;
  final hasAvatar = currentAvatarUrl.isNotEmpty;

  showModalBottomSheet(
    context: context,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: foren.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Picture Options',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: primaryColor),
              title: Text('Camera', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14)),
              onTap: () async {
                Navigator.pop(ctx);
                await _pickImageSource(context, ref, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: primaryColor),
              title: Text('Gallery', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14)),
              onTap: () async {
                Navigator.pop(ctx);
                await _pickImageSource(context, ref, ImageSource.gallery);
              },
            ),
            if (hasAvatar)
              ListTile(
                leading: Icon(Icons.delete_outline, color: criticalColor),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(color: criticalColor, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref.read(profileProvider.notifier).removeAvatar();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile picture removed'),
                      backgroundColor: foren.info.t500,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _pickImageSource(BuildContext context, WidgetRef ref, ImageSource source) async {
  try {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image == null) return;

    await ref.read(profileProvider.notifier).updateAvatar(image.path);
    if (!context.mounted) return;

    final foren = Theme.of(context).extension<ForenColors>()!;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile picture updated'),
        backgroundColor: foren.success.t500,
      ),
    );
  } catch (_) {}
}

Widget _buildAvatarWidget(String avatarUrl, String initials, Color primaryColor, ThemeData theme) {
  if (avatarUrl.isNotEmpty) {
    if (kIsWeb || avatarUrl.startsWith('http')) {
      return Image.network(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => _buildInitials(initials, primaryColor, theme),
      );
    } else {
      final file = File(avatarUrl);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => _buildInitials(initials, primaryColor, theme),
        );
      }
    }
  }
  return _buildInitials(initials, primaryColor, theme);
}

Widget _buildInitials(String initials, Color primaryColor, ThemeData theme) {
  return Container(
    color: primaryColor,
    child: Center(
      child: Text(
        initials,
        style: TextStyle(
          color: theme.scaffoldBackgroundColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
