/// ForenShield Component Library — Lists
/// Timeline Item / Activity Feed Item / Evidence List Item / Course List Item
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'foren_cards.dart' show ForenEvidenceType;

/// A single step in an Investigation Timeline (Signature Feature 3):
/// 08:14 Email Delivered -> 08:19 Attachment Opened -> ...
class ForenTimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final bool isLast;
  final bool isCritical; // highlights the pivotal step (e.g. "C2 Communication")

  const ForenTimelineItem({
    super.key,
    required this.time,
    required this.title,
    this.isLast = false,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final dotColor = isCritical ? foren.critical.t500 : foren.investigation.t500;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              time,
              style: theme.textTheme.labelSmall?.copyWith(color: foren.textSecondary),
            ),
          ),
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: foren.borderSubtle)),
            ],
          ),
          const SizedBox(width: ForenSpace.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: ForenSpace.md),
              child: Text(title, style: theme.textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

/// A generic row in a recent-activity feed (Mission Control home, etc).
class ForenActivityFeedItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ForenActivityFeedItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ForenSpace.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: ForenSpace.sm),
        child: Row(
          children: [
            Icon(icon, size: ForenIconSize.defaultSize, color: iconColor ?? foren.textSecondary),
            const SizedBox(width: ForenSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyMedium),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: foren.textSecondary)),
                ],
              ),
            ),
            Text(time, style: theme.textTheme.labelSmall?.copyWith(color: foren.textDisabled)),
          ],
        ),
      ),
    );
  }
}

/// Compact evidence row for list contexts (a denser sibling of
/// ForenEvidenceCard, for long evidence lists).
class ForenEvidenceListItem extends StatelessWidget {
  final String filename;
  final ForenEvidenceType type;
  final String meta;
  final VoidCallback? onTap;

  const ForenEvidenceListItem({
    super.key,
    required this.filename,
    required this.type,
    required this.meta,
    this.onTap,
  });

  IconData get _icon => switch (type) {
        ForenEvidenceType.email => Icons.mail_outline,
        ForenEvidenceType.pdf => Icons.description_outlined,
        ForenEvidenceType.pcap => Icons.public,
        ForenEvidenceType.memoryDump => Icons.memory,
        ForenEvidenceType.screenshot => Icons.photo_camera_outlined,
        ForenEvidenceType.other => Icons.insert_drive_file_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? foren.investigation.t300 : foren.investigation.t700;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(_icon, color: accent),
      title: Text(filename, style: theme.textTheme.bodyMedium),
      trailing: Text(meta, style: theme.textTheme.labelSmall?.copyWith(color: foren.textSecondary)),
      minLeadingWidth: 0,
    );
  }
}

/// Compact course row for list contexts (Academy course index).
class ForenCourseListItem extends StatelessWidget {
  final String title;
  final int lessonCount;
  final double progress; // 0..1
  final VoidCallback? onTap;

  const ForenCourseListItem({
    super.key,
    required this.title,
    required this.lessonCount,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? foren.academy.t300 : foren.academy.t700;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: foren.academy.t500.withValues(alpha: 0.14),
        child: Icon(Icons.menu_book_outlined, color: accent, size: 18),
      ),
      title: Text(title, style: theme.textTheme.bodyMedium),
      subtitle: Text('$lessonCount lessons', style: theme.textTheme.bodySmall?.copyWith(color: foren.textSecondary)),
      trailing: Text(
        '${(progress * 100).round()}%',
        style: theme.textTheme.labelMedium?.copyWith(color: accent),
      ),
      minLeadingWidth: 0,
    );
  }
}
