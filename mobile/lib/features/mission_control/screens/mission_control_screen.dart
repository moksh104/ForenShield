import 'package:flutter/material.dart';

class MissionControlScreen extends StatelessWidget {
  const MissionControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Control'),
      ),
      body: const Center(
        child: Text('MissionControlScreen'),
      ),
    );
  }
}
