part of 'buttons.dart';

class ButtonBaseWidget extends StatelessWidget {
  const ButtonBaseWidget({
    required this.shape,
    required this.color,
    required this.onPressed,
    required this.child,
    this.disabledColor,
    this.disable,
    this.padding,
    this.height,
    this.minWidth,
    super.key,
  });

  final ShapeBorder? shape;
  final Color? color;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final Widget? child;
  final double? minWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool? disable;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      shape: shape,
      color: color,
      disabledColor: disabledColor??color,
      height: height,
      padding: padding,
      minWidth: minWidth,
      onPressed: true == disable ? null : (){
        onPressed?.call();
        HapticFeedback.mediumImpact();
      },
      child: child,
    );
  }
}
