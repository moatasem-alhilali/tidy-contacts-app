part of 'animations.dart';

class BorderGradientAnimationWidget extends StatefulWidget {
  const BorderGradientAnimationWidget({
    required this.child,
    this.radius,
    this.bottomBorder,
    this.withBorder,
    this.fixedBorder,
    this.bottomBorderColor,
    this.height = 55,
    this.duration = 5,
    this.fixedBorderColor,
    super.key,
  });

  final Widget child;
  final Radius? radius;
  final bool? bottomBorder;
  final Color? bottomBorderColor;
  final bool? withBorder;
  final bool? fixedBorder;
  final Color? fixedBorderColor;
  final double? height;
  final int duration;

  @override
  State<BorderGradientAnimationWidget> createState() =>
      _BorderGradientAnimationWidgetState();
}

class _BorderGradientAnimationWidgetState
    extends State<BorderGradientAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: false == widget.withBorder
              ? SizedBox(height: widget.height)
              : true != widget.bottomBorder
                  ? AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) => ClipPath(
                        clipper: RoundedRectClipper(
                          widget.radius ?? context.corners.rc360,
                        ),
                        child: Container(
                          height: widget.height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              widget.radius ?? context.corners.rc360,
                            ),
                            border: true == widget.fixedBorder
                                ? Border.all(
                                    color: widget.fixedBorderColor ??
                                        context.colors.onSecondaryContainer,
                                  )
                                : null,
                            gradient: () {
                              if (true == widget.fixedBorder) {
                                return null;
                              }
                              return null;
                            }(),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: widget.height,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(height: widget.height),
        ),
        Center(
          child: widget.child,
        ),
      ],
    );
  }
}

class RoundedRectClipper extends CustomClipper<Path> {
  RoundedRectClipper(this.radius);

  final Radius radius;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromLTRBR(0, 0, size.width, size.height, radius),
      );

    // Inner rounded rectangle for the gap
    const innerPadding = 1.5; // Adjust this for gap size
    path.addRRect(
      RRect.fromLTRBR(
        innerPadding,
        innerPadding,
        size.width - innerPadding,
        size.height - innerPadding,
        radius,
      ),
    );

    // Subtract the inner rounded rectangle from the outer to create a gap
    return Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(
          RRect.fromLTRBR(
            0,
            0,
            size.width,
            size.height,
            radius,
          ),
        ),
      Path()
        ..addRRect(
          RRect.fromLTRBR(
            innerPadding,
            innerPadding,
            size.width - innerPadding,
            size.height - innerPadding,
            radius,
          ),
        ),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
