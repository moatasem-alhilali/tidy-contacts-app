part of 'buttons.dart';

class ButtonCustomWidget extends StatefulWidget {
  const ButtonCustomWidget({
    this.color,
    this.onPressed,
    this.text,
    this.textColor,
    this.borderColor,
    this.style,
    this.disable = false,
    this.isLoading,
    this.child,
    this.prefix,
    this.suffix,
    this.height,
    this.width,
    super.key,
  });

  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final String? text;
  final Widget? child;
  final Widget? prefix;
  final Widget? suffix;
  final dynamic Function()? onPressed;
  final TextStyle? style;
  final bool disable;
  final bool? isLoading;
  final double? height;
  final double? width;

  @override
  State<ButtonCustomWidget> createState() => _ButtonCustomWidgetState();
}

class _ButtonCustomWidgetState extends State<ButtonCustomWidget> {
  late bool isLoading;

  @override
  void initState() {
    isLoading = widget.isLoading ?? false;
    super.initState();
  }

  Future<void> _handlePress() async {
    setState(() {
      isLoading = true;
    });
    await widget.onPressed!();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BorderGradientAnimationWidget(
      height: (widget.height ?? 48) + 7,
      child: ButtonBaseWidget(
        disable: true == widget.disable || isLoading,
        minWidth: widget.width ?? double.infinity,
        height: widget.height ?? 48,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(context.corners.rc360),
          side: BorderSide(
            color:
                widget.borderColor ??
                widget.color ??
                context.mode(
                  true == widget.disable
                      ? context.colors.inactive
                      : context.colors.onPrimaryContainer,
                  context.colors.onPrimaryContainer,
                ),
          ),
        ),
        color:
            widget.color ??
            context.mode(
              true == widget.disable
                  ? context.colors.inactive
                  : context.colors.onPrimaryContainer,
              context.colors.onPrimaryContainer,
            ),
        onPressed: widget.onPressed != null ? _handlePress : null,
        child: Builder(
          builder: (context) {
            if (isLoading) {
              return CupertinoActivityIndicator(
                color: context.colors.primary,
                radius: 12,
              );
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.prefix != null) ...[
                  widget.prefix!,
                  context.insets.sm.horizontalSpace,
                ],
                widget.child ??
                    TextWidget(
                      widget.text,
                      style:
                          widget.style ??
                          context.textStyles.labelMedium.copyWith(
                            color:
                                widget.textColor ??
                                (widget.disable
                                    ? context.colors.onInactive
                                    : context.colors.primaryContainer),
                          ),
                      textAlign: TextAlign.center,
                    ),
                if (widget.suffix != null) ...[
                  context.insets.sm.horizontalSpace,
                  widget.suffix!,
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
