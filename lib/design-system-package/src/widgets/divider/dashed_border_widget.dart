part of 'divider.dart';

class DashedBorderWidget extends StatelessWidget {
  const DashedBorderWidget({
    required this.child,
    required this.color,
    super.key,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      // borderType: BorderType.RRect,
      // radius: context.corners.rc,
      // color: color ?? context.colors.onSecondary,
      // dashPattern: const [5, 6],
      // strokeWidth: 2,
      child: child,
    );
  }
}
