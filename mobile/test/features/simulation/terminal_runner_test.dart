import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/features/simulation/presentation/pages/terminal_runner_screen.dart';

void main() {
  group('TerminalRunnerNotifier Tests', () {
    test('initializes with boot lines and objectives', () {
      final notifier = TerminalRunnerNotifier('ransomware-containment');
      final state = notifier.state;

      expect(state.scenario, isNotNull);
      expect(state.scenario!.id, 'ransomware-containment');
      expect(state.objectives.length, 3);
      expect(state.completedObjectives, 0);
      expect(state.isCompleted, false);
      expect(state.lines.isNotEmpty, true);

      notifier.dispose();
    });

    test('completes objectives sequentially with valid commands', () {
      final notifier = TerminalRunnerNotifier('ransomware-containment');

      // 1. Run netstat
      notifier.submitCommand('netstat -an');
      expect(notifier.state.completedObjectives, 1);
      expect(notifier.state.objectives[0].isCompleted, true);
      expect(notifier.state.isCompleted, false);

      // 2. Run pkill
      notifier.submitCommand('pkill -9 ransomware_agent');
      expect(notifier.state.completedObjectives, 2);
      expect(notifier.state.objectives[1].isCompleted, true);
      expect(notifier.state.isCompleted, false);

      // 3. Run iptables
      notifier.submitCommand('iptables -A INPUT -p tcp --dport 4444 -j DROP');
      expect(notifier.state.completedObjectives, 3);
      expect(notifier.state.objectives[2].isCompleted, true);
      expect(notifier.state.isCompleted, true);

      notifier.dispose();
    });

    test('clearTerminal clears lines while keeping objectives intact', () {
      final notifier = TerminalRunnerNotifier('ransomware-containment');
      notifier.submitCommand('netstat');
      expect(notifier.state.completedObjectives, 1);

      notifier.clearTerminal();
      expect(notifier.state.completedObjectives, 1); // progress preserved
      expect(notifier.state.lines.length, notifier.state.scenario!.initialTerminalHistory.length);

      notifier.dispose();
    });

    test('restart resets state and objectives', () {
      final notifier = TerminalRunnerNotifier('ransomware-containment');
      notifier.submitCommand('netstat');
      expect(notifier.state.completedObjectives, 1);

      notifier.restart();
      expect(notifier.state.completedObjectives, 0);
      expect(notifier.state.isCompleted, false);

      notifier.dispose();
    });
  });

  group('TerminalRunnerScreen Widget Tests', () {
    testWidgets('renders white theme terminal screen and input', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TerminalRunnerScreen(scenarioId: 'ransomware-containment'),
          ),
        ),
      );

      // Allow animations and timers to render
      await tester.pumpAndSettle();

      // Verify title and terminal presence
      expect(find.text('Ransomware Outbreak Containment'), findsOneWidget);
      expect(find.text('FS-SHELL // Sandboxed Incident Terminal'), findsOneWidget);
      expect(find.text('Objectives'), findsOneWidget);
      expect(find.text('root@forenshield:~# '), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
    });
  });
}
