import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/profile_entity.dart';

/// Profile banner displaying cover, avatar, rank, and XP progression.
class AnalystBanner extends StatefulWidget {
  final ProfileEntity profile;
  final VoidCallback onAvatarTap;

  const AnalystBanner({
    super.key,
    required this.profile,
    required this.onAvatarTap,
  });

  @override
  State<AnalystBanner> createState() => _AnalystBannerState();
}

class _AnalystBannerState extends State<AnalystBanner> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final profile = widget.profile;
    final initials = profile.fullName.isNotEmpty
        ? profile.fullName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'A';

    final xpProgress = (profile.xpPoints / profile.nextLevelXp).clamp(0.0, 1.0);
    final xpPercent = (xpProgress * 100).toInt();

    final Widget avatarContainer = Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primaryColor, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: _buildAvatarContent(
              profile.avatarUrl,
              initials,
              primaryColor,
              theme,
            ),
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        child: GlassEffect(
          border: Border.all(
            color: _isHovered
                ? primaryColor.withValues(alpha: 0.6)
                : foren.borderSubtle,
            width: 1.0,
          ),
          borderRadius: AppRadius.borderRadiusXl,
          child: Column(
            children: [
              // Top Cover Banner
              Container(
                height: 95,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.25),
                      foren.surfaceRaised1,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Status Badge Top Right
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgBase.withValues(alpha: 0.8),
                          borderRadius: AppRadius.borderRadiusSm,
                          border: Border.all(
                            color: foren.success.t500.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: foren.success.t500,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Active',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: foren.success.t500,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar Floating Over Banner & Main Identity Details
              Transform.translate(
                offset: const Offset(0, -45),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: widget.onAvatarTap,
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'profile_avatar_hero',
                              child: avatarContainer,
                            ),

                            // Camera Icon Trigger
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.surface,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 14,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Full Name
                      Text(
                        profile.fullName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Bio
                      Text(
                        profile.bio,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: foren.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      // Rank Title Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          borderRadius: AppRadius.borderRadiusSm,
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '${profile.rankTitle} · Level ${profile.level}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Level Progression & XP Progress Bar
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: foren.surfaceRaised1.withValues(alpha: 0.6),
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: foren.borderSubtle.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'XP progression',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: foren.textSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${profile.xpPoints} / ${profile.nextLevelXp} XP ($xpPercent%)',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Progress Track
                            Container(
                              height: 6,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: foren.surfaceRaised2,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: xpProgress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor,
                                        primaryColor.withValues(alpha: 0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarContent(
    String avatarUrl,
    String initials,
    Color primaryColor,
    ThemeData theme,
  ) {
    if (avatarUrl.isNotEmpty) {
      return Image.network(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) =>
            _buildInitials(initials, primaryColor, theme),
      );
    }
    return _buildInitials(initials, primaryColor, theme);
  }

  Widget _buildInitials(String initials, Color primaryColor, ThemeData theme) {
    return Container(
      color: AppColors.surfaceHighlight,
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
