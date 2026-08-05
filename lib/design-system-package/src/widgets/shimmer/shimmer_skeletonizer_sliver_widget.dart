part of 'shimmer.dart';

class ShimmerSkeletonizerSliverWidget extends StatelessWidget {
  const ShimmerSkeletonizerSliverWidget({
    required this.child,
    this.isLoading = true,
    super.key,
  });

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      enabled: isLoading,
      child: child,
    );
  }
}
