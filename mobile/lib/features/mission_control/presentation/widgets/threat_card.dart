import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/scanner_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Cyber Risk Status Card displaying overall threat level, security score, today's risk status, and an animated scanner ring.
class ThreatCard extends StatefulWidget {
  final String threatLevel;
  final int securityScore;
  final String todayRiskMessage;

  const ThreatCard({
    super.key,
    required this.threatLevel,
    required this.securityScore,
    required this.todayRiskMessage,
  });

  @override
  State<ThreatCard> createState() => _ThreatCardState();
}

class _ThreatCardState extends State<ThreatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scoreAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scoreAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final themeColor = _getThreatColor(foren, widget.threatLevel);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          child: GlowEffect(
            glowColor: themeColor,
            blurRadius: _isHovered ? 20.0 : 12.0,
            spreadRadius: _isHovered ? 3.0 : 1.0,
            animate: _isHovered || widget.threatLevel.toUpperCase() == 'CRITICAL',
            borderRadius: AppRadius.borderRadiusLg,
            child: GlassEffect(
              blurX: 16.0,
              blurY: 16.0,
              opacity: _isHovered ? 0.18 : 0.12,
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(
                color: _isHovered
                    ? themeColor.withValues(alpha: 0.6)
                    : themeColor.withValues(alpha: 0.35),
                width: _isHovered ? 1.5 : 1.0,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // Animated Status Ring Gauge with Scanner Effect
                  SizedBox(
                    width: 88,
                    height: 88,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Radar Scanner Background Sweep
                        ScannerEffect(
                          size: 80.0,
                          color: themeColor,
                          duration: const Duration(milliseconds: 3000),
                        ),
                        // Ring Gauge Painter with Count-Up Score
                        AnimatedBuilder(
                          animation: _scoreAnim,
                          builder: (context, child) {
                            final currentProgress =
                                (widget.securityScore / 100) * _scoreAnim.value;
                            final currentScore =
                                (widget.securityScore * _scoreAnim.value).toInt();

                            return CustomPaint(
                              size: const Size(88, 88),
                              painter: _RingGaugePainter(
                                progress: currentProgress,
                                color: themeColor,
                                trackColor: foren.surfaceRaised1.withValues(alpha: 0.4),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$currentScore',
                                      style: TextStyle(
                                        color: themeColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        height: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'SCORE',
                                      style: TextStyle(
                                        color: foren.textDisabled,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Status Info Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: themeColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withValues(alpha: 0.6),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'THREAT LEVEL: ${widget.threatLevel}',
                                style: TextStyle(
                                  color: themeColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Overall Cyber Posture',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          widget.todayRiskMessage,
                          style: TextStyle(
                            color: foren.textSecondary,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getThreatColor(ForenColors foren, String level) {
    switch (level.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH':
        return foren.critical.t500;
      case 'MODERATE':
      case 'MEDIUM':
        return foren.warning.t500;
      case 'LOW':
      default:
        return foren.success.t500;
    }
  }
}

class _RingGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  const _RingGaugePainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
