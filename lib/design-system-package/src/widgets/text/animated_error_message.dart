part of 'text.dart';

class AnimatedErrorMessage extends StatefulWidget {
  const AnimatedErrorMessage({
    super.key,
    this.errorMessage,
    this.onDismiss,
    this.displayDuration = const Duration(seconds: 5),
    this.animationDuration = const Duration(milliseconds: 300),
    this.autoDismiss = true,
  });
  final String? errorMessage;
  final VoidCallback? onDismiss;
  final Duration displayDuration;
  final Duration animationDuration;
  final bool autoDismiss;

  @override
  State<AnimatedErrorMessage> createState() => _AnimatedErrorMessageState();
}

class _AnimatedErrorMessageState extends State<AnimatedErrorMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Show animation if there's an error message
    if (widget.errorMessage != null) {
      _showError();
    }
  }

  @override
  void didUpdateWidget(AnimatedErrorMessage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle changes in error message
    if (widget.errorMessage != oldWidget.errorMessage) {
      if (widget.errorMessage != null) {
        _showError();
      } else {
        _hideError();
      }
    }
  }

  void _showError() {
    _animationController.forward();
    _resetDismissTimer();
  }

  void _hideError() {
    _animationController.reverse();
    _cancelDismissTimer();
  }

  void _resetDismissTimer() {
    _cancelDismissTimer();
    if (widget.autoDismiss && widget.errorMessage != null) {
      _dismissTimer = Timer(widget.displayDuration, () {
        if (mounted && widget.onDismiss != null) {
          widget.onDismiss!();
        }
      });
    }
  }

  void _cancelDismissTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
  }

  @override
  void dispose() {
    _cancelDismissTimer();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: FadeTransition(
        opacity: _animation,
        child: widget.errorMessage != null
            ? Column(
                children: [
                  // SizedBox(height: context.spaces.lg),
                  Center(
                    child: TextWidget(
                      widget.errorMessage,
                      textAlign: TextAlign.center,
                      style: context.textStyles.titleSmall.copyWith(
                        color: context.colors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // SizedBox(height: context.insets.xl),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
