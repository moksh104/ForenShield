import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// A responsive grid of course categories.
///
/// - Accepts a list of plain [Category] models and an [onTap] callback.
/// - Presentation-only. Const constructor.
class CourseCategoryGrid extends StatelessWidget {
  /// Categories to show
  final List<Category> categories;

  /// Called when a category is tapped
  final void Function(Category)? onTap;

  const CourseCategoryGrid({Key? key, this.categories = const <Category>[], this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: LayoutBuilder(builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 160).clamp(2, 6).toInt();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 86,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Material(
              color: cs.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onTap?.call(cat),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: cs.primaryContainer, child: Icon(Icons.folder, color: cs.onPrimaryContainer)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(cat.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
