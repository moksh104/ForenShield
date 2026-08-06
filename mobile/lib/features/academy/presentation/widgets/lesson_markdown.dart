import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Renders markdown content with styled code blocks and images.
/// Presentation-only. No logic.
class LessonMarkdown extends StatelessWidget {
  final String markdown;
  final MarkdownStyleSheet? styleSheet;

  const LessonMarkdown({Key? key, required this.markdown, this.styleSheet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: MarkdownBody(
        data: markdown,
        selectable: true,
        styleSheet: styleSheet ?? MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          codeblockDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // image builder uses standard Image.network
        imageBuilder: (uri, title, alt) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Image.network(uri.toString())),
        builders: {
          'code': CodeElementBuilder()
        },
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return SelectableText(text.text, style: const TextStyle(fontFamily: 'monospace'));
  }
}
