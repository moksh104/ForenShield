import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/progress/lesson_progress_bar.dart';
import '../../../../routes/route_constants.dart';
import '../../data/datasources/simulation_mock_data.dart';
import '../../domain/entities/simulation_scenario.dart';

enum TerminalLineType { system, command, output, warning, success, error }

class TerminalLine {
  final String text;
  final TerminalLineType type;
  TerminalLine(this.text, [this.type = TerminalLineType.output]);
}

class TerminalRunnerState {
  final SimulationScenario? scenario;
  final List<TerminalLine> lines;
  final List<SimulationObjective> objectives;
  final int secondsElapsed;
  final bool isCompleted;

  const TerminalRunnerState({
    this.scenario,
    this.lines = const [],
    this.objectives = const [],
    this.secondsElapsed = 0,
    this.isCompleted = false,
  });

  TerminalRunnerState copyWith({
    SimulationScenario? scenario,
    List<TerminalLine>? lines,
    List<SimulationObjective>? objectives,
    int? secondsElapsed,
    bool? isCompleted,
  }) =>
      TerminalRunnerState(
        scenario: scenario ?? this.scenario,
        lines: lines ?? this.lines,
        objectives: objectives ?? this.objectives,
        secondsElapsed: secondsElapsed ?? this.secondsElapsed,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  int get completedObjectives => objectives.where((o) => o.isCompleted).length;
}

class TerminalRunnerNotifier extends StateNotifier<TerminalRunnerState> {
  Timer? _timer;
  final String scenarioId;

  TerminalRunnerNotifier(this.scenarioId) : super(const TerminalRunnerState()) {
    _init();
  }

  void _init() {
    final scenario = SimulationMockData.scenarios.firstWhere(
      (s) => s.id == scenarioId,
      orElse: () => SimulationMockData.scenarios.first,
    );

    final bootLines = scenario.initialTerminalHistory
        .asMap()
        .entries
        .map((e) => TerminalLine(
              e.value,
              e.value.startsWith('WARNING') || e.value.startsWith('ERROR')
                  ? TerminalLineType.warning
                  : TerminalLineType.system,
            ))
        .toList();

    state = state.copyWith(
      scenario: scenario,
      lines: bootLines,
      objectives: List.from(scenario.objectives),
      secondsElapsed: 0,
      isCompleted: false,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      state = state.copyWith(secondsElapsed: state.secondsElapsed + 1);
    });
  }

  void clearTerminal() {
    final bootLines = state.scenario?.initialTerminalHistory
            .asMap()
            .entries
            .map((e) => TerminalLine(e.value, TerminalLineType.system))
            .toList() ??
        [];
    state = state.copyWith(lines: bootLines);
  }

  void restart() {
    _init();
  }

  void submitCommand(String raw) {
    final cmd = raw.trim();
    if (cmd.isEmpty) return;

    final newLines = List<TerminalLine>.from(state.lines);
    newLines.add(TerminalLine('root@forenshield:~# $cmd', TerminalLineType.command));

    final updatedObjectives = List<SimulationObjective>.from(state.objectives);
    bool anyUnlocked = false;

    for (int i = 0; i < updatedObjectives.length; i++) {
      final obj = updatedObjectives[i];
      if (!obj.isCompleted &&
          cmd.toLowerCase().contains(obj.targetCommandKeyword.toLowerCase())) {
        updatedObjectives[i] = obj.copyWith(isCompleted: true);
        anyUnlocked = true;
        newLines.addAll(_generateCommandOutput(cmd, obj));
        newLines.add(TerminalLine(
          '[+] Objective completed: ${obj.title}',
          TerminalLineType.success,
        ));
      }
    }

    if (!anyUnlocked) newLines.addAll(_genericOutput(cmd));

    final allDone = updatedObjectives.every((o) => o.isCompleted);
    if (allDone && !state.isCompleted) {
      newLines.add(TerminalLine('=' * 48, TerminalLineType.success));
      newLines.add(TerminalLine('[OK] ALL OBJECTIVES COMPLETED — Incident Contained', TerminalLineType.success));
      newLines.add(TerminalLine('[+] Threat neutralized. Workstation secured.', TerminalLineType.success));
      newLines.add(TerminalLine('=' * 48, TerminalLineType.success));
      _timer?.cancel();
    }

    state = state.copyWith(
      lines: newLines,
      objectives: updatedObjectives,
      isCompleted: allDone,
    );
  }

  List<TerminalLine> _generateCommandOutput(String cmd, SimulationObjective obj) {
    final keyword = obj.targetCommandKeyword.toLowerCase();
    if (keyword == 'netstat') {
      return [
        TerminalLine('Active Internet connections (w/o servers)'),
        TerminalLine('Proto  Local Address          Foreign Address        State'),
        TerminalLine('tcp    192.168.1.45:49223     203.0.113.77:4444      ESTABLISHED', TerminalLineType.warning),
        TerminalLine('tcp    192.168.1.45:443       216.58.211.14:443      ESTABLISHED'),
        TerminalLine('[!] Suspicious ESTABLISHED connection to port 4444 -- C2: 203.0.113.77', TerminalLineType.warning),
      ];
    } else if (keyword == 'pkill' || keyword == 'kill') {
      return [
        TerminalLine('Scanning process list for ransomware_agent...'),
        TerminalLine('PID 4092   ransomware_agent   CPU: 87%', TerminalLineType.warning),
        TerminalLine('Sending SIGKILL to PID 4092...'),
        TerminalLine('[+] Process 4092 (ransomware_agent) terminated.', TerminalLineType.success),
      ];
    } else if (keyword == 'iptables') {
      return [
        TerminalLine('Applying firewall rule...'),
        TerminalLine('iptables: DROP tcp dport 4444 added to INPUT chain'),
        TerminalLine('[+] Port 4444 blocked. C2 channel severed.', TerminalLineType.success),
      ];
    } else if (keyword == 'cat') {
      return [
        TerminalLine('/var/log/nginx/access.log:'),
        TerminalLine('203.0.113.50 "GET /?id=1 UNION SELECT 1,2,3--" 200', TerminalLineType.warning),
        TerminalLine('[!] SQLi payloads detected from 203.0.113.50', TerminalLineType.warning),
      ];
    } else if (keyword == 'waf-apply') {
      return [
        TerminalLine('Loading WAF ruleset: sqli-block...'),
        TerminalLine('[+] WAF rule deployed -- SQL injection inputs sanitized.', TerminalLineType.success),
      ];
    } else if (keyword == 'grep') {
      return [
        TerminalLine('Searching /var/log/auth.log...'),
        TerminalLine('Failed password for admin from 45.33.32.156 (x147)', TerminalLineType.warning),
        TerminalLine('[!] Brute-force SSH attack detected from 45.33.32.156', TerminalLineType.warning),
      ];
    } else if (keyword == 'revoke-key') {
      return [
        TerminalLine('Locating SSH authorized_keys for admin...'),
        TerminalLine('Revoking compromised key and invalidating sessions...'),
        TerminalLine('[+] SSH key revoked. Admin account secured.', TerminalLineType.success),
      ];
    }
    return [TerminalLine('Command executed.')];
  }

  List<TerminalLine> _genericOutput(String cmd) {
    final lower = cmd.toLowerCase();
    if (lower == 'help') {
      return [
        TerminalLine('Available commands:'),
        TerminalLine('  netstat / netstat -an   -- Active network connections'),
        TerminalLine('  pkill <name>            -- Terminate process by name'),
        TerminalLine('  iptables <rule>         -- Manage firewall rules'),
        TerminalLine('  cat <file>              -- Read file contents'),
        TerminalLine('  grep <pattern> <file>   -- Search file for pattern'),
        TerminalLine('  waf-apply               -- Deploy WAF rules'),
        TerminalLine('  revoke-key              -- Revoke SSH authorized key'),
        TerminalLine('  status                  -- View sandbox health'),
        TerminalLine('  clear                   -- Clear terminal'),
      ];
    } else if (lower == 'clear') {
      clearTerminal();
      return [];
    } else if (lower == 'status') {
      return [
        TerminalLine('System status: ISOLATED'),
        TerminalLine('Sandbox container: ACTIVE'),
        TerminalLine('Firewall: ENFORCING'),
      ];
    } else if (lower.startsWith('ls')) {
      return [
        TerminalLine('drwxr-xr-x  /var/log/nginx'),
        TerminalLine('-rw-r--r--  /tmp/.ransomware_agent', TerminalLineType.warning),
        TerminalLine('-rw-r--r--  /var/log/auth.log'),
      ];
    } else if (lower.startsWith('ps')) {
      return [
        TerminalLine('  PID  CMD'),
        TerminalLine('    1  systemd'),
        TerminalLine(' 4092  ransomware_agent  [HIGH CPU]', TerminalLineType.warning),
      ];
    } else if (lower.startsWith('whoami')) {
      return [TerminalLine('root')];
    } else {
      return [
        TerminalLine(
          'bash: $cmd: command not found. Type "help" for available commands.',
          TerminalLineType.error,
        ),
      ];
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final terminalRunnerProvider = StateNotifierProvider.family<
    TerminalRunnerNotifier, TerminalRunnerState, String>(
  (ref, scenarioId) => TerminalRunnerNotifier(scenarioId),
);

// ---- Screen ----------------------------------------------------------------

class TerminalRunnerScreen extends ConsumerStatefulWidget {
  final String scenarioId;
  const TerminalRunnerScreen({super.key, required this.scenarioId});

  @override
  ConsumerState<TerminalRunnerScreen> createState() => _TerminalRunnerScreenState();
}

class _TerminalRunnerScreenState extends ConsumerState<TerminalRunnerScreen> {
  final TextEditingController _cmdCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _cmdCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _cmdCtrl.text.trim();
    if (text.isEmpty) return;
    _cmdCtrl.clear();
    ref.read(terminalRunnerProvider(widget.scenarioId).notifier).submitCommand(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _fmt(int total) {
    final m = (total ~/ 60).toString().padLeft(2, '0');
    final s = (total % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(terminalRunnerProvider(widget.scenarioId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Palette aligned with ForenShield White Theme
    final bgColor = isDark ? ForenNeutralDark.bgBase : const Color(0xFFF8FAFC);
    final cardBg = isDark ? ForenNeutralDark.bgSurface : Colors.white;
    final textPrimary = isDark ? ForenNeutralDark.textPrimary : const Color(0xFF0F172A);
    final textSecondary = isDark ? ForenNeutralDark.textSecondary : const Color(0xFF64748B);
    final borderColor = isDark ? ForenNeutralDark.borderDefault : const Color(0xFFE2E8F0);
    const primaryBlue = Color(0xFF2563EB);

    ref.listen(
      terminalRunnerProvider(widget.scenarioId).select((s) => s.lines.length),
      (_, _) => _scrollToBottom(),
    );

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Navigation Bar ──
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, size: 18, color: textPrimary),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RouteConstants.simulation);
                      }
                    },
                    tooltip: 'Back to Simulation Lab',
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.scenario?.title ?? 'Incident Simulation Lab',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        Text(
                          'Interactive Threat Remediation Shell',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Live Timer Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: primaryBlue),
                        const SizedBox(width: 4),
                        Text(
                          _fmt(state.secondsElapsed),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.restart_alt_rounded, size: 20, color: textSecondary),
                    tooltip: 'Restart Lab',
                    onPressed: () {
                      ref.read(terminalRunnerProvider(widget.scenarioId).notifier).restart();
                    },
                  ),
                ],
              ),
            ),

            // ── Objective Progress Bar ──
            if (state.objectives.isNotEmpty)
              Container(
                color: cardBg,
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: LessonProgressBar(
                        totalSteps: state.objectives.length,
                        completedSteps: state.completedObjectives,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${state.completedObjectives}/${state.objectives.length} Completed',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: state.isCompleted ? const Color(0xFF16A34A) : primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Completion Banner (if finished) ──
            if (state.isCompleted)
              Container(
                margin: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, 0),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: AppRadius.borderRadiusMd,
                  border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Incident Contained! All Objectives Met',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF15803D),
                            ),
                          ),
                          Text(
                            '+${state.scenario?.xpReward ?? 350} XP Awarded • System secured',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF166534)),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () => context.go(RouteConstants.simulation),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Back to Hub', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),

            // ── Terminal Console Window (WHITE THEME) ──
            Expanded(
              flex: 5,
              child: _WhiteTerminalPanel(
                lines: state.lines,
                scrollCtrl: _scrollCtrl,
                onClear: () {
                  ref.read(terminalRunnerProvider(widget.scenarioId).notifier).clearTerminal();
                },
              ),
            ),

            // ── Command Input Box (WHITE THEME) ──
            _WhiteCommandInput(
              controller: _cmdCtrl,
              focusNode: _focusNode,
              onSubmit: _submit,
            ),

            // ── Objectives & Quick Commands (WHITE THEME) ──
            Expanded(
              flex: 4,
              child: _WhiteObjectivesPanel(
                objectives: state.objectives,
                onQuickCommand: (cmd) {
                  _cmdCtrl.text = cmd;
                  _focusNode.requestFocus();
                  _submit();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WHITE THEME TERMINAL PANEL
// ─────────────────────────────────────────────────────────────────────────────

class _WhiteTerminalPanel extends StatelessWidget {
  final List<TerminalLine> lines;
  final ScrollController scrollCtrl;
  final VoidCallback onClear;

  const _WhiteTerminalPanel({
    required this.lines,
    required this.scrollCtrl,
    required this.onClear,
  });

  Widget _buildLine(TerminalLine line) {
    // Enhanced rich styling for command entries
    if (line.type == TerminalLineType.command &&
        line.text.startsWith('root@forenshield:~# ')) {
      final cmd = line.text.substring('root@forenshield:~# '.length);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              fontFamily: 'monospace',
            ),
            children: [
              const TextSpan(
                text: 'root@forenshield:~# ',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: cmd,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Color textColor;
    FontWeight fontWeight = FontWeight.w500;

    switch (line.type) {
      case TerminalLineType.system:
        textColor = const Color(0xFF475569); // Slate-600
        fontWeight = FontWeight.w600;
        break;
      case TerminalLineType.command:
        textColor = const Color(0xFF0F172A);
        fontWeight = FontWeight.w700;
        break;
      case TerminalLineType.warning:
        textColor = const Color(0xFFD97706); // Amber-600 (readable on white)
        fontWeight = FontWeight.w600;
        break;
      case TerminalLineType.success:
        textColor = const Color(0xFF16A34A); // Emerald-600 (crisp on white)
        fontWeight = FontWeight.w700;
        break;
      case TerminalLineType.error:
        textColor = const Color(0xFFDC2626); // Red-600
        fontWeight = FontWeight.w600;
        break;
      case TerminalLineType.output:
        textColor = const Color(0xFF1E293B); // Slate-800
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SelectableText(
        line.text,
        style: TextStyle(
          fontSize: 12,
          height: 1.45,
          fontFamily: 'monospace',
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Terminal Window Title Header (Light Gray / Off-White)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.terminal_rounded,
                    size: 13,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'FS-SHELL // Sandboxed Incident Terminal',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                      fontFamily: 'monospace',
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Clear Output',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                  onPressed: onClear,
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 6, color: Color(0xFF16A34A)),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF15803D),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Output Stream (Pure White Background)
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(12),
                itemCount: lines.length,
                itemBuilder: (context, i) => _buildLine(lines[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WHITE THEME COMMAND INPUT
// ─────────────────────────────────────────────────────────────────────────────

class _WhiteCommandInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  const _WhiteCommandInput({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'root@forenshield:~# ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w800,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A), // Dark text on white
              ),
              cursorColor: const Color(0xFF2563EB),
              decoration: const InputDecoration(
                hintText: 'Type command (e.g. netstat, pkill, iptables)...',
                hintStyle: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11.5,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (_) => onSubmit(),
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\n'))],
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 4),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSubmit,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WHITE THEME OBJECTIVES & HELPER PANEL
// ─────────────────────────────────────────────────────────────────────────────

class _WhiteObjectivesPanel extends StatelessWidget {
  final List<SimulationObjective> objectives;
  final void Function(String cmd) onQuickCommand;

  const _WhiteObjectivesPanel({
    required this.objectives,
    required this.onQuickCommand,
  });

  @override
  Widget build(BuildContext context) {
    final quickCmds = objectives
        .where((o) => !o.isCompleted && o.targetCommandKeyword.isNotEmpty)
        .map((o) => o.targetCommandKeyword)
        .take(4)
        .toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 4, AppSpacing.md, AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              const Icon(
                Icons.assignment_turned_in_outlined,
                size: 17,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 6),
              const Text(
                'Objectives',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Outfit',
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Text(
                'Remediation steps',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(color: Color(0xFFF1F5F9), height: 12),

          // Scrollable list of objectives
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ...objectives.map((obj) => _WhiteObjectiveItem(objective: obj)),
                if (quickCmds.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'Quick Command Helper (Tap to Run)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: quickCmds
                        .map((cmd) => _WhiteQuickChip(
                              label: cmd,
                              onTap: () => onQuickCommand(cmd),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteObjectiveItem extends StatelessWidget {
  final SimulationObjective objective;
  const _WhiteObjectiveItem({required this.objective});

  @override
  Widget build(BuildContext context) {
    final done = objective.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: done ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(
          color: done ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              size: 16,
              color: done ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  objective.title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: done ? const Color(0xFF15803D) : const Color(0xFF0F172A),
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  objective.description,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    color: done ? const Color(0xFF166534) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteQuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _WhiteQuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.terminal_rounded, size: 11, color: Color(0xFF2563EB)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
