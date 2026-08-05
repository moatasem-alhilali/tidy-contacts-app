part of 'buttons.dart';

class ButtonDashWidget extends StatelessWidget {
  const ButtonDashWidget({
    this.color,
    this.borderColor,
    this.onPressed,
    this.child,
    this.style,
    this.disable,
    this.side,
    super.key,
  });

  final Color? color;
  final Color? borderColor;
  final Widget? child;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      // borderType: BorderType.RRect,
      // radius: context.corners.rc,
      // color: context.colors.onSecondary,
      // dashPattern: const [3, 5],
      child: AnimatedOpacity(
        opacity: true == disable ? 0.2 : 1,
        duration: const Duration(milliseconds: 500),
        child: ButtonBaseWidget(
          disable: disable,
          minWidth: double.infinity,
          height: 48,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(context.corners.rc),
          ),
          color: color ?? context.colors.primary,
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
