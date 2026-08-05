part of 'buttons.dart';

class ButtonCopyWidget extends StatelessWidget {
  const ButtonCopyWidget({
    required this.text,
    this.style,
    this.onPressed,
    super.key,
  });

  final String? text;
  final TextStyle? style;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonBaseWidget(
      onPressed: onPressed,
      color: context.colors.tertiaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(context.corners.rm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(
            text,
            style:
                style ??
                context.textStyles.labelMedium.copyWith(
                  color: context.colors.onTertiaryContainer,
                ),
          ),
          SizedBox(width: context.insets.md),
          // Assets.icons.copy.svg(color: context.colors.onTertiaryContainer),
        ],
      ),
    );
  }
}
