/// ForenShield Component Library — Cards
/// Mission / Investigation / Course / Simulation / Alert / Evidence /
/// Statistics / Achievement
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'foren_status.dart';
import 'foren_progress.dart';
import 'foren_buttons.dart';

/// Base card shell every card variant below is built on. Keeps radius,
/// elevation, padding, and border identical everywhere so a card
/// always reads as "a card" regardless of which feature it belongs to.
class ForenCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? leftAccentBar; // used by Alert Card for severity stripe

  const ForenCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(ForenSpace.md),
    this.leftAccentBar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foren = theme.extension<ForenColors>()!;

    final content = Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: ForenRadius.cardBr,
        border: Border.all(color: foren.borderSubtle, width: ForenBorderWidth.hairline),
        boxShadow: isDark ? null : ForenElevation.lightShadow(ForenElevation.level1),
      ),
      child: ClipRRect(
        borderRadius: ForenRadius.cardBr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (leftAccentBar != null) Container(width: 4, color: leftAccentBar),
            Expanded(child: Padding(padding: padding, child: child)),
          ],
        ),
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      borderRadius: ForenRadius.cardBr,
      child: InkWell(borderRadius: ForenRadius.cardBr, onTap: onTap, child: content),
    );
  }
}

/// Entry point into a Mission Briefing (see Signature Feature 1).
class ForenMissionCard extends StatelessWidget {
  final String title;
  final ForenThreatLevel priority;
  final String description;
  final int rewardXp;
  final VoidCallback? onTap;

  const ForenMissionCard({
    super.key,
    required this.title,
    required this.priority,
    required this.description,
    required this.rewardXp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? foren.missionControl.t300 : foren.missionControl.t700;

    return ForenCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.shield_outlined, size: ForenIconSize.defaultSize, color: accent),
              ForenThreatBadge(level: priority),
            ],
          ),
          const SizedBox(height: ForenSpace.sm),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: ForenSpace.xs),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(color: foren.textSecondary),
          ),
          const SizedBox(height: ForenSpace.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ForenXpChip(amount: rewardXp),
              ForenButton.primary(
                label: 'Begin',
                feature: ForenFeature.missionControl,
                size: ForenButtonSize.small,
                onPressed: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A case file inside Investigation Lab.
class ForenInvestigationCard extends StatelessWidget {
  final String caseId;
  final String title;
  final ForenDifficulty difficulty;
  final int evidenceCount;
  final ForenStatus status;
  final VoidCallback? onTap;

  const ForenInvestigationCard({
    super.key,
    required this.caseId,
    required this.title,
    required this.difficulty,
    required this.evidenceCount,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? foren.investigation.t300 : foren.investigation.t700;

    return ForenCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(caseId, style: theme.textTheme.labelMedium?.copyWith(color: accent)),
              ForenStatusChip(status: status),
            ],
          ),
          const SizedBox(height: ForenSpace.xs),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: ForenSpace.sm),
          Row(
            children: [
              ForenDifficultyBadge(level: difficulty),
              const SizedBox(width: ForenSpace.sm),
              Icon(Icons.folder_outlined, size: 14, color: foren.textSecondary),
              const SizedBox(width: 4),
              Text('$evidenceCount items', style: theme.textTheme.bodySmall?.copyWith(color: foren.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

/// A course in Cyber Academy.
class ForenCourseCard extends StatelessWidget {
  final String category;
  final String title;
  final int lessonCount;
  final double progress; // 0..1
  final VoidCallback? onTap;

  const ForenCourseCard({
    super.key,
    required this.category,
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

    return ForenCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: accent)),
          const SizedBox(height: ForenSpace.xs),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: ForenSpace.xs),
          Text('$lessonCount lessons', style: theme.textTheme.bodySmall?.copyWith(color: foren.textSecondary)),
          const SizedBox(height: ForenSpace.md),
          ForenLearningProgress(percent: progress),
        ],
      ),
    );
  }
}

/// A scenario in Simulation Lab (e.g. Phishing, Password Safety).
class ForenSimulationCard extends StatelessWidget {
  final String title;
  final String scenarioType;
  final ForenDifficulty difficulty;
  final VoidCallback? onTap;

  const ForenSimulationCard({
    super.key,
    required this.title,
    required this.scenarioType,
    required this.difficulty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? foren.simulation.t300 : foren.simulation.t700;

    return ForenCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ForenSpace.sm),
            decoration: BoxDecoration(
              color: foren.simulation.t500.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(ForenRadius.image),
            ),
            child: Icon(Icons.terminal_outlined, color: accent),
          ),
          const SizedBox(width: ForenSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(scenarioType, style: theme.textTheme.bodySmall?.copyWith(color: foren.textSecondary)),
              ],
            ),
          ),
          ForenDifficultyBadge(level: difficulty),
        ],
      ),
    );
  }
}

/// A live/incoming alert. Uses a severity-colored left accent bar
/// rather than the feature accent — alerts are semantic, not feature.
class ForenAlertCard extends StatelessWidget {
  final String message;
  final ForenThreatLevel severity;
  final String timeAgo;
  final VoidCallback? onTap;

  const ForenAlertCard({
    super.key,
    required this.message,
    required this.severity,
    required this.timeAgo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final ramp = switch (severity) {
      ForenThreatLevel.critical => foren.critical,
      ForenThreatLevel.high || ForenThreatLevel.medium => foren.warning,
      ForenThreatLevel.low => foren.success,
      ForenThreatLevel.info => foren.info,
    };

    return ForenCard(
      onTap: onTap,
      leftAccentBar: ramp.t500,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ForenThreatBadge(level: severity),
                const SizedBox(height: ForenSpace.xs),
                Text(message, style: theme.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: ForenSpace.sm),
          Text(timeAgo, style: theme.textTheme.labelSmall?.copyWith(color: foren.textSecondary)),
        ],
      ),
    );
  }
}

enum ForenEvidenceType { email, pdf, pcap, memoryDump, screenshot, other }

/// A single evidence file — used inside the Evidence Workspace
/// (Signature Feature 2).
class ForenEvidenceCard extends StatelessWidget {
  final String filename;
  final ForenEvidenceType type;
  final String meta; // e.g. "2.4 MB"
  final VoidCallback? onTap;

  const ForenEvidenceCard({
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

    return ForenCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: ForenSpace.md, vertical: ForenSpace.sm),
      child: Row(
        children: [
          Icon(_icon, size: ForenIconSize.defaultSize, color: accent),
          const SizedBox(width: ForenSpace.sm),
          Expanded(
            child: Text(filename, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis),
          ),
          Text(meta, style: theme.textTheme.labelSmall?.copyWith(color: foren.textSecondary)),
        ],
      ),
    );
  }
}

/// A single headline metric — used on the Threat Dashboard
/// (Signature Feature 4).
class ForenStatisticsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final String? trend; // e.g. "+4% this week"
  final bool trendPositive;

  const ForenStatisticsCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trend,
    this.trendPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final trendColor = trendPositive ? foren.success.t500 : foren.critical.t500;

    return ForenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.labelMedium?.copyWith(color: foren.textSecondary)),
              if (icon != null) Icon(icon, size: 18, color: foren.textSecondary),
            ],
          ),
          const SizedBox(height: ForenSpace.xs),
          Text(value, style: theme.textTheme.displaySmall),
          if (trend != null) ...[
            const SizedBox(height: 4),
            Text(trend!, style: theme.textTheme.bodySmall?.copyWith(color: trendColor)),
          ],
        ],
      ),
    );
  }
}

/// An unlockable achievement/badge.
class ForenAchievementCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool unlocked;
  final int rewardXp;
  final VoidCallback? onTap;

  const ForenAchievementCard({
    super.key,
    required this.title,
    required this.icon,
    required this.unlocked,
    required this.rewardXp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final accent = unlocked ? foren.academy.t500 : foren.textDisabled;

    return ForenCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(unlocked ? icon : Icons.lock_outline, color: accent),
          ),
          const SizedBox(height: ForenSpace.sm),
          Text(title, textAlign: TextAlign.center, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          if (unlocked)
            ForenXpChip(amount: rewardXp, showPlus: false)
          else
            Text('Locked', style: theme.textTheme.labelSmall?.copyWith(color: foren.textDisabled)),
        ],
      ),
    );
  }
}
