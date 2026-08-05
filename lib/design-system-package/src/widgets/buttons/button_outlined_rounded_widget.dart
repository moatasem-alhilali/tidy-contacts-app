part of 'buttons.dart';

class ButtonOutlinedRoundedWidget extends StatelessWidget {
  const ButtonOutlinedRoundedWidget({
    this.color,
    this.onPressed,
    this.text,
    this.style,
    this.disable,
    this.borderRadius,
    this.side,
    this.height,
    super.key,
  });

  final Color? color;
  final String? text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? side;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: true == disable ? 0.2 : 1,
      duration: const Duration(milliseconds: 500),
      child: ButtonBaseWidget(
        disable: disable,
        height: height ?? 36,
        shape: RoundedRectangleBorder(
          side: side ?? BorderSide(color: context.colors.onPrimaryContainer),
          borderRadius: borderRadius ?? BorderRadius.all(context.corners.rs),
        ),
        color: color ?? Colors.transparent,
        onPressed: onPressed,
        child: TextWidget(
          text,
          style:
              style ??
              context.textStyles.labelMedium.copyWith(
                color: context.colors.onPrimaryContainer,
              ),
        ),
      ),
    );
  }
}
