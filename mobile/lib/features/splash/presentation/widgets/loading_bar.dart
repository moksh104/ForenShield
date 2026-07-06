import 'package:flutter/material.dart';

class LoadingBar extends StatefulWidget {
  final VoidCallback? onComplete;

  const LoadingBar({
    super.key,
    this.onComplete,
  });

  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start loading after initial animations
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _controller.forward().then((_) {
          if (mounted) {
            widget.onComplete?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Loading bar
            Container(
              width: 200,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFF1A202C),
                borderRadius: BorderRadius.circular(1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFC98A2E),
                        Color(0xFFE5A858),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC98A2E).withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Status text
            Text(
              _getStatusText(_progressAnimation.value),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
                fontFamily: 'Geist',
                letterSpacing: 0.5,
              ),
            ),
          ],
        );
      },
    );
  }

  String _getStatusText(double progress) {
    if (progress < 0.33) {
      return 'Initializing Secure Learning Environment...';
    } else if (progress < 0.75) {
      return 'Loading Cyber Modules...';
    } else if (progress < 1.0) {
      return 'System Ready';
    }
    return 'System Ready';
  }
}
