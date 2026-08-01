import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/profile_entity.dart';
import '../pages/profile_screen.dart';

/// Animated Profile Banner displaying cybersecurity cover image, status badge, avatar, and experience indicator.
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
          colors: [
            primaryColor,
            AppColors.logoGold,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.35),
            blurRadius: 20,
            spreadRadius: 3,
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
            child: _buildAvatarContent(profile.avatarUrl, initials, primaryColor, theme),
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        child: GlassEffect(
          blurX: 16.0,
          blurY: 16.0,
          opacity: 0.12,
          border: Border.all(
            color: _isHovered ? primaryColor : AppColors.logoGold,
            width: _isHovered ? 1.5 : 1.0,
          ),
          borderRadius: AppRadius.borderRadiusXl,
          child: Column(
            children: [
              // Top Cover Banner Image with Grid Lines & Telemetry Badge
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
                      AppColors.logoBlue.withValues(alpha: 0.35),
                      AppColors.surfaceRaised2,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Grid Pattern Lines
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BannerGridPainter(),
                      ),
                    ),
                    // Status Badge Top Right
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                                boxShadow: [
                                  BoxShadow(
                                    color: foren.success.t500.withValues(alpha: 0.8),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ONLINE · ACTIVE OPERATIVE',
                              style: TextStyle(
                                color: foren.success.t500,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'monospace',
                                letterSpacing: 0.8,
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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: widget.onAvatarTap,
                        child: Stack(
                          children: [
                            if (ProfileScreen.enableAdvancedEffects)
                              GlowEffect(
                                glowColor: primaryColor,
                                blurRadius: 24,
                                spreadRadius: 4,
                                animate: true,
                                borderRadius: BorderRadius.circular(50),
                                child: avatarContainer,
                              )
                            else
                              avatarContainer,

                            // Camera Icon Trigger
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 14,
                                  color: Colors.black,
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
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          fontFamily: 'Geist',
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Bio / Monospace Security Role
                      Text(
                        profile.bio,
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      // Rank Title Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.logoGold.withValues(alpha: 0.15),
                          borderRadius: AppRadius.borderRadiusSm,
                          border: Border.all(
                            color: AppColors.logoGold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '${profile.rankTitle.toUpperCase()} · LEVEL ${profile.level}',
                          style: const TextStyle(
                            color: AppColors.logoGold,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Level Progression & Animated XP Progress Bar
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
                                  'XP PROGRESSION',
                                  style: TextStyle(
                                    color: foren.textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  '${profile.xpPoints} / ${profile.nextLevelXp} XP ($xpPercent%)',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
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
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.logoGold,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withValues(alpha: 0.6),
                                        blurRadius: 8,
                                      ),
                                    ],
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
        errorBuilder: (ctx, err, stack) => _buildInitials(initials, primaryColor, theme),
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
          style: const TextStyle(
            color: AppColors.logoGold,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Geist',
          ),
        ),
      ),
    );
  }
}

class _BannerGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
