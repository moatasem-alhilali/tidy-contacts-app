part of 'text.dart';

class AutoSizeTextWidget extends StatelessWidget {
  const AutoSizeTextWidget(
    this.text, {
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.minFontSize,
    this.maxFontSize,
    super.key,
  });

  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? minFontSize;
  final double? maxFontSize;

  @override
  Widget build(BuildContext context) {
    if (text?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    // Default text rendering if no special character is found
    return AutoSizeText(
      text!,
      style:
          style ??
          context.textStyles.labelMedium.copyWith(
            color: context.colors.onPrimary,
          ),
      overflow: overflow ?? (maxLines == 1 ? TextOverflow.ellipsis : null),
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: minFontSize ?? 12,
      maxFontSize: maxFontSize ?? 24,
      
    );
  }
}
