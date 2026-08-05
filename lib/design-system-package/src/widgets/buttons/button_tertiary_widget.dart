part of 'buttons.dart';

class ButtonTertiaryWidget extends StatefulWidget {
  const ButtonTertiaryWidget({
    this.color,
    this.onPressed,
    this.text,
    this.textColor,
    this.style,
    this.disable,
    this.isLoading,
    this.child,
    this.height,
    this.gradient,
    super.key,
  });

  final Color? color;
  final Color? textColor;
  final String? text;
  final Widget? child;
  final dynamic Function()? onPressed;
  final TextStyle? style;
  final bool? disable;
  final bool? isLoading;
  final double? height;
  final Gradient? gradient;

  @override
  State<ButtonTertiaryWidget> createState() => _ButtonTertiaryWidgetState();
}

class _ButtonTertiaryWidgetState extends State<ButtonTertiaryWidget> {
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
    return AnimatedOpacity(
      opacity: true == widget.disable ? 0.4 : 1,
      duration: const Duration(milliseconds: 500),
      child: BlurWidget(
        borderRadius: BorderRadius.all(context.corners.rc360),
        child: ButtonBaseWidget(
          disable: true == widget.disable || isLoading,
          minWidth: double.infinity,
          height: widget.height ?? 48,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(context.corners.rc360),
          ),
          color: context.colors.background$30,
          onPressed: widget.onPressed != null ? _handlePress : null,
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return CupertinoActivityIndicator(
                  color: context.colors.onTertiary,
                  radius: 12,
                );
              }
              return widget.child ??
                  TextWidget(
                    widget.text,
                    style: widget.style ??
                        context.textStyles.headlineSmall.copyWith(
                          color: widget.textColor ?? context.colors.white,
                        ),
                    textAlign: TextAlign.center,
                  );
            },
          ),
        ),
      ),
    );
  }
}
