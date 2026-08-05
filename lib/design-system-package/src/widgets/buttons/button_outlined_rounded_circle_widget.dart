part of 'buttons.dart';

class ButtonOutlinedRoundedCircleWidget extends StatelessWidget {
  const ButtonOutlinedRoundedCircleWidget({
    this.color,
    this.onPressed,
    this.text,
    this.style,
    this.disable,
    this.width,
    this.height,
    this.borderColor,
    this.padding,
    super.key,
  });

  final Color? color;
  final Color? borderColor;
  final String? text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: true == disable ? 0.2 : 1,
      duration: const Duration(milliseconds: 500),
      child: ButtonBaseWidget(
        disable: disable,
        height: height ?? 40.h,
        minWidth: width,
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: context.insets.xl,
              vertical: context.insets.md,
            ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor ?? context.colors.onPrimaryContainer,
          ),
          borderRadius: BorderRadius.all(context.corners.rc360),
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
