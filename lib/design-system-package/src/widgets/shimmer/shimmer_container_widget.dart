part of 'shimmer.dart';

class ShimmerContainerWidget extends StatelessWidget {
  const ShimmerContainerWidget({
    required this.height,
    required this.width,
    this.borderRadius,
    super.key,
  });

  final double height;
  final double width;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
