import '../../domain/entities/simulation_scenario.dart';

class SimulationMockData {
  SimulationMockData._();

  static final List<SimulationScenario> scenarios = [
    const SimulationScenario(
      id: 'ransomware-containment',
      title: 'Ransomware Outbreak Containment',
      description:
          'Active ransomware detected on workstation FS-HOST-09. Identify the Command & Control server IP, terminate the malware process, and apply an emergency firewall block rule.',
      category: ScenarioCategory.network,
      difficulty: ScenarioDifficulty.critical,
      estimatedMinutes: 15,
      xpReward: 350,
      initialTerminalHistory: [
        'ForenShield Virtual Security Engine v1.0 [Sandboxed]',
        'Connected to isolated environment: FS-HOST-09 (192.168.1.45)',
        'WARNING: Suspicious outbound network activity detected.',
        'Type "help" for available diagnostic commands.',
      ],
      objectives: [
        SimulationObjective(
          id: 'obj_1',
          title: 'Identify Malicious C2 IP',
          description:
              'Run "netstat" or "netstat -an" to list active network connections and locate suspicious port 4444.',
          targetCommandKeyword: 'netstat',
          hint: 'Try entering "netstat" to view active sockets.',
        ),
        SimulationObjective(
          id: 'obj_2',
          title: 'Terminate Ransomware Process',
          description:
              'Execute "pkill" or "kill" to terminate the active malware executable (PID 4092 / ransomware_agent).',
          targetCommandKeyword: 'pkill',
          hint: 'Try entering "pkill ransomware" or "kill 4092".',
        ),
        SimulationObjective(
          id: 'obj_3',
          title: 'Apply Emergency Firewall Block',
          description:
              'Execute "iptables" to block incoming and outgoing traffic on port 4444.',
          targetCommandKeyword: 'iptables',
          hint: 'Try entering "iptables -A INPUT -p tcp --dport 4444 -j DROP".',
        ),
      ],
    ),
    const SimulationScenario(
      id: 'sqli-remediation',
      title: 'SQL Injection Attack Remediation',
      description:
          'Malicious SQL payload detected in Web Application logs. Inspect Nginx access logs and deploy input sanitization rules.',
      category: ScenarioCategory.webSec,
      difficulty: ScenarioDifficulty.medium,
      estimatedMinutes: 10,
      xpReward: 200,
      initialTerminalHistory: [
        'ForenShield Web Sandbox Engine v1.0',
        'Connected to web server: WEB-PROD-01',
        'Type "help" to inspect available web security commands.',
      ],
      objectives: [
        SimulationObjective(
          id: 'sqli_1',
          title: 'Inspect Nginx Access Log',
          description: 'Run "cat" to view /var/log/nginx/access.log.',
          targetCommandKeyword: 'cat',
          hint: 'Try entering "cat /var/log/nginx/access.log".',
        ),
        SimulationObjective(
          id: 'sqli_2',
          title: 'Apply WAF Sanitization Rule',
          description: 'Execute "waf-apply" to load SQLi protection rule.',
          targetCommandKeyword: 'waf-apply',
          hint: 'Try entering "waf-apply --rule sqli-block".',
        ),
      ],
    ),
    const SimulationScenario(
      id: 'ssh-auth-analysis',
      title: 'Unauthorized SSH Access Analysis',
      description:
          'Multiple brute-force SSH login attempts detected on internal bastion host. Filter auth logs and revoke compromised keys.',
      category: ScenarioCategory.dfir,
      difficulty: ScenarioDifficulty.hard,
      estimatedMinutes: 20,
      xpReward: 300,
      initialTerminalHistory: [
        'ForenShield Incident Lab Engine v1.0',
        'Connected to bastion: BASTION-01',
        'Type "help" for forensic analysis tools.',
      ],
      objectives: [
        SimulationObjective(
          id: 'ssh_1',
          title: 'Search Auth Logs for Brute Force',
          description: 'Run "grep" to check failed passwords in auth.log.',
          targetCommandKeyword: 'grep',
          hint: 'Try entering "grep Failed /var/log/auth.log".',
        ),
        SimulationObjective(
          id: 'ssh_2',
          title: 'Revoke Compromised Key',
          description: 'Execute "revoke-key" for user admin.',
          targetCommandKeyword: 'revoke-key',
          hint: 'Try entering "revoke-key --user admin".',
        ),
      ],
    ),
  ];
}
