part of 'bottom_sheet.dart';

extension BlurredBackdropSheetExtension on BuildContext {
  /// Show a blurred backdrop sheet
  Future<T?> showBlurredBackdropSheet<T>({
    required Widget child,
    double blurIntensity = 15.0,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    bool isDismissible = true,
    bool showDragHandle = true,
    Duration animationDuration = const Duration(milliseconds: 300),
    double? minHeight,
    double? maxHeight,
    double? initialHeight,
    VoidCallback? onDismissed,
    bool useRootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: useRootNavigator).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierDismissible: isDismissible,
        transitionDuration: animationDuration,
        reverseTransitionDuration: animationDuration,
        pageBuilder: (context, animation, secondaryAnimation) {
          return BlurredBackdropSheet(
            blurIntensity: blurIntensity,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            isDismissible: isDismissible,
            showDragHandle: showDragHandle,
            animationDuration: animationDuration,
            minHeight: minHeight,
            maxHeight: maxHeight,
            initialHeight: initialHeight,
            onDismissed: onDismissed,
            child: child,
          );
        },
      ),
    );
  }
}

class BlurredBackdropSheet extends StatefulWidget {
  const BlurredBackdropSheet({
    required this.child,
    super.key,
    this.blurIntensity = 15.0,
    this.backgroundColor,
    this.borderRadius,
    this.isDismissible = true,
    this.showDragHandle = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.minHeight,
    this.maxHeight,
    this.initialHeight,
    this.onDismissed,
  });

  /// The child widget to display in the bottom sheet
  final Widget child;

  /// The blur intensity (0.0 to 30.0)
  final double blurIntensity;

  /// Custom background color overlay
  final Color? backgroundColor;

  /// Border radius for the bottom sheet
  final BorderRadius? borderRadius;

  /// Whether the sheet can be dismissed by dragging
  final bool isDismissible;

  /// Whether to show a drag handle
  final bool showDragHandle;

  /// Animation duration
  final Duration animationDuration;

  /// Minimum height of the bottom sheet in pixels
  final double? minHeight;

  /// Maximum height of the bottom sheet in pixels
  final double? maxHeight;

  /// Initial height of the bottom sheet in pixels
  final double? initialHeight;

  /// Callback when sheet is dismissed
  final VoidCallback? onDismissed;

  @override
  State<BlurredBackdropSheet> createState() => _BlurredBackdropSheetState();
}

class _BlurredBackdropSheetState extends State<BlurredBackdropSheet>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _blurAnimation = Tween<double>(
      begin: 0,
      end: widget.blurIntensity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (!widget.isDismissible) return;

    HapticFeedback.lightImpact();
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onDismissed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    // Convert pixel values to fractions for DraggableScrollableSheet
    final initialExtent = (widget.initialHeight ?? 400.0) / screenHeight;
    final minExtent = (widget.minHeight ?? 200.0) / screenHeight;
    final maxExtent = (widget.maxHeight ?? screenHeight * 0.9) / screenHeight;

    return Stack(
      children: [
        // Blurred backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: _dismiss,
            child: AnimatedBuilder(
              animation: _blurAnimation,
              builder: (context, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color:
                        widget.backgroundColor ??
                        (isDark
                            ? Colors.black.withValues(
                                alpha: 0.3 * (_controller.value),
                              )
                            : Colors.white.withValues(
                                alpha: 0.2 * (_controller.value),
                              )),
                  ),
                );
              },
            ),
          ),
        ),

        // Bottom sheet content using DraggableScrollableSheet for smooth expansion
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            // If the sheet is dragged below a certain threshold, we could trigger dismissal
            if (notification.extent <= minExtent * 0.8 &&
                widget.isDismissible) {
              _dismiss();
            }
            return true;
          },
          child: DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: initialExtent.clamp(0.0, 1.0),
            minChildSize: (minExtent * 0.8).clamp(0.0, 1.0),
            maxChildSize: maxExtent.clamp(0.0, 1.0),
            snap: true,
            snapSizes: [minExtent, initialExtent, maxExtent],
            builder: (context, scrollController) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - _controller.value) * screenHeight),
                    child: _BlurredSheetContent(
                      scrollController: scrollController,
                      borderRadius: widget.borderRadius,
                      showDragHandle: widget.showDragHandle,
                      isDismissible: widget.isDismissible,
                      child: widget.child,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BlurredSheetContent extends StatelessWidget {
  const _BlurredSheetContent({
    required this.child,
    required this.scrollController,
    this.borderRadius,
    this.showDragHandle = true,
    this.isDismissible = true,
  });

  final Widget child;
  final ScrollController scrollController;
  final BorderRadius? borderRadius;
  final bool showDragHandle;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Material(
            color: isDark
                ? (Colors.grey[900]?.withValues(alpha: 0.8) ??
                      Colors.black.withValues(alpha: 0.8))
                : Colors.white.withValues(alpha: 0.8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    borderRadius ??
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showDragHandle)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: theme.dividerColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
