part of 'app_bar.dart';

class StepperIconicWidget extends StatelessWidget {
  const StepperIconicWidget({
    required this.items,
    required this.index,
    required this.icon,
    super.key,
  });

  final List<String> items;
  final int index;
  final String icon;

  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    return Row(
      children: [
        for (var i = 0; i < items.length; ++i) ...[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (i != 0)
                      _buildLine(context, index >= i)
                    else
                      SizedBox(
                        width: (_calculateTextWidth(context, items[i]) -
                            iconSize) *
                            0.5,
                      ),
                    //   const Expanded(child: SizedBox()),
                    ImageSvgAsset(
                      icon,
                      width: iconSize,
                      height: iconSize,
                      color: index >= i
                          ? context.colors.primaryFixed
                          : context.colors.onSecondary,
                    ),
                    if (i != items.length - 1)
                      _buildLine(context, index > i)
                    else
                      SizedBox(
                        width: (_calculateTextWidth(context, items[i]) -
                            iconSize) *
                            0.5,
                      ),
                  ],
                ),
                SizedBox(height: context.insets.sm),
                Align(
                  alignment: i == 0
                      ? AlignmentDirectional.centerStart
                      : i == items.length - 1
                      ? AlignmentDirectional.centerEnd
                      : Alignment.center,
                  child: TextWidget(
                    items[i],
                    style: context.textStyles.labelMedium?.copyWith(
                      color: index >= i
                          ? context.colors.primaryFixed
                          : context.colors.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  double _calculateTextWidth(BuildContext context, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: context.textStyles.labelMedium?.copyWith(
          color: context.colors.onSecondary,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout();
    return textPainter.size.width;
  }

  Widget _buildLine(BuildContext context, bool isSelected) =>
      Expanded(
        child: Container(
          height: 1,
          color: isSelected ? context.colors.primaryFixed : context.colors
              .onSecondary,
        ),
      );
}
