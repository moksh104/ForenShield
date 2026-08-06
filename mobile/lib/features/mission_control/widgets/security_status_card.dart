import 'package:forenshield/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A visually striking security score card with an animated arc indicator.
///
/// All data is passed in as parameters — no provider dependencies.
class SecurityStatusCard extends StatefulWidget {
  final double score; // 0.0 – 100.0
  final String statusLabel;
  final List<SecurityMetric> metrics;

  const SecurityStatusCard({
    super.key,
    this.score = 82.0,
    this.statusLabel = 'Good',
    this.metrics = const [],
  });

  @override
  State<SecurityStatusCard> createState() => _SecurityStatusCardState();
}

class _SecurityStatusCardState extends State<SecurityStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = _scoreColor(widget.score, theme);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceContainerHigh,
              theme.colorScheme.surfaceContainerHighest,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Arc gauge
              AnimatedBuilder(
                animation: _animation,
                builder: (_, _) => SizedBox(
                  width: 90,
                  height: 90,
                  child: CustomPaint(
                    painter: _ArcPainter(
                      progress: widget.score / 100 * _animation.value,
                      color: scoreColor,
                      backgroundColor: theme.colorScheme.surfaceContainerLowest,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(widget.score * _animation.value).toInt()}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: scoreColor,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            'pts',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
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
                            color: scoreColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.statusLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scoreColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Security posture',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...widget.metrics.map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _MetricRow(metric: m),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _scoreColor(double score, ThemeData theme) {
    if (score >= 80) return Colors.greenAccent.shade400;
    if (score >= 60) return Colors.orangeAccent.shade200;
    return theme.colorScheme.error;
  }
}

class _MetricRow extends StatelessWidget {
  final SecurityMetric metric;
  const _MetricRow({required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          metric.icon,
          size: 13,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
        ),
        const SizedBox(width: 6),
        Text(
          metric.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
        const Spacer(),
        Text(
          metric.value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: metric.valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress || old.color != color;
}

/// A simple metric model for the [SecurityStatusCard].
class SecurityMetric {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const SecurityMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
}
