import 'package:flutter/material.dart';

class BottomSpacing extends StatelessWidget {
  final double height;
  const BottomSpacing({Key? key, this.height = 48}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
