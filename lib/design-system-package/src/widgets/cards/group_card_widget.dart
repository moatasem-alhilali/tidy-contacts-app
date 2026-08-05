part of 'cards.dart';

class GroupCardWidget extends StatelessWidget {
  const GroupCardWidget({
    required this.children,
    this.padding,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.radius,
    this.itemsSpacing,
    this.mainAxisSize,
    this.color,
    super.key,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final Radius? radius;
  final double? itemsSpacing;
  final MainAxisSize? mainAxisSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding:
          padding ??
          EdgeInsets.symmetric(
            vertical: context.insets.mn,
            horizontal: context.insets.xl,
          ),
      decoration: BoxDecoration(
        color: color ?? context.colors.primaryContainer,
        borderRadius: BorderRadius.all(radius ?? context.corners.rc),
      ),
      child: Column(
        spacing: itemsSpacing ?? 0.0,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        children: children,
      ),
    );
  }
}
