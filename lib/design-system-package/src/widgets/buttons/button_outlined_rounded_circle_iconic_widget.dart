part of 'buttons.dart';

class ButtonOutlinedRoundedCircleIconicWidget extends StatelessWidget {
  const ButtonOutlinedRoundedCircleIconicWidget({
    required this.icon,
    this.color,
    this.onPressed,
    this.text,
    this.style,
    this.disable,
    this.width,
    this.borderColor,
    this.textColor,
    super.key,
  });

  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final String? text;
  final String icon;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool? disable;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: true == disable ? 0.2 : 1,
      duration: const Duration(milliseconds: 500),
      child: ButtonBaseWidget(
        disable: disable,
        height: 24,
        minWidth: width,
        padding: EdgeInsets.symmetric(
          horizontal: context.insets.xl,
          vertical: context.insets.sm,
        ),
        shape: RoundedRectangleBorder(
          side:
          BorderSide(color: borderColor ?? context.colors.primaryContainer),
          borderRadius: BorderRadius.all(context.corners.rc360),
        ),
        color: color ?? Colors.transparent,
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text,
              style: style ??
                  context.textStyles.labelMedium?.copyWith(
                      color: textColor ?? context.colors.primaryContainer),
            ),
            SizedBox(width: context.insets.sm),
            SvgPicture.asset(
              icon,
              height: 10,
              width: 10,
              color: borderColor ?? context.colors.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
