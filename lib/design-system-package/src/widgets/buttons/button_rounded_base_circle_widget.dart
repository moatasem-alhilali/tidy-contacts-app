part of 'buttons.dart';

class ButtonRoundedBaseCircleWidget extends StatelessWidget {
  const ButtonRoundedBaseCircleWidget({
    this.color,
    this.onPressed,
    this.disable,
    this.width,
    this.height,
    this.child,
    this.padding,
    super.key,
  });

  final Color? color;
  final Widget? child;
  final VoidCallback? onPressed;
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
        padding: padding ?? EdgeInsets.symmetric(
          horizontal: context.insets.xl,
          vertical: context.insets.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(context.corners.rc360),
        ),
        color: color ?? context.colors.tertiaryContainer,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
