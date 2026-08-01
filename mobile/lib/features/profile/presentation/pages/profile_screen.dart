import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/effects/scanner_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
import '../providers/profile_provider.dart';
import '../widgets/activity_timeline.dart';
import '../widgets/analyst_banner.dart';
import '../widgets/analyst_stats_grid.dart';
import '../widgets/skill_badges_section.dart';

/// Premium Cybersecurity Analyst Operations Dashboard Profile Screen.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Performance & Emergency Switch Compliance
  static const bool enableAdvancedEffects = true;
  static const int particleCount = 40;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    final Widget contentBody = Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderRadiusSm,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'Analyst Dashboard',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 0.5,
                fontFamily: 'Geist',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.push(RouteConstants.settings),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundGrid()),
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _buildStateBody(context, ref, state, notifier),
            ),
          ),
        ],
      ),
    );

    if (enableAdvancedEffects) {
      return ParticleBackground(
        numberOfParticles: particleCount,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: contentBody,
      );
    }

    return contentBody;
  }

  Widget _buildStateBody(
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
          key: const ValueKey('loading'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: ScannerEffect(
                  color: primaryColor,
                  child: const Center(
                    child: Icon(Icons.shield_outlined, size: 54, color: AppColors.logoGold),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'AUTHENTICATING ANALYST CREDENTIALS...',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        );

      case ProfileStatus.error:
        return Center(
          key: const ValueKey('error'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GlassEffect(
              blurX: 16.0,
              blurY: 16.0,
              opacity: 0.12,
              border: Border.all(color: foren.critical.t500, width: 1.0),
              borderRadius: AppRadius.borderRadiusXl,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlowEffect(
                      glowColor: foren.critical.t500,
                      blurRadius: 24,
                      animate: true,
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: foren.critical.t500.withValues(alpha: 0.15),
                        ),
                        child: Icon(Icons.error_outline, color: foren.critical.t500, size: 48),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'UPLINK CONNECTION ERROR',
                      style: TextStyle(
                        color: foren.critical.t500,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      state.errorMessage ?? 'Failed to synchronize analyst profile with control center.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: foren.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                      ),
                      onPressed: () => notifier.loadProfile(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('REESTABLISH LINK', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case ProfileStatus.empty:
        return Center(
          key: const ValueKey('empty'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GlassEffect(
              blurX: 16.0,
              blurY: 16.0,
              opacity: 0.12,
              border: Border.all(color: AppColors.logoGold, width: 1.0),
              borderRadius: AppRadius.borderRadiusXl,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_off_outlined, color: AppColors.logoGold, size: 48),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'NO ANALYST PROFILE DATA',
                      style: TextStyle(
                        color: AppColors.logoGold,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton(
                      onPressed: () => notifier.refreshProfile(),
                      child: const Text('FETCH PROFILE'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case ProfileStatus.refreshing:
      case ProfileStatus.success:
        final profile = state.profile;
        if (profile == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: () => notifier.refreshProfile(),
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Animated Profile Banner & Identity Header
                AnalystBanner(
                  profile: profile,
                  onAvatarTap: () => _showAvatarOptionsBottomSheet(context, ref, profile.avatarUrl),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: -0.1, end: 0, curve: Curves.easeOut),

                const SizedBox(height: AppSpacing.xl),

                // 2. Statistics Dashboard Grid (Count-up cards)
                Text(
                  'ANALYST TELEMETRY & METRICS',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 1.0,
                  ),
                )
                    .animate(delay: 150.ms)
                    .fadeIn(duration: 400.ms),
                const SizedBox(height: AppSpacing.xs),

                AnalystStatsGrid(profile: profile)
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppSpacing.xl),

                // 3. Cybersecurity Skill Badges & Domain Matrix
                const SkillBadgesSection()
                    .animate(delay: 350.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppSpacing.xl),

                // 4. Activity Timeline Log
                ActivityTimeline(xpHistory: profile.xpHistory)
                    .animate(delay: 450.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppSpacing.xl),

                // 5. Navigation Control Tiles
                Text(
                  'CONTROL CENTER NAVIGATION',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 1.0,
                  ),
                )
                    .animate(delay: 550.ms)
                    .fadeIn(duration: 400.ms),
                const SizedBox(height: AppSpacing.xs),

                _ProfileNavTile(
                  icon: Icons.emoji_events_outlined,
                  color: foren.warning.t500,
                  title: 'Achievements & Badge Vault',
                  subtitle: '${profile.badges.where((b) => b.isUnlocked).length} Badges Earned · View Certificate Wall',
                  onTap: () => context.push(RouteConstants.achievementsWall),
                )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),

                _ProfileNavTile(
                  icon: Icons.insights_outlined,
                  color: foren.success.t500,
                  title: 'Forensic Statistics Overview',
                  subtitle: 'Detailed breakdown of cases, streaks & learning hours',
                  onTap: () => context.push(RouteConstants.profileStats),
                )
                    .animate(delay: 650.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),

                _ProfileNavTile(
                  icon: Icons.manage_accounts_outlined,
                  color: primaryColor,
                  title: 'Analyst Account & Security',
                  subtitle: 'Edit credentials, bio, and multi-factor auth',
                  onTap: () => context.push(RouteConstants.profileAccount),
                )
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),

                _ProfileNavTile(
                  icon: Icons.settings_outlined,
                  color: foren.textSecondary,
                  title: 'Control Center Settings & Support',
                  subtitle: 'App preferences, notifications & threat support',
                  onTap: () => context.push(RouteConstants.settings),
                )
                    .animate(delay: 750.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
              ],
            ),
          ),
        );
    }
  }
}

class _ProfileNavTile extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileNavTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ProfileNavTile> createState() => _ProfileNavTileState();
}

class _ProfileNavTileState extends State<_ProfileNavTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(_isHovered ? 4 : 0, 0, 0),
          child: GlassEffect(
            blurX: 10.0,
            blurY: 10.0,
            opacity: 0.10,
            border: Border.all(
              color: _isHovered ? widget.color : foren.borderSubtle,
              width: 1.0,
            ),
            borderRadius: AppRadius.borderRadiusMd,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              title: Text(
                widget.title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                widget.subtitle,
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 11,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: widget.color, size: 18),
              onTap: widget.onTap,
            ),
          ),
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
    backgroundColor: AppColors.surface,
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
