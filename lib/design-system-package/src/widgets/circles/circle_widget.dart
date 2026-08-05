part of 'circles.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    super.key,
    this.color,
    this.size = 8.0,
    this.border,
    this.child,
    this.padding,
  });

  final Color? color;
  final double size;
  final BoxBorder? border;
  final Widget? child;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
      padding: padding,
      child: child,
    );
  }
}
