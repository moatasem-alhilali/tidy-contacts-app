part of 'shimmer.dart';

class ShimmerText extends StatelessWidget {
  const ShimmerText({
    this.width,
    super.key,
    this.height,
  });

  const ShimmerText.light({super.key, this.height = 10, this.width});

  const ShimmerText.medium({super.key, this.height = 15, this.width});

  const ShimmerText.bold({super.key, this.height = 20, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Container(
        height: height,
        width: width ?? double.infinity,
        color: context.colors.primary,
      ),
    );
  }
}
