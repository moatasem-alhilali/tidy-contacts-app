part of 'cards.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.child,
    this.padding,
    this.margin,
    this.borderSide,
    this.color,
    this.borderRadius,
    this.width,
    this.height,
    super.key,
  });
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxBorder? borderSide;
  final Color? color;
  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: borderSide != null
            ? Border.all(
                color:  context.colors.primaryContainer,
                width: 1.h,
              )
            : null,

        color: color ?? context.colors.primaryContainer,
        borderRadius: borderRadius ?? BorderRadius.all(context.corners.rb),
        // boxShadow: [
        //   BoxShadow(
        //     color: context.colors.shadow.withOpacity(0.1),
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      padding: padding ?? EdgeInsets.all(context.spaces.md),
      margin: margin,
      child: child,
    );
  }
}
