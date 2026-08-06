import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/simulation_mock_data.dart';
import '../domain/entities/simulation_scenario.dart';
import '../domain/entities/terminal_line.dart';

class SimulationRunnerState {
  final SimulationScenario? scenario;
  final List<TerminalLine> terminalLines;
  final List<SimulationObjective> objectives;
  final int secondsElapsed;
  final bool isCompleted;

  const SimulationRunnerState({
    this.scenario,
    this.terminalLines = const [],
    this.objectives = const [],
    this.secondsElapsed = 0,
    this.isCompleted = false,
  });

  bool get allObjectivesCompleted =>
      objectives.isNotEmpty && objectives.every((o) => o.isCompleted);

  int get completedObjectivesCount =>
      objectives.where((o) => o.isCompleted).length;

  SimulationRunnerState copyWith({
    SimulationScenario? scenario,
    List<TerminalLine>? terminalLines,
    List<SimulationObjective>? objectives,
    int? secondsElapsed,
    bool? isCompleted,
  }) {
    return SimulationRunnerState(
      scenario: scenario ?? this.scenario,
      terminalLines: terminalLines ?? this.terminalLines,
      objectives: objectives ?? this.objectives,
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class SimulationRunnerNotifier extends StateNotifier<SimulationRunnerState> {
  Timer? _timer;

  SimulationRunnerNotifier() : super(const SimulationRunnerState());

  void initScenario(String scenarioId) {
    _timer?.cancel();

    final foundScenario = SimulationMockData.scenarios.firstWhere(
      (s) => s.id == scenarioId,
      orElse: () => SimulationMockData.scenarios.first,
    );

    final initialLines = foundScenario.initialTerminalHistory
        .map(
          (text) => TerminalLine(
            text: text,
            type: TerminalLineType.system,
            timestamp: DateTime.now(),
          ),
        )
        .toList();

    state = SimulationRunnerState(
      scenario: foundScenario,
      terminalLines: initialLines,
      objectives: foundScenario.objectives,
      secondsElapsed: 0,
      isCompleted: false,
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      state = state.copyWith(secondsElapsed: state.secondsElapsed + 1);
    });
  }

  void executeCommand(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return;

    final updatedLines = List<TerminalLine>.from(state.terminalLines);
    final now = DateTime.now();

    // Add user input line
    updatedLines.add(
      TerminalLine(
        text: 'root@forenshield-vm:~# $input',
        type: TerminalLineType.input,
        timestamp: now,
      ),
    );

    // Command parser & mock response generator
    final lower = input.toLowerCase();
    String responseText = '';
    TerminalLineType responseType = TerminalLineType.output;

    if (lower == 'help') {
      responseText = '''
Available Diagnostic & Remediation Commands:
  netstat -an                      List active network connections and ports
  pkill -f <name>                  Terminate target process by name
  kill <pid>                       Terminate process by PID
  iptables -A INPUT -p tcp ...     Configure firewall block rule
  cat <filepath>                   Inspect target system log file
  grep <keyword> <file>            Search pattern in log files
  clear                            Clear terminal screen console
''';
    } else if (lower == 'clear') {
      state = state.copyWith(terminalLines: []);
      return;
    } else if (lower.contains('netstat')) {
      responseText = '''
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 127.0.0.1:22            0.0.0.0:*               LISTEN
tcp        0      0 192.168.1.45:4444       198.51.100.42:8080      ESTABLISHED
tcp        0      0 192.168.1.45:80         0.0.0.0:*               LISTEN
[ALERT] Suspicious connection to 198.51.100.42 on port 4444 (PID 4092: ransomware_agent)
''';
      responseType = TerminalLineType.output;
    } else if (lower.contains('pkill') || lower.contains('kill')) {
      responseText = '''
[SUCCESS] Signal SIGKILL (9) sent to process 4092 [ransomware_agent].
Process terminated successfully. Memory lock released.
''';
      responseType = TerminalLineType.success;
    } else if (lower.contains('iptables')) {
      responseText = '''
[SUCCESS] Rule added to chain INPUT:
  target: DROP, prot: tcp, dport: 4444 from 0.0.0.0/0
Firewall rules updated cleanly. Port 4444 blocked.
''';
      responseType = TerminalLineType.success;
    } else if (lower.contains('cat')) {
      responseText = '''
[LOG INSPECT] /var/log/nginx/access.log:
192.168.1.100 - - [26/Jul/2026:14:02:11 +0000] "GET /api/user?id=1%27%20OR%201=1-- HTTP/1.1" 200 4520
''';
    } else if (lower.contains('grep')) {
      responseText = '''
[GREP MATCH] /var/log/auth.log:
Jul 26 13:58:02 BASTION-01 sshd[1284]: Failed password for root from 198.51.100.42 port 52210 ssh2
Jul 26 13:58:05 BASTION-01 sshd[1289]: Failed password for root from 198.51.100.42 port 52212 ssh2
''';
    } else {
      responseText =
          'bash: command not found: $input. Type "help" for valid lab commands.';
      responseType = TerminalLineType.error;
    }

    updatedLines.add(
      TerminalLine(text: responseText, type: responseType, timestamp: now),
    );

    // Check objective completion rules
    final updatedObjectives = state.objectives.map((obj) {
      if (!obj.isCompleted && lower.contains(obj.targetCommandKeyword)) {
        return obj.copyWith(isCompleted: true);
      }
      return obj;
    }).toList();

    final allDone = updatedObjectives.every((o) => o.isCompleted);

    state = state.copyWith(
      terminalLines: updatedLines,
      objectives: updatedObjectives,
      isCompleted: allDone,
    );
  }

  void completeLabManually() {
    state = state.copyWith(
      objectives: state.objectives
          .map((o) => o.copyWith(isCompleted: true))
          .toList(),
      isCompleted: true,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final simulationRunnerProvider =
    StateNotifierProvider.family<
      SimulationRunnerNotifier,
      SimulationRunnerState,
      String
    >((ref, scenarioId) {
      final notifier = SimulationRunnerNotifier();
      notifier.initScenario(scenarioId);
      return notifier;
    });
