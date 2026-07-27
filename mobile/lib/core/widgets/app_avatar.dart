import 'package:flutter/material.dart';
import '../theme/foren_theme.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 20.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? foren.surfaceRaised1,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials ?? '?',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
    );
  }
}
