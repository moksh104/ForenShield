import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingModules extends StatelessWidget {
  const LoadingModules({super.key});

  @override
  Widget build(BuildContext context) {
    const modules = [
      'Mission Control',
      'Cyber Academy',
      'Simulation Lab',
      'Investigation Lab',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        modules.length,
        (index) => _ModuleItem(
          name: modules[index],
          delay: Duration(milliseconds: 1800 + (index * 250)),
        ),
      ),
    );
  }
}

class _ModuleItem extends StatelessWidget {
  final String name;
  final Duration delay;

  const _ModuleItem({
    required this.name,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkmark icon
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0F766E),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.check,
              size: 10,
              color: Color(0xFF0F766E),
            ),
          )
              .animate(delay: delay)
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.5, 0.5)),
          
          const SizedBox(width: 12),
          
          // Module name
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
              fontFamily: 'Geist',
              letterSpacing: 0.3,
            ),
          )
              .animate(delay: delay)
              .fadeIn(duration: 300.ms)
              .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
