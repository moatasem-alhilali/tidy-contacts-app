part of 'buttons.dart';

class ButtonRoundedCircleWidget extends StatelessWidget {
  const ButtonRoundedCircleWidget({
    this.color,
    this.onPressed,
    this.text,
    this.style,
    this.disable,
    this.width,
    this.height,
    this.padding,
    this.child,
    super.key,
  });

  final Color? color;
  final String? text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ButtonRoundedBaseCircleWidget(
      color: color,
      width: width,
      height: height,
      padding: padding,
      onPressed: onPressed,
      child: child ?? TextWidget(
        text,
        style: style ??
            context.textStyles.labelMedium
                ?.copyWith(color: context.colors.onTertiaryContainer),
      ),
    );
  }
}
