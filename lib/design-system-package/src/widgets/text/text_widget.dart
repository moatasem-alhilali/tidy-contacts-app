part of 'text.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
    this.text, {
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.textScaler,
    super.key,
  });

  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) {
    if (text?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    // Default text rendering if no special character is found
    return Text(
      text!,
      style:
          style ??
          context.textStyles.labelMedium.copyWith(
            color: context.colors.onPrimary,
          ),
      overflow: overflow ?? (maxLines == 1 ? TextOverflow.ellipsis : null),
      textAlign: textAlign,
      maxLines: maxLines,
      textScaler: textScaler ?? TextScaler.noScaling,
    );
  }
}
