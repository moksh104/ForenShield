import 'package:flutter/material.dart';

/// Previous/Next navigation controls used in lesson player footer.
class NavControls extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const NavControls({Key? key, this.onPrevious, this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: OutlinedButton.icon(onPressed: onPrevious, icon: const Icon(Icons.arrow_back), label: const Text('Previous'))),
      const SizedBox(width: 12),
      Expanded(child: ElevatedButton.icon(onPressed: onNext, icon: const Icon(Icons.arrow_forward), label: const Text('Next'))),
    ]);
  }
}
