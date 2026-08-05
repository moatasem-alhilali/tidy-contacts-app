part of 'bottom_sheet.dart';

extension BlurBottomSheet on BuildContext {
  void showBlurBottomSheet({
    required Widget Function(
      BuildContext context,
      ScrollController scrollController,
    )
    builder,
    double initialChildSize = 0.4,
    double minChildSize = 0.2,
    double maxChildSize = 0.9,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    Color? barrierColor,
    double blurSigmaX = 10.0,
    double blurSigmaY = 10.0,
    VoidCallback? onDismissed,
    List<double>? snapSizes,
    Duration animationDuration = const Duration(milliseconds: 350),
  }) {
    showMaterialModalBottomSheet<void>(
      context: this,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.3),
      duration: animationDuration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: _BlurBottomSheetContent(
            builder: builder,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            backgroundColor: backgroundColor,
            blurSigmaX: blurSigmaX,
            blurSigmaY: blurSigmaY,
            onDismissed: onDismissed,
            snapSizes: snapSizes,
            animationDuration: animationDuration,
          ),
        );
      },
    );
  }
}

class _BlurBottomSheetContent extends StatefulWidget {
  const _BlurBottomSheetContent({
    required this.builder,
    super.key,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.2,
    this.maxChildSize = 0.9,
    this.backgroundColor,
    this.blurSigmaX = 10.0,
    this.blurSigmaY = 10.0,
    this.onDismissed,
    this.snapSizes,
    this.animationDuration = const Duration(milliseconds: 350),
  });
  final Widget Function(BuildContext context, ScrollController scrollController)
  builder;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Color? backgroundColor;
  final double blurSigmaX;
  final double blurSigmaY;
  final VoidCallback? onDismissed;
  final List<double>? snapSizes;
  final Duration animationDuration;

  @override
  State<_BlurBottomSheetContent> createState() =>
      __BlurBottomSheetContentState();
}

class __BlurBottomSheetContentState extends State<_BlurBottomSheetContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _blurAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            _slideAnimation.value * MediaQuery.of(context).size.height * 0.3,
          ),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                left: 12.w,
                right: 12.w,
                top: MediaQuery.of(context).viewPadding.top + 40.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                child: Container(
                  decoration: BoxDecoration(
                    color: (widget.backgroundColor ?? Colors.white).withValues(
                      alpha: 0.9,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: DraggableScrollableSheet(
                    initialChildSize: widget.initialChildSize,
                    minChildSize: widget.minChildSize,
                    maxChildSize: widget.maxChildSize,
                    expand: false,
                    snap: true,
                    snapSizes:
                        widget.snapSizes ??
                        [
                          widget.minChildSize,
                          widget.initialChildSize,
                          widget.maxChildSize,
                        ],
                    builder: (context, scrollController) {
                      return Column(
                        children: [
                          // Enhanced Handle bar
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Center(
                              child: Container(
                                width: 60.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                            ),
                          ),

                          // Content
                          Expanded(
                            child: widget.builder(context, scrollController),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
