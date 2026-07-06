import 'package:flutter/material.dart';

class CyberAcademyScreen extends StatelessWidget {
  const CyberAcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Academy'),
      ),
      body: const Center(
        child: Text('CyberAcademyScreen'),
      ),
    );
  }
}
