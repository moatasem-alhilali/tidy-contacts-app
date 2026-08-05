part of 'buttons.dart';

class ButtonRoundedWidget extends StatelessWidget {
  const ButtonRoundedWidget({
    this.color,
    this.onPressed,
    this.text,
    this.style,
    this.disable,
    this.height,
    this.padding,
    this.borderRadius,
    this.child,
    super.key,
  });

  final Color? color;
  final String? text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: true == disable ? 0.2 : 1,
      duration: const Duration(milliseconds: 500),
      child: ButtonBaseWidget(
        disable: disable,
        height: height ?? 40,
        padding: padding ?? EdgeInsets.all(context.insets.xl),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.all(context.corners.rc),
        ),
        color: color ?? context.colors.tertiaryContainer,
        onPressed: onPressed,
        child: child ?? TextWidget(
          text,
          style: style ??
              context.textStyles.titleLarge
                  ?.copyWith(color: context.colors.onTertiary),
        ),
      ),
    );
  }
}
