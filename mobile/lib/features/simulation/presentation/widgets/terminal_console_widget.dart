import 'package:flutter/material.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/terminal_line.dart';

class TerminalConsoleWidget extends StatefulWidget {
  final List<TerminalLine> lines;
  final ValueChanged<String> onCommandSubmitted;

  const TerminalConsoleWidget({
    super.key,
    required this.lines,
    required this.onCommandSubmitted,
  });

  @override
  State<TerminalConsoleWidget> createState() => _TerminalConsoleWidgetState();
}

class _TerminalConsoleWidgetState extends State<TerminalConsoleWidget> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant TerminalConsoleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lines.length != oldWidget.lines.length) {
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
    final text = _inputController.text;
    if (text.trim().isNotEmpty) {
      widget.onCommandSubmitted(text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0D12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: foren.borderSubtle.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          // Terminal Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF121721),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              border: Border(
                bottom: BorderSide(
                  color: foren.borderSubtle.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 18, color: Color(0xFF00E5FF)),
                const SizedBox(width: 8),
                const Text(
                  'FS-HOST-09 [Interactive Shell]',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E676),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'ONLINE',
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          // Terminal Output Scrollable Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.lines.length,
              itemBuilder: (context, index) {
                final line = widget.lines[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
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
              color: const Color(0xFF0E131C),
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
                    color: Color(0xFF00E5FF),
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
                        color: Color(0xFF5A667A),
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
        return const Color(0xFF00E5FF);
      case TerminalLineType.success:
        return const Color(0xFF00E676);
      case TerminalLineType.error:
        return foren.critical.t500;
      case TerminalLineType.system:
        return const Color(0xFFFFB74D);
      case TerminalLineType.prompt:
      case TerminalLineType.output:
        return const Color(0xFFD0D7DE);
    }
  }
}
