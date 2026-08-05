part of 'bottom_sheet.dart';

extension QuickActionSheet on BuildContext {
  Future<void> showQuickActionSheet({
    required List<QuickActionItem> actions,
    String? title,
    String? message,
    QuickActionItem? cancelAction,
    bool showCancelButton = true,
    Color? backgroundColor,
    Color? barrierColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    return showMaterialModalBottomSheet<void>(
      context: this,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.4),
      builder: (context) {
        return QuickActionSheetContent(
          title: title,
          message: message,
          actions: actions,
          cancelAction: cancelAction,
          showCancelButton: showCancelButton,
          backgroundColor: backgroundColor,
          titleStyle: titleStyle,
          messageStyle: messageStyle,
        );
      },
    );
  }
}

class QuickActionItem {
  const QuickActionItem({
    required this.title,
    this.onTap,
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.isDestructive = false,
    this.isDisabled = false,
    this.textStyle,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? backgroundColor;
  final IconData? icon;
  final bool isDestructive;
  final bool isDisabled;
  final TextStyle? textStyle;
}

class QuickActionSheetContent extends StatefulWidget {
  const QuickActionSheetContent({
    required this.actions,
    super.key,
    this.title,
    this.message,
    this.cancelAction,
    this.showCancelButton = true,
    this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
  });
  final String? title;
  final String? message;
  final List<QuickActionItem> actions;
  final QuickActionItem? cancelAction;
  final bool showCancelButton;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  @override
  State<QuickActionSheetContent> createState() =>
      _QuickActionSheetContentState();
}

class _QuickActionSheetContentState extends State<QuickActionSheetContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissSheet() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * context.height * 0.5),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main actions container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          widget.backgroundColor ?? context.colors.background,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header section
                        if (widget.title != null || widget.message != null)
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              20.h,
                              20.w,
                              12.h,
                            ),
                            child: Column(
                              children: [
                                if (widget.title != null)
                                  TextWidget(
                                    widget.title,
                                    style:
                                        widget.titleStyle ??
                                        context.textStyles.titleMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.colors.primary,
                                          fontFamily: FontFamily.cairo,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                if (widget.title != null &&
                                    widget.message != null)
                                  SizedBox(height: 4.h),
                                if (widget.message != null)
                                  TextWidget(
                                    widget.message,
                                    style:
                                        widget.messageStyle ??
                                        context.textStyles.bodyMedium.copyWith(
                                          color: context.colors.primary,
                                          fontFamily: FontFamily.cairo,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),

                        // Actions
                        ...widget.actions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final action = entry.value;
                          final isLast = index == widget.actions.length - 1;

                          return _QuickActionItem(
                            action: action,
                            isLast: isLast,
                            onTap: () async {
                              action.onTap?.call();
                            },
                          );
                        }),
                      ],
                    ),
                  ),

                  // Cancel button
                  if (widget.showCancelButton) SizedBox(height: 8.h),
                  if (widget.showCancelButton)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colors.background,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _QuickActionItem(
                        action:
                            widget.cancelAction ??
                            QuickActionItem(
                              title: 'إلغاء',
                              textColor: context.colors.primary,
                              textStyle: context.textStyles.bodyMedium.copyWith(
                                color: context.colors.primary,
                                fontFamily: FontFamily.cairo,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        isLast: true,
                        onTap: () async {
                          _dismissSheet();
                          // Wait for the animation to complete before calling the action
                          await Future<void>.delayed(
                            const Duration(milliseconds: 300),
                          );
                          widget.cancelAction?.onTap?.call();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.action,
    this.isLast = false,
    this.onTap,
  });
  final QuickActionItem action;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: action.isDisabled ? null : onTap,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
              bottom: isLast ? Radius.circular(16.r) : Radius.zero,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: action.backgroundColor,
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (action.icon != null) ...[
                    Icon(
                      action.icon,
                      size: 20.sp,
                      color: action.isDisabled
                          ? Colors.grey
                          : action.isDestructive
                          ? Colors.red
                          : action.textColor ?? context.colors.primary,
                    ),
                    SizedBox(width: 8.w),
                  ],
                  TextWidget(
                    action.title,
                    style:
                        action.textStyle ??
                        context.textStyles.bodyMedium.copyWith(
                          color: action.isDisabled
                              ? Colors.grey
                              : action.isDestructive
                              ? Colors.red
                              : action.textColor ?? context.colors.primary,
                          fontFamily: FontFamily.cairo,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(color: context.colors.onSecondary.withValues(alpha: 0.3)),
      ],
    );
  }
}
