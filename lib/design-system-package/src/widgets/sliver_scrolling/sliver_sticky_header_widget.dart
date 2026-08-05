part of 'sliver_scrolling.dart';

class SliverStickyHeaderWidget extends StatelessWidget {
  const SliverStickyHeaderWidget({
    required this.title,
    required this.sliver,
    this.alignment,
    this.topPadding,
    super.key,
  });

  final String title;
  final Widget sliver;
  final AlignmentGeometry? alignment;
  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Container(
        alignment: alignment ?? AlignmentDirectional.center,
        padding: EdgeInsets.symmetric(
          horizontal: context.insets.mn,
        ).copyWith(
          top: topPadding ?? context.spaces.sm,
          bottom: context.spaces.sm,
        ),
        child: TextWidget(
          title,
          style: context.textStyles.labelLarge
              .copyWith(color: context.colors.onSecondary),
          textAlign: TextAlign.center,
        ),
      ),
      sliver: sliver,
    );
  }
}
