part of 'shimmer.dart';

class ShimmerSkeletonizerWidget extends StatelessWidget {
  const ShimmerSkeletonizerWidget({
    required this.child,
    this.isLoading = true,
    this.ignorePointers = true,
    this.color,
    super.key,
  });

  final Widget child;
  final bool isLoading;
  final bool ignorePointers;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Skeletonizer(
        enabled: isLoading,
        ignorePointers: ignorePointers,
        containersColor:
            color ?? context.colors.onSecondary.withValues(alpha: 0.2),
        child: child,
      ),
    );
  }
}
