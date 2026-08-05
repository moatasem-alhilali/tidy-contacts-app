part of 'animations.dart';

enum JiggleState { JIGGLING, STATIC }

/// A widget that "jiggles" when triggered.
class JiggleWidget extends StatefulWidget {
  const JiggleWidget({
    required this.child,
    required this.jiggleController,
    required this.onTap,
    this.duration = const Duration(milliseconds: 100),
    super.key,
  });

  final Duration duration;
  final Widget child;
  final JiggleController jiggleController;
  final GestureTapCallback? onTap;

  @override
  State<JiggleWidget> createState() => _JiggleWidgetState();
}

class _JiggleWidgetState extends State<JiggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _jiggleAnimationController;
  late Animation<double> jiggleAnimation;

  @override
  void initState() {
    _jiggleAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 0,
      lowerBound: 0.5,
      upperBound: 0.508,
    );

    jiggleAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(_jiggleAnimationController);

    _jiggleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _jiggleAnimationController.repeat(reverse: true);
      }
    });
    super.initState();
  }

  void listenForJiggles() {
    widget.jiggleController.stream.listen((event) {
      if (event == JiggleState.STATIC) {
        _jiggleAnimationController
          ..animateTo(0, duration: Duration.zero)
          ..stop();
      } else if (event == JiggleState.JIGGLING) {
        _jiggleAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _jiggleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listenForJiggles();
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: jiggleAnimation,
        child: widget.child,
        builder: (context, child) {
          return RotatedBox(
            quarterTurns: 2,
            child: Transform.rotate(
              angle: jiggleAnimation.value * math.pi,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(context.corners.rc),
                    child: child,
                  ),
                  if (widget.onTap != null &&
                      widget.jiggleController.isJiggling)
                    PositionedDirectional(
                      end: -16,
                      top: -16,
                      child: InkWell(
                        onTap: widget.onTap,
                        borderRadius: BorderRadius.all(context.corners.rc360),
                        child: Padding(
                          padding: EdgeInsets.all(context.spaces.sm),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: context.colors.error,
                            child: ImageSvgAsset(
                              'Assets.icons.close.path',
                              color: context.colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class JiggleController {
  JiggleState _state = JiggleState.STATIC;

  JiggleState get state => _state;

  bool get isJiggling => _state == JiggleState.JIGGLING;

  final StreamController<JiggleState> _controller =
      StreamController.broadcast();

  Stream<JiggleState> get stream => _controller.stream;

  void toggle() {
    _state = _state == JiggleState.STATIC
        ? JiggleState.JIGGLING
        : JiggleState.STATIC;
    _controller.add(_state);
  }

  void dispose() {
    _controller.close();
  }
}
