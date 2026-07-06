import 'package:flutter/material.dart';

class SimulationLabScreen extends StatelessWidget {
  const SimulationLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Lab'),
      ),
      body: const Center(
        child: Text('SimulationLabScreen'),
      ),
    );
  }
}
