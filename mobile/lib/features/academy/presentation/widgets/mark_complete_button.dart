import 'package:flutter/material.dart';

/// Mark complete button used at the bottom of lesson player.
class MarkCompleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool completed;

  const MarkCompleteButton({Key? key, this.onPressed, this.completed = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
      child: Text(completed ? 'Completed' : 'Mark Complete'),
    );
  }
}
