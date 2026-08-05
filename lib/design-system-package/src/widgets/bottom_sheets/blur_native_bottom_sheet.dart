part of 'bottom_sheet.dart';

extension BlurNativeBottomSheet on BuildContext {
  void showNativeBlurBottomSheet({
    required Widget Function(BuildContext context) builder,
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
    showModalBottomSheet<void>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: Colors.transparent,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

            child: Column(
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
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      // left: 12.w,
                      // right: 12.w,
                      // top: MediaQuery.of(context).viewPadding.top + 40.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 40,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: (backgroundColor ?? Colors.white)
                                .withOpacity(0.9),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28.r),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: builder(context),
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
    );
  }
}
