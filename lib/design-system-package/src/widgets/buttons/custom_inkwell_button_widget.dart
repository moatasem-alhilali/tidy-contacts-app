part of 'buttons.dart';

class CustomInkWellButtonWidget extends StatelessWidget {
  const CustomInkWellButtonWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.color,
    this.borderRadius,
    this.padding,
    this.highlightElevation,
  });
  final void Function()? onTap;
  final Widget child;
  final Color? color;
  final Radius? borderRadius;
  final EdgeInsets? padding;
  final double? highlightElevation;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      elevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      color: color,
      // height: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(borderRadius ?? context.corners.rb),
      ),
      padding: EdgeInsets.symmetric(
        vertical: padding?.vertical ?? 0,
        horizontal: padding?.horizontal ?? 0,
      ),
      child: child,
    );
  }
}
