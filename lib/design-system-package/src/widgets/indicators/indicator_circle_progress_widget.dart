part of 'indicators.dart';

class IndicatorCircleProgressWidget extends StatelessWidget {
  const IndicatorCircleProgressWidget({
    this.value,
    this.indicatorColor,
    this.indicatorBackgroundColor,
    this.size,
    this.label,
    this.icon,
    this.style,
    super.key,
  });

  final double? value;
  final Color? indicatorColor;
  final Color? indicatorBackgroundColor;
  final double? size;
  final String? label;
  final Widget? icon;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 90,
      width: size ?? 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: size ?? 90,
            width: size ?? 90,
            child: CircularProgressIndicator(
              value: value,
              backgroundColor: indicatorBackgroundColor ??
                  context.colors.onSecondaryContainer,
              color: indicatorColor ?? context.colors.primaryFixed,
              strokeWidth: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon ?? const SizedBox.shrink(),
                TextWidget(
                  label,
                  style:style?? context.textStyles.labelMedium
                      ?.copyWith(color: context.colors.onSecondaryContainer),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
