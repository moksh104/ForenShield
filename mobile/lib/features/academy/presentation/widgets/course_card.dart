import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/course_entity.dart';

/// Reusable Course Card for Cyber Academy matching exact design spec screenshot.
class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback? onTap;
  final VoidCallback? onContinueTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);
    final foren = theme.extension<ForenColors>()!;

    final config = _getTopicConfig(course.title);
    final int lessonsCount = course.modules.fold(
      0,
      (sum, m) => sum + m.lessons.length,
    );

    final int hours = course.durationMinutes ~/ 60;
    final int mins = course.durationMinutes % 60;
    final String timeStr = mins > 0 ? '${hours}h ${mins}m' : '${hours}h';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : Colors.white,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: isDark ? foren.borderSubtle : const Color(0xFFE2E8F0),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left Large Topic Icon Box ──
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isDark ? config.darkBg : config.lightBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: _buildTopicIcon(config.iconType, config.iconColor),
                  ),
                ),
                const SizedBox(width: 14),

                // ── Middle Column ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Level Badge Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: config.badgeBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          course.difficulty,
                          style: TextStyle(
                            color: config.badgeTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Title
                      Text(
                        course.title,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Outfit',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),

                      // Subtitle / Description
                      Text(
                        course.description,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 11.5,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: course.completionPercentage,
                          minHeight: 4,
                          backgroundColor: isDark
                              ? AppColors.surfaceRaised1
                              : const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Bottom Metadata Row: Percent Complete | Lessons | Time
                      Row(
                        children: [
                          if (course.completionPercentage > 0)
                            Text(
                              '${(course.completionPercentage * 100).round()}% Complete',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          else
                            Text(
                              'Not started',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const Spacer(),
                          if (lessonsCount > 0)
                            Text(
                              ' Lessons',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          if (course.durationMinutes > 0) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Icon(
                              Icons.access_time_rounded,
                              size: 13,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              timeStr,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // ── Top Right Chevron ──
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicIcon(_IconType type, Color iconColor) {
    switch (type) {
      case _IconType.digitalForensics:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.fingerprint,
              size: 36,
              color: iconColor.withValues(alpha: 0.7),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Icon(Icons.search, size: 22, color: iconColor),
            ),
          ],
        );
      case _IconType.malwareAnalysis:
        return Icon(Icons.bug_report_outlined, size: 38, color: iconColor);
      case _IconType.phishing:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.mail_outline_rounded, size: 34, color: iconColor),
            Positioned(
              top: 2,
              right: 4,
              child: Icon(Icons.phishing, size: 20, color: iconColor),
            ),
          ],
        );
      case _IconType.networkSecurity:
        return Icon(Icons.hub_outlined, size: 36, color: iconColor);
      case _IconType.linuxForensics:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.desktop_windows_outlined, size: 38, color: iconColor),
            Icon(Icons.terminal_rounded, size: 18, color: iconColor),
          ],
        );
      case _IconType.mobileForensics:
        return Icon(Icons.smartphone_outlined, size: 36, color: iconColor);
    }
  }

  _TopicConfig _getTopicConfig(String title) {
    final t = title.toLowerCase();
    if (t.contains('digital') || t.contains('ram') || t.contains('memory')) {
      return const _TopicConfig(
        iconType: _IconType.digitalForensics,
        lightBg: Color(0xFFEFF6FF),
        darkBg: Color(0xFF1E293B),
        iconColor: Color(0xFF1E3A8A),
        badgeBg: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF2563EB),
      );
    } else if (t.contains('malware') || t.contains('reverse')) {
      return const _TopicConfig(
        iconType: _IconType.malwareAnalysis,
        lightBg: Color(0xFFF0FDF4),
        darkBg: Color(0xFF162E21),
        iconColor: Color(0xFF14532D),
        badgeBg: Color(0xFFF0FDF4),
        badgeTextColor: Color(0xFF16A34A),
      );
    } else if (t.contains('phishing')) {
      return const _TopicConfig(
        iconType: _IconType.phishing,
        lightBg: Color(0xFFFFF7ED),
        darkBg: Color(0xFF331F14),
        iconColor: Color(0xFFC2410C),
        badgeBg: Color(0xFFFFF7ED),
        badgeTextColor: Color(0xFFEA580C),
      );
    } else if (t.contains('network')) {
      return const _TopicConfig(
        iconType: _IconType.networkSecurity,
        lightBg: Color(0xFFEFF6FF),
        darkBg: Color(0xFF1E293B),
        iconColor: Color(0xFF1E3A8A),
        badgeBg: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF2563EB),
      );
    } else if (t.contains('linux')) {
      return const _TopicConfig(
        iconType: _IconType.linuxForensics,
        lightBg: Color(0xFFFEFCE8),
        darkBg: Color(0xFF333014),
        iconColor: Color(0xFFA16207),
        badgeBg: Color(0xFFFFF7ED),
        badgeTextColor: Color(0xFFEA580C),
      );
    } else {
      return const _TopicConfig(
        iconType: _IconType.mobileForensics,
        lightBg: Color(0xFFEFF6FF),
        darkBg: Color(0xFF1E293B),
        iconColor: Color(0xFF1E3A8A),
        badgeBg: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF2563EB),
      );
    }
  }
}

enum _IconType {
  digitalForensics,
  malwareAnalysis,
  phishing,
  networkSecurity,
  linuxForensics,
  mobileForensics,
}

class _TopicConfig {
  final _IconType iconType;
  final Color lightBg;
  final Color darkBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeTextColor;

  const _TopicConfig({
    required this.iconType,
    required this.lightBg,
    required this.darkBg,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeTextColor,
  });
}
