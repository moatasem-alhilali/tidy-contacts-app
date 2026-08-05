part of 'buttons.dart';

class ButtonOutlinedWidget extends StatelessWidget {
  const ButtonOutlinedWidget({
    this.color,
    this.borderColor,
    this.onPressed,
    this.text,
    this.style,
    this.disable,
    this.side,
    super.key,
  });

  final Color? color;
  final Color? borderColor;
  final String? text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: true == disable ? 0.2 : 1,
      duration: const Duration(milliseconds: 500),
      child: ButtonBaseWidget(
        disable: disable,
        minWidth: double.infinity,
        height: 48,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(context.corners.rb),
          side:
              side ??
              BorderSide(
                color: borderColor ?? context.colors.brandColor,
                width: 1.5,
              ),
        ),
        color: color ?? Colors.transparent,
        onPressed: onPressed,
        child: TextWidget(
          text,
          style:
              style ??
              context.textStyles.headlineSmall.copyWith(
                color: context.colors.brandColor,
              ),
        ),
      ),
    );
  }
}
