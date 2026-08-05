part of 'buttons.dart';

class ButtonSecondaryWidget extends StatefulWidget {
  const ButtonSecondaryWidget({
    this.color,
    this.onPressed,
    this.text,
    this.textColor,
    this.style,
    this.disable = false,
    this.isLoading,
    this.child,
    this.height,
    this.gradient,
    this.borderColor,
    super.key,
  });

  final Color? color;
  final Color? textColor;
  final String? text;
  final Widget? child;
  final dynamic Function()? onPressed;
  final TextStyle? style;
  final bool disable;
  final bool? isLoading;
  final double? height;
  final Gradient? gradient;
  final Color? borderColor;

  @override
  State<ButtonSecondaryWidget> createState() => _ButtonSecondaryWidgetState();
}

class _ButtonSecondaryWidgetState extends State<ButtonSecondaryWidget> {
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
    return ButtonBaseWidget(
      disable: true == widget.disable || isLoading,
      minWidth: double.infinity,
      height: widget.height ?? 48,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(context.corners.rc360),
        side: BorderSide(color: widget.borderColor ?? Colors.transparent),
      ),
      color: widget.color ?? context.colors.primaryContainer,
      disabledColor: context.colors.inactive,
      onPressed:
          widget.onPressed != null && !widget.disable ? _handlePress : null,
      child: Builder(
        builder: (context) {
          if (isLoading) {
            return CupertinoActivityIndicator(
              color: context.colors.onPrimaryContainer,
              radius: 12,
            );
          }
          return widget.child ??
              TextWidget(
                widget.text,
                style: widget.style ??
                    context.textStyles.headlineSmall.copyWith(
                      color: widget.textColor ??
                          (widget.disable
                              ? context.colors.onInactive
                              : context.colors.onPrimaryContainer),
                    ),
                textAlign: TextAlign.center,
              );
        },
      ),
    );
  }
}
