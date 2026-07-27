/// Tracks the lifecycle state of a live cybersecurity simulation.
enum SimulationStatus {
  pending('Pending'),
  booting('Booting Env...'),
  active('Active'),
  paused('Paused'),
  terminated('Terminated'),
  completed('Completed');

  final String label;
  const SimulationStatus(this.label);

  bool get isRunning =>
      this == SimulationStatus.active || this == SimulationStatus.booting;
}
