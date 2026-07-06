import 'package:flutter/material.dart';

class InvestigationLabScreen extends StatelessWidget {
  const InvestigationLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation Lab'),
      ),
      body: const Center(
        child: Text('InvestigationLabScreen'),
      ),
    );
  }
}
