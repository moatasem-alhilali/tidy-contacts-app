part of 'indicators.dart';

//TODO: not Found in design system
class IndicatorPageWidget extends StatelessWidget {
  const IndicatorPageWidget({
    required this.length,
    required this.index,
    this.activeColor,
    this.inactiveColor,
    this.circleSize,
    this.circleActiveWidth,
    this.backgroundColor,
    super.key,
  });

  final int length;
  final int index;
  final double? circleSize;
  final double? circleActiveWidth;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.insets.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rc360),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < length; ++i)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: context.insets.sm),
              height: circleSize ?? 4,
              width: i == index ? (circleActiveWidth ?? 8) : circleSize ?? 4,
              decoration: BoxDecoration(
                color: i == index
                    ? activeColor ?? context.colors.onPrimary
                    : inactiveColor ?? context.colors.onSecondary,
                // shape:i == index? BoxShape.rectangle : BoxShape.circle,
                borderRadius: i == index
                    ? BorderRadius.all(context.corners.rc)
                    : BorderRadius.all(context.corners.rc360),
              ),
            ),
        ],
      ),
    );
  }
}
