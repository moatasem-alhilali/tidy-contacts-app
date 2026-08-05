part of 'sliver_scrolling.dart';

class SliverHeaderWidget extends StatelessWidget {
  const SliverHeaderWidget({
    required this.child,
    this.expandedHeight,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.pinned = false,
    super.key,
  });

  final double? expandedHeight;
  final Widget? child;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final bool pinned;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      pinned: pinned,
      delegate: SliverHeaderDelegate(
        expandedHeight: expandedHeight ?? 45,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
