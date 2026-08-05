part of 'buttons.dart';

class ButtonPrimaryWidget extends StatefulWidget {
  const ButtonPrimaryWidget({
    this.color,
    this.onPressed,
    this.text,
    this.textColor,
    this.style,
    this.disable = false,
    this.isLoading,
    this.child,
    this.height,
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

  @override
  State<ButtonPrimaryWidget> createState() => _ButtonPrimaryWidgetState();
}

class _ButtonPrimaryWidgetState extends State<ButtonPrimaryWidget> {
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
        minWidth: double.infinity,
        height: widget.height ?? 48,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(context.corners.rb),
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
            return widget.child ??
                TextWidget(
                  widget.text,
                  style:
                      widget.style ??
                      context.textStyles.headlineSmall.copyWith(
                        color:
                            widget.textColor ??
                            (widget.disable
                                ? context.colors.onInactive
                                : context.colors.primaryContainer),
                      ),
                  textAlign: TextAlign.center,
                );
          },
        ),
      ),
    );
  }
}
