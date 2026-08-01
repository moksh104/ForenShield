import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/terminal_line.dart';

/// Interactive terminal shell component for Simulation Lab scenarios with glassmorphism.
class TerminalConsoleWidget extends StatefulWidget {
  final List<TerminalLine>? history;
  final List<TerminalLine>? lines;
  final ValueChanged<String>? onCommandSubmitted;

  const TerminalConsoleWidget({
    super.key,
    this.history,
    this.lines,
    this.onCommandSubmitted,
  });

  List<TerminalLine> get effectiveHistory => history ?? lines ?? const [];

  @override
  State<TerminalConsoleWidget> createState() => _TerminalConsoleWidgetState();
}

class _TerminalConsoleWidgetState extends State<TerminalConsoleWidget> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(TerminalConsoleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.effectiveHistory.length != oldWidget.effectiveHistory.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      widget.onCommandSubmitted?.call(text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final historyList = widget.effectiveHistory;
    final primaryColor = theme.colorScheme.primary;

    return GlassEffect(
      blurX: 14.0,
      blurY: 14.0,
      opacity: 0.12,
      border: Border.all(
        color: primaryColor.withValues(alpha: 0.35),
        width: 1.0,
      ),
      borderRadius: AppRadius.buttonRadius,
      child: Column(
        children: [
          // Terminal Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              border: Border(
                bottom: BorderSide(
                  color: foren.borderSubtle.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'FS-HOST-09 [Interactive Shell]',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                GlowEffect(
                  glowColor: AppColors.success,
                  blurRadius: 8,
                  animate: true,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'VM ONLINE',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Terminal Output Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final line = historyList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SelectableText(
                    line.text,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.4,
                      color: _getLineColor(line.type, foren),
                    ),
                  ),
                );
              },
            ),
          ),

          // Terminal Input Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.8),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(11)),
              border: Border(
                top: BorderSide(
                  color: foren.borderSubtle.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'root@vm:~# ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    onSubmitted: (_) => _handleSubmit(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'type command (e.g. netstat, pkill, iptables, help)...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, size: 18),
                  color: theme.colorScheme.primary,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLineColor(TerminalLineType type, ForenColors foren) {
    switch (type) {
      case TerminalLineType.input:
        return AppColors.primary;
      case TerminalLineType.success:
        return AppColors.success;
      case TerminalLineType.error:
        return foren.critical.t500;
      case TerminalLineType.system:
        return AppColors.warning;
      case TerminalLineType.prompt:
      case TerminalLineType.output:
        return AppColors.textPrimary;
    }
  }
}
