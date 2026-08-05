part of 'bottom_sheet.dart';

extension BaseBottomSheet on BuildContext {
  void showBaseBottomSheet({
    Widget? child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    Color? backgroundColor,
    Color? barrierColor,
    BorderRadius? borderRadius,
    Duration? animationDuration,
    bool isScroll = true,
  }) {
    showMaterialModalBottomSheet<void>(
      context: this,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: barrierColor ?? colors.black.withValues(alpha: 0.3),
      duration: animationDuration ?? const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) {
        final insets = MediaQuery.of(context).viewInsets;
        return AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: insets.bottom),
          child: Container(
            height: height, // اتركها null لو تبغى على قد المحتوى
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.sp),
            decoration: BoxDecoration(
              color: backgroundColor ?? colors.background,
              borderRadius:
                  borderRadius ??
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
                BoxShadow(
                  color: colors.black.withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                    decoration: BoxDecoration(
                      color: colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  // Content with scroll support
                  if (isScroll)
                    Flexible(
                      child: SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: child,
                      ),
                    )
                  else
                    Flexible(child: child ?? const SizedBox()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
