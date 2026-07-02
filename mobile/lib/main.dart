import 'package:flutter/material.dart';

void main() {
  runApp(const ForenShieldApp());
}

class ForenShieldApp extends StatelessWidget {
  const ForenShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('ForenShield'),
        ),
      ),
    );
  }
}
