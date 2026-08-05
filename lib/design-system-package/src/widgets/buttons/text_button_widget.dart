part of 'buttons.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    required this.text,
    this.style,
    this.onPressed,
    super.key,
  });

  final String? text;
  final TextStyle? style;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: TextWidget(
        text,
        style: style ??
            context.textStyles.labelMedium?.copyWith(
              color: context.colors.onPrimaryContainer,
            ),
      ),
    );
  }
}
