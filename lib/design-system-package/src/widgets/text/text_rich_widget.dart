part of 'text.dart';

class TextRichWidget extends StatelessWidget {
  const TextRichWidget({
    this.children,
    this.textAlign,
    this.textScaler,
    this.style,
    this.maxLines,
    this.textDirection,
    super.key,
  });

  final List<InlineSpan>? children;
  final TextAlign? textAlign;
  final TextScaler? textScaler;
  final TextStyle? style;
  final int? maxLines;
  final TextDirection? textDirection;
  @override
  Widget build(BuildContext context) {
    if (children == null || children!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text.rich(
      TextSpan(children: children),
      style: style,
      textAlign: textAlign,
      textScaler: textScaler ?? TextScaler.noScaling,
      maxLines: maxLines,
      textDirection: textDirection,
    );
  }
}
