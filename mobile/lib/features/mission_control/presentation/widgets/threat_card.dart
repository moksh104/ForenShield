import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Cyber Risk Status Card displaying overall threat level, security score, and today's risk status.
/// Refined: single hero element (animated score ring), no scanner/glass/glow overload.
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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: themeColor.withValues(alpha: 0.35)),
        boxShadow: AppShadows.forBrightness(
          brightness: theme.brightness,
          level: ElevationLevel.low,
        ),
      ),
      child: Row(
        children: [
          // Animated Score Ring (hero element)
          SizedBox(
            width: 88,
            height: 88,
            child: AnimatedBuilder(
              animation: _scoreAnim,
              builder: (context, child) {
                final currentProgress =
                    (widget.securityScore / 100) * _scoreAnim.value;
                final currentScore = (widget.securityScore * _scoreAnim.value)
                    .toInt();

                return CustomPaint(
                  size: const Size(88, 88),
                  painter: _RingGaugePainter(
                    progress: currentProgress,
                    color: themeColor,
                    trackColor: foren.surfaceRaised1.withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$currentScore',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: themeColor,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'SCORE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: foren.textDisabled,
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
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Threat level: ${widget.threatLevel}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: themeColor,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Overall Cyber Posture',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.todayRiskMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foren.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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
