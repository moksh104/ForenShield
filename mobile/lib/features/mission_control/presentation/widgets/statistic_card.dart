import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Weekly Statistics Card rendering performance metrics and an fl_chart bar chart.
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: foren.borderSubtle.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stat Chips Grid
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Courses',
                    value: '$coursesCompleted',
                    color: foren.academy.t500,
                    icon: Icons.school_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: 'Cases Solved',
                    value: '$casesSolved',
                    color: foren.investigation.t500,
                    icon: Icons.search_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: 'Hours',
                    value: '${hoursPracticed.toStringAsFixed(1)}h',
                    color: foren.simulation.t500,
                    icon: Icons.timer_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: 'XP Earned',
                    value: '+$xpEarned',
                    color: primaryColor,
                    icon: Icons.bolt_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Weekly Activity & XP Output',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // FL Chart Bar Chart
            SizedBox(
              height: 130,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (dailyXpData.isEmpty
                          ? 500
                          : dailyXpData.reduce(
                              (a, b) => a > b ? a : b,
                            )) *
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
                          color: i == dailyXpData.length - 1
                              ? primaryColor
                              : primaryColor.withValues(alpha: 0.45),
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
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: foren.surfaceRaised1,
        borderRadius: AppRadius.borderRadiusSm,
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
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
    );
  }
}
