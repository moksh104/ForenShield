import 'package:flutter/material.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../pages/splash_screen.dart';

/// Animated loading progress bar with percentage count-up & cyber telemetry status text.
class LoadingBar extends StatefulWidget {
  final VoidCallback? onComplete;

  const LoadingBar({
    super.key,
    this.onComplete,
  });

  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    // Synced with 3-second splash duration constraint
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    // Start loading after initial entrance animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward().then((_) {
          if (mounted) {
            widget.onComplete?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final progressVal = _progressAnimation.value;
        final percentageInt = (progressVal * 100).toInt();

        final Widget barContent = Container(
          width: 240,
          height: 4,
          decoration: BoxDecoration(
            color: foren.surfaceRaised1.withValues(alpha: 0.8),
            borderRadius: AppRadius.borderRadiusXs,
            border: Border.all(
              color: foren.borderSubtle.withValues(alpha: 0.4),
              width: 0.5,
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressVal,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.logoGold,
                    AppColors.logoBlue,
                    primaryColor,
                  ],
                ),
                borderRadius: AppRadius.borderRadiusXs,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.logoGold.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status text & percentage row
            SizedBox(
              width: 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _getStatusText(progressVal),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: foren.textSecondary,
                        fontFamily: 'monospace',
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$percentageInt%',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.logoGold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Loading Bar with GlowEffect switch check
            if (SplashScreen.enableAdvancedEffects)
              GlowEffect(
                glowColor: AppColors.logoGold,
                blurRadius: 8,
                spreadRadius: 1,
                animate: true,
                borderRadius: AppRadius.borderRadiusXs,
                child: barContent,
              )
            else
              barContent,
          ],
        );
      },
    );
  }

  String _getStatusText(double progress) {
    if (progress < 0.25) {
      return 'INITIALIZING SENSOR MATRIX...';
    } else if (progress < 0.55) {
      return 'LOADING CYBER MODULES...';
    } else if (progress < 0.85) {
      return 'SYNCHRONIZING TELEMETRY...';
    } else if (progress < 1.0) {
      return 'COMMAND UPLINK ESTABLISHED';
    }
    return 'SYSTEM READY';
  }
}
