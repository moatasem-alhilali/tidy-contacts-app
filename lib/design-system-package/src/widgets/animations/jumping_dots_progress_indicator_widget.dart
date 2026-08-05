part of 'animations.dart';

class JumpingDotsProgressIndicatorWidget extends StatefulWidget {
  const JumpingDotsProgressIndicatorWidget({
    this.numberOfDots = 4,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.dotColor = Colors.white,
    this.jumpHeight,
    this.dotSize,
    super.key,
  });

  final int numberOfDots;
  final double? dotSize;
  final Duration animationDuration;
  final Color dotColor;
  final double? jumpHeight;

  @override
  JumpingDotsProgressIndicatorWidgetState createState() =>
      JumpingDotsProgressIndicatorWidgetState();
}

class JumpingDotsProgressIndicatorWidgetState
    extends State<JumpingDotsProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat(); // Makes the animation infinite
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.numberOfDots,
        (index) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final animationValue =
                (_controller.value + (index / widget.numberOfDots)) % 1.0;
            final translateY =
                (widget.jumpHeight ?? 10.h) * (0.5 - (0.5 - animationValue).abs()).abs();

            return Transform.translate(
              offset: Offset(0, -translateY),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.insets.sm),
                child: Container(
                  width: widget.dotSize ?? 3.h,
                  height: widget.dotSize ?? 3.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.dotColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
