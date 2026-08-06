import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Weekly Statistics Card rendering performance metrics, count-up animations, and fl_chart bar chart.
class StatisticCard extends StatelessWidget {
  final int coursesCompleted;
  final int casesSolved;
  final double hoursPracticed;
  final int xpEarned;
  final List<double> dailyXpData;

  const StatisticCard({
    super.key,
    required this.coursesCompleted,
    required this.casesSolved,
    required this.hoursPracticed,
    required this.xpEarned,
    required this.dailyXpData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final days = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.4)),
        boxShadow: AppShadows.forBrightness(
          brightness: theme.brightness,
          level: ElevationLevel.low,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Chips Grid with Count-Up Animations
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Courses',
                  numericValue: coursesCompleted.toDouble(),
                  valueFormatter: (val) => '${val.toInt()}',
                  color: foren.academy.t500,
                  icon: Icons.school_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _StatTile(
                  label: 'Cases Solved',
                  numericValue: casesSolved.toDouble(),
                  valueFormatter: (val) => '${val.toInt()}',
                  color: foren.investigation.t500,
                  icon: Icons.search_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _StatTile(
                  label: 'Hours',
                  numericValue: hoursPracticed,
                  valueFormatter: (val) => '${val.toStringAsFixed(1)}h',
                  color: foren.simulation.t500,
                  icon: Icons.timer_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _StatTile(
                  label: 'XP Earned',
                  numericValue: xpEarned.toDouble(),
                  valueFormatter: (val) => '+${val.toInt()}',
                  color: primaryColor,
                  icon: Icons.bolt_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Icon(Icons.analytics_outlined, size: 16, color: primaryColor),
              const SizedBox(width: 6),
              Text(
                'Weekly Activity & XP Output',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // FL Chart Bar Chart
          SizedBox(
            height: 130,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    (dailyXpData.isEmpty
                        ? 500
                        : dailyXpData.reduce((a, b) => a > b ? a : b)) *
                    1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => foren.surfaceRaised2,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} XP',
                        TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[idx],
                              style: TextStyle(
                                color: foren.textDisabled,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  dailyXpData.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: dailyXpData[i],
                        gradient: LinearGradient(
                          colors: i == dailyXpData.length - 1
                              ? [primaryColor, foren.investigation.t500]
                              : [
                                  primaryColor.withValues(alpha: 0.6),
                                  primaryColor.withValues(alpha: 0.2),
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatefulWidget {
  final String label;
  final double numericValue;
  final String Function(double) valueFormatter;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.numericValue,
    required this.valueFormatter,
    required this.color,
    required this.icon,
  });

  @override
  State<_StatTile> createState() => _StatTileState();
}

class _StatTileState extends State<_StatTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return InkWell(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCirc,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.color.withValues(alpha: 0.15)
              : foren.surfaceRaised1.withValues(alpha: 0.6),
          borderRadius: AppRadius.borderRadiusSm,
          border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(widget.icon, size: 16, color: widget.color),
            const SizedBox(height: AppSpacing.xs),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: widget.numericValue),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, val, child) {
                return Text(
                  widget.valueFormatter(val),
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                );
              },
            ),
            const SizedBox(height: 2),
            Text(
              widget.label,
              style: TextStyle(
                color: foren.textDisabled,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
