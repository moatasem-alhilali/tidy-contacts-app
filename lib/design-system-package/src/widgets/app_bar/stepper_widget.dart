part of 'app_bar.dart';

class StepperWidget extends StatefulWidget {
  const StepperWidget({
    required this.length,
    required this.index,
    required this.onChanged,
    required this.duration,
    this.selectedColor,
    this.unSelectedColor,
    this.startStepper = true,
    super.key,
  });

  final int length;
  final int index;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final ValueChanged<int> onChanged;
  final int duration;
  final bool startStepper;

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  bool _hasStarted = false; // Track if the animation has started

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _widthAnimation = Tween<double>(
      begin: 0,
      end: 1, // Full width (scaled by maxWidth)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.startStepper) {
        if (mounted) {
          widget.onChanged.call(widget.index + 1);
        }
      }
    });

    if (widget.startStepper) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (!_hasStarted) {
      _hasStarted = true;
      _controller..reset()
      ..forward();
    }
  }

  @override
  void didUpdateWidget(covariant StepperWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.startStepper && widget.startStepper) {
      _startAnimation();
    }

    if (oldWidget.duration != widget.duration) {
      _controller.duration = Duration(seconds: widget.duration);
    }
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
      children: [
        for (var i = 0; i < widget.length; ++i) ...[
          Expanded(
            child: widget.index == i
                ? Container(
                    height: 2,
                    margin: EdgeInsetsDirectional.only(
                      start: i == widget.index ? 0 : 1,
                      end: i == (widget.length - 1) ? 0 : 1,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(context.corners.rc360),
                      color: context.colors.background$30,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final width =
                                  _widthAnimation.value * constraints.maxWidth;
                              return Container(
                                height: 2,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(context.corners.rc360),
                                  color: context.colors.white,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : widget.index > i
                    ? Container(
                        height: 2,
                        margin: EdgeInsetsDirectional.only(
                          start: i == widget.index ? 0 : 1,
                          end: i == (widget.length - 1) ? 0 : 1,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(context.corners.rc360),
                          color: context.colors.white,
                        ),
                      )
                    : Container(
                        height: 2,
                        margin: EdgeInsetsDirectional.only(
                          start: i == widget.index ? 0 : 1,
                          end: i == (widget.length - 1) ? 0 : 1,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(context.corners.rc360),
                          color: context.colors.background$30,
                        ),
                      ),
          ),
        ],
      ],
    );
  }
}
