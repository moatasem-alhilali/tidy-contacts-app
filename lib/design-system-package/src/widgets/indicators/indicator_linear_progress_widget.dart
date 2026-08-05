part of 'indicators.dart';

class IndicatorLinearProgressWidget extends StatefulWidget {
  const IndicatorLinearProgressWidget({
    this.asyncFunction,
    this.onFinish,
    super.key,
  });

  final dynamic Function()? onFinish;
  final dynamic Function()? asyncFunction;

  @override
  State<IndicatorLinearProgressWidget> createState() =>
      _IndicatorLinearProgressWidgetState();
}

class _IndicatorLinearProgressWidgetState
    extends State<IndicatorLinearProgressWidget>
    with SingleTickerProviderStateMixin {
  double _progress = 0;
  final double _duration = 100;
  late AnimationController _shineController;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Trigger the loading.json data function after the widget is laid out
    WidgetsBinding.instance.addPostFrameCallback((_) => loadingData());
  }

  Future<void> loadingData() async {
    try {
      if (!mounted) return;
      // Simulate initial progress
      unawaited(_increaseProgress());

      // If asyncFunction is provided, start the async operation with progress tracking
      if (widget.asyncFunction != null) {
        await widget.asyncFunction!();
      }

      // Increment progress to 100% over time
      for (var i = 80; i <= 100; i++) {
        await Future.delayed(
            Duration(milliseconds: (100 * _duration / 100).round()));
        if (!mounted) return;
        setState(() {
          _progress = i / 100;
        });
      }

      if (!mounted) return;
      // When the operation finishes, call onFinish
      widget.onFinish?.call();
    } catch (_) {
      // Handle any exceptions that occur during the async operation
    }
  }

  Future<void> _increaseProgress() async {
    try {
      if (!mounted) return;

      // Fallback to simulating progress if no asyncFunction is provided
      for (var i = 1; i <= 80; i++) {
        await Future.delayed(
            Duration(milliseconds: (100 * _duration / 100).round()));
        if (!mounted) return;
        setState(() {
          _progress = i / 100;
        });
      }
    } catch (_) {
      // Handle any exceptions that occur during the async operation
    }
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextWidget(
            '${(_progress * 100).round()}%',
            style: context.textStyles.labelLarge
                ?.copyWith(color: const Color(0xFF9A9491)),
          ),
        ),
        SizedBox(height: context.insets.xl),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA0A0A0),
                    borderRadius: BorderRadius.all(context.corners.rc360),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * _progress,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.all(context.corners.rc360),
                        ),
                      ),
                      ShimmerWidget(
                        child: Container(
                          height: 3,
                          color: Colors.white,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
