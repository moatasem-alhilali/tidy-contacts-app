part of 'buttons.dart';

class ButtonOutlinedRoundedIconicWithTitleWidget extends StatelessWidget {
  const ButtonOutlinedRoundedIconicWithTitleWidget({
    required this.icon,
    required this.title,
    this.color,
    this.onPressed,
    this.text,
    this.style,
    this.disable,
    this.width,
    this.borderColor,
    this.textColor,
    this.iconFromPackage = false,
    super.key,
  });

  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final String title;
  final String? text;
  final String icon;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final double? width;
  final bool iconFromPackage;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          title,
          style: context.textStyles.titleMedium.copyWith(
            color: context.colors.onPrimaryContainer,
          ),
        ),
        SizedBox(height: context.insets.xl),
        AnimatedOpacity(
          opacity: true == disable ? 0.2 : 1,
          duration: const Duration(milliseconds: 500),
          child: ButtonBaseWidget(
            disable: disable,
            minWidth: double.infinity,
            height: 48,
            padding: EdgeInsets.symmetric(
              horizontal: context.insets.xl,
              vertical: context.insets.sm,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor ?? context.colors.onSecondaryContainer,
              ),
              borderRadius: BorderRadius.all(context.corners.rc360),
            ),
            color: color ?? Colors.transparent,
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                context.insets.md.horizontalSpace,
                Expanded(
                  child: TextWidget(
                    text,
                    style:
                        style ??
                        context.textStyles.titleMedium.copyWith(
                          color: textColor ?? context.colors.onPrimaryContainer,
                        ),
                  ),
                ),
                SizedBox(width: context.insets.sm),
                ImageSvgAsset(
                  icon,
                  height: 12,
                  width: 12,
                  color: borderColor ?? context.colors.onSecondary,
                  fromPackage: iconFromPackage,
                ),
                context.insets.md.horizontalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
