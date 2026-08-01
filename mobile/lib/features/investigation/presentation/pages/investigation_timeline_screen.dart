import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/effects/scanner_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
import '../../domain/entities/investigation_entity.dart';
import '../../domain/entities/timeline_entity.dart';
import '../providers/investigation_provider.dart';

/// Interactive Chronological Attack Timeline Screen with expand/collapse and filter options.
class InvestigationTimelineScreen extends ConsumerStatefulWidget {
  final String caseId;

  const InvestigationTimelineScreen({super.key, required this.caseId});

  @override
  ConsumerState<InvestigationTimelineScreen> createState() =>
      _InvestigationTimelineScreenState();
}

class _InvestigationTimelineScreenState
    extends ConsumerState<InvestigationTimelineScreen> {
  InvestigationEntity? _caseDetail;
  bool _isLoading = true;
  String _selectedSeverityFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  Future<void> _loadTimeline() async {
    final repo = ref.read(investigationRepositoryProvider);
    final result = await repo.getCaseDetail(widget.caseId);
    result.when(
      success: (data) {
        if (mounted) {
          setState(() {
            _caseDetail = data;
            _isLoading = false;
          });
        }
      },
      failure: (_) {
        if (mounted) setState(() => _isLoading = false);
      },
    );
  }

  void _toggleExpand(int index) {
    final c = _caseDetail;
    if (c == null) return;
    final updatedTimeline = List<TimelineEventEntity>.from(c.timeline);
    final current = updatedTimeline[index];
    updatedTimeline[index] = current.copyWith(isExpanded: !current.isExpanded);

    setState(() {
      _caseDetail = c.copyWith(timeline: updatedTimeline);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final primaryColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: ScannerEffect(
                  color: primaryColor,
                  child: const Center(
                    child: Icon(Icons.timeline, size: 48, color: AppColors.logoGold),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'BUILDING CHRONOLOGICAL TIMELINE...',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final caseDetail = _caseDetail;
    if (caseDetail == null) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        appBar: AppBar(backgroundColor: AppColors.bgBase),
        body: Center(
          child: Text(
            'Timeline unavailable.',
            style: TextStyle(color: foren.textSecondary),
          ),
        ),
      );
    }

    final filteredTimeline = caseDetail.timeline.where((event) {
      if (_selectedSeverityFilter != 'All' &&
          event.severity.toLowerCase() !=
              _selectedSeverityFilter.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chronological Attack Timeline',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            fontFamily: 'Geist',
          ),
        ),
      ),
      body: ParticleBackground(
        numberOfParticles: 40,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: Stack(
          children: [
            const Positioned.fill(child: BackgroundGrid()),
            SafeArea(
              child: Column(
                children: [
                  // Severity Filter Bar
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: ['All', 'Critical', 'High', 'Medium'].map((sev) {
                        final isSelected = _selectedSeverityFilter == sev;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(sev),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _selectedSeverityFilter = sev);
                            },
                            selectedColor: invColor,
                            backgroundColor: AppColors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusSm,
                              side: BorderSide(
                                color: isSelected ? invColor : foren.borderSubtle,
                                width: 1.0,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? theme.scaffoldBackgroundColor
                                  : foren.textSecondary,
                              fontSize: 11,
                              fontWeight:
                                  isSelected ? FontWeight.w800 : FontWeight.w500,
                              fontFamily: 'monospace',
                            ),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms),

                  // Timeline Tree View
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: filteredTimeline.length,
                      itemBuilder: (context, index) {
                        final event = filteredTimeline[index];
                        final isLast = index == filteredTimeline.length - 1;
                        final sevColor = _getSeverityColor(foren, event.severity);

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline Node & Connector Line
                              Column(
                                children: [
                                  GlowEffect(
                                    glowColor: sevColor,
                                    blurRadius: 8,
                                    animate: true,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: sevColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: foren.borderSubtle.withValues(alpha: 0.4),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: AppSpacing.md),

                              // Event Card Block
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                  child: GlassEffect(
                                    blurX: 12.0,
                                    blurY: 12.0,
                                    opacity: 0.10,
                                    border: Border.all(
                                      color: foren.borderSubtle.withValues(alpha: 0.4),
                                      width: 1.0,
                                    ),
                                    borderRadius: AppRadius.borderRadiusMd,
                                    child: InkWell(
                                      onTap: () => _toggleExpand(index),
                                      borderRadius: AppRadius.borderRadiusMd,
                                      child: Padding(
                                        padding: const EdgeInsets.all(AppSpacing.md),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  event.timestamp,
                                                  style: TextStyle(
                                                    color: foren.textSecondary,
                                                    fontSize: 10,
                                                    fontFamily: 'monospace',
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: sevColor.withValues(alpha: 0.15),
                                                    borderRadius: AppRadius.borderRadiusXs,
                                                    border: Border.all(color: sevColor.withValues(alpha: 0.3)),
                                                  ),
                                                  child: Text(
                                                    event.severity.toUpperCase(),
                                                    style: TextStyle(
                                                      color: sevColor,
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w800,
                                                      fontFamily: 'monospace',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              event.title,
                                              style: TextStyle(
                                                color: theme.colorScheme.onSurface,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            if (event.isExpanded) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                event.description,
                                                style: TextStyle(
                                                  color: foren.textSecondary,
                                                  fontSize: 12,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(delay: Duration(milliseconds: index * 80))
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.08, end: 0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(ForenColors foren, String sev) {
    switch (sev.toLowerCase()) {
      case 'critical':
        return foren.critical.t500;
      case 'high':
        return foren.warning.t500;
      case 'medium':
        return AppColors.primary;
      case 'low':
      default:
        return foren.success.t500;
    }
  }
}
