// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
// import 'package:purnameg/core/extension/theme_extensions.dart';

// /// A bottom cursor pinput widget with unique cursor positioning.
// ///
// /// Features:
// /// - Bottom positioned cursor
// /// - Animated cursor transitions
// /// - Clean, minimal design
// /// - Theme-aware styling
// /// - Smooth animations
// /// - Accessibility support
// /// - SMS autofill support
// class PinputBottomCursorWidget extends StatefulWidget {
//   const PinputBottomCursorWidget({
//     super.key,
//     this.length = 6,
//     this.onCompleted,
//     this.onChanged,
//     this.controller,
//     this.focusNode,
//     this.validator,
//     this.enabled = true,
//     this.obscureText = false,
//     this.readOnly = false,
//     this.autofocus = false,
//     this.errorText,
//     this.autovalidateMode = PinputAutovalidateMode.onSubmit,
//     this.hapticFeedbackType = HapticFeedbackType.lightImpact,
//     this.closeKeyboardWhenCompleted = true,
//     this.useNativeKeyboard = true,
//     this.semanticsLabel,
//     this.animationDuration = const Duration(milliseconds: 250),
//     this.animationCurve = Curves.easeInOut,
//     this.cursorColor,
//     this.cursorWidth = 2.0,
//     this.cursorHeight = 2.0,
//     this.cursorAnimationDuration = const Duration(milliseconds: 500),
//     this.customPinputSize,
//     this.customBorderRadius,
//     this.customTextStyle,
//     this.enableHapticFeedback = true,
//     this.showBottomBorder = true,
//     this.bottomBorderColor,
//     this.bottomBorderWidth = 1.0,
//     this.enableCursorAnimation = true,
//     this.pinFieldSpacing = 8.0,
//     this.enableFloatingCursor = false,
//     this.obscuringCharacter = '●',
//     this.enableSuggestions = true,
//   });

//   /// The number of pin input fields. Default is 6.
//   final int length;

//   /// Called when all pin fields are filled.
//   final void Function(String)? onCompleted;

//   /// Called when any pin field changes.
//   final void Function(String)? onChanged;

//   /// Controller for the pin input.
//   final TextEditingController? controller;

//   /// Focus node for the pin input.
//   final FocusNode? focusNode;

//   /// Validator function for the pin input.
//   final String? Function(String?)? validator;

//   /// Whether the pin input is enabled.
//   final bool enabled;

//   /// Whether to obscure the pin input (for sensitive data).
//   final bool obscureText;

//   /// Whether the pin input is read-only.
//   final bool readOnly;

//   /// Whether to auto-focus on the pin input.
//   final bool autofocus;

//   /// Error text to display below the pin input.
//   final String? errorText;

//   /// When to automatically validate the pin input.
//   final PinputAutovalidateMode autovalidateMode;

//   /// Type of haptic feedback to use.
//   final HapticFeedbackType hapticFeedbackType;

//   /// Whether to close the keyboard when pin is completed.
//   final bool closeKeyboardWhenCompleted;

//   /// Whether to use native keyboard.
//   final bool useNativeKeyboard;

//   /// Semantic label for accessibility.
//   final String? semanticsLabel;

//   /// Animation duration for state changes.
//   final Duration animationDuration;

//   /// Animation curve for state changes.
//   final Curve animationCurve;

//   /// Cursor color.
//   final Color? cursorColor;

//   /// Cursor width.
//   final double cursorWidth;

//   /// Cursor height.
//   final double cursorHeight;

//   /// Cursor animation duration.
//   final Duration cursorAnimationDuration;

//   /// Custom size for pin input fields.
//   final Size? customPinputSize;

//   /// Custom border radius for pin input fields.
//   final BorderRadius? customBorderRadius;

//   /// Custom text style.
//   final TextStyle? customTextStyle;

//   /// Whether to enable haptic feedback.
//   final bool enableHapticFeedback;

//   /// Whether to show bottom border.
//   final bool showBottomBorder;

//   /// Bottom border color.
//   final Color? bottomBorderColor;

//   /// Bottom border width.
//   final double bottomBorderWidth;

//   /// Whether to enable cursor animation.
//   final bool enableCursorAnimation;

//   /// Spacing between pin fields.
//   final double pinFieldSpacing;

//   /// Whether to enable floating cursor.
//   final bool enableFloatingCursor;

//   /// Character to use for obscuring.
//   final String obscuringCharacter;

//   /// Whether to enable suggestions.
//   final bool enableSuggestions;

//   @override
//   State<PinputBottomCursorWidget> createState() =>
//       _PinputBottomCursorWidgetState();
// }

// class _PinputBottomCursorWidgetState extends State<PinputBottomCursorWidget>
//     with TickerProviderStateMixin {
//   late TextEditingController _controller;
//   late FocusNode _focusNode;
//   late AnimationController _cursorAnimationController;
//   late Animation<double> _cursorOpacityAnimation;
//   late AnimationController _scaleAnimationController;
//   late Animation<double> _scaleAnimation;
//   bool _hasError = false;
//   // Removed unused fields _isCompleted and _currentIndex

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//     _focusNode = widget.focusNode ?? FocusNode();

//     // Setup cursor animation
//     _cursorAnimationController = AnimationController(
//       duration: widget.cursorAnimationDuration,
//       vsync: this,
//     );
//     _cursorOpacityAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _cursorAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Setup scale animation
//     _scaleAnimationController = AnimationController(
//       duration: widget.animationDuration,
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 1,
//       end: 1.05,
//     ).animate(
//       CurvedAnimation(
//         parent: _scaleAnimationController,
//         curve: widget.animationCurve,
//       ),
//     );

//     // Listen to changes
//     _controller.addListener(_onTextChanged);
//     _focusNode.addListener(_onFocusChanged);

//     // Start cursor animation
//     if (widget.enableCursorAnimation) {
//       _cursorAnimationController.repeat(reverse: true);
//     }
//   }

//   @override
//   void dispose() {
//     _cursorAnimationController.dispose();
//     _scaleAnimationController.dispose();
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     if (widget.focusNode == null) {
//       _focusNode.dispose();
//     }
//     super.dispose();
//   }

//   void _onTextChanged() {
//     if (mounted) {
//       setState(() {
//         _hasError = false;
//         // _isCompleted and _currentIndex removed as they were only set but never used
//       });
//     }
//   }

//   void _onFocusChanged() {
//     if (_focusNode.hasFocus) {
//       _scaleAnimationController.forward();
//       if (widget.enableCursorAnimation) {
//         _cursorAnimationController.repeat(reverse: true);
//       }
//     } else {
//       _scaleAnimationController.reverse();
//       if (widget.enableCursorAnimation) {
//         _cursorAnimationController.stop();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _cursorAnimationController,
//         _scaleAnimationController,
//       ]),
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildPinput(),
//               if (widget.errorText != null || _hasError) ...[
//                 context.spacing.verticalGapXS,
//                 _buildErrorText(),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPinput() {
//     final pinSize = widget.customPinputSize ?? Size(48.w, 56.h);
//     final borderRadius =
//         widget.customBorderRadius ?? context.radius.borderSmall;
//     final cursorColor = widget.cursorColor ?? context.colors.primary;
//     final bottomBorderColor =
//         widget.bottomBorderColor ?? context.colors.outline;

//     final defaultPinTheme = PinTheme(
//       width: pinSize.width,
//       height: pinSize.height,
//       textStyle: widget.customTextStyle ??
//           context.titleMedium?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: context.colors.onSurface,
//             fontSize: 18.sp,
//           ),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         border: widget.showBottomBorder
//             ? Border(
//                 bottom: BorderSide(
//                   color: bottomBorderColor,
//                   width: widget.bottomBorderWidth,
//                 ),
//               )
//             : null,
//         borderRadius: widget.showBottomBorder ? null : borderRadius,
//       ),
//       margin: EdgeInsets.symmetric(horizontal: widget.pinFieldSpacing / 2),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: widget.showBottomBorder
//           ? Border(
//               bottom: BorderSide(
//                 color: cursorColor,
//                 width: widget.bottomBorderWidth * 2,
//               ),
//             )
//           : Border.all(
//               color: cursorColor,
//               width: 2.w,
//             ),
//       boxShadow: [
//         BoxShadow(
//           color: cursorColor.withValues(alpha: 0.2),
//           blurRadius: 6.r,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: context.colors.primaryContainer.withValues(alpha: 0.3),
//         border: widget.showBottomBorder
//             ? Border(
//                 bottom: BorderSide(
//                   color: context.colors.primary,
//                   width: widget.bottomBorderWidth,
//                 ),
//               )
//             : Border.all(
//                 color: context.colors.primary,
//                 width: 1.w,
//               ),
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleMedium?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onPrimaryContainer,
//             fontSize: 18.sp,
//           ),
//     );

//     final errorPinTheme = defaultPinTheme.copyDecorationWith(
//       border: widget.showBottomBorder
//           ? Border(
//               bottom: BorderSide(
//                 color: context.colors.error,
//                 width: widget.bottomBorderWidth * 2,
//               ),
//             )
//           : Border.all(
//               color: context.colors.error,
//               width: 2.w,
//             ),
//       boxShadow: [
//         BoxShadow(
//           color: context.colors.error.withValues(alpha: 0.2),
//           blurRadius: 6.r,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     );

//     final followingPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Colors.transparent,
//         border: widget.showBottomBorder
//             ? Border(
//                 bottom: BorderSide(
//                   color: bottomBorderColor.withValues(alpha: 0.5),
//                   width: widget.bottomBorderWidth,
//                 ),
//               )
//             : null,
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleMedium?.copyWith(
//             fontWeight: FontWeight.w500,
//             color: context.colors.onSurface.withValues(alpha: 0.6),
//             fontSize: 18.sp,
//           ),
//     );

//     return Semantics(
//       label: widget.semanticsLabel ?? 'Bottom cursor pin input field',
//       child: Pinput(
//         length: widget.length,
//         controller: _controller,
//         focusNode: _focusNode,
//         defaultPinTheme: defaultPinTheme,
//         focusedPinTheme: focusedPinTheme,
//         submittedPinTheme: submittedPinTheme,
//         followingPinTheme: followingPinTheme,
//         errorPinTheme: errorPinTheme,
//         enabled: widget.enabled,
//         obscureText: widget.obscureText,
//         obscuringCharacter: widget.obscuringCharacter,
//         readOnly: widget.readOnly,
//         autofocus: widget.autofocus,
//         pinputAutovalidateMode: widget.autovalidateMode,
//         hapticFeedbackType: widget.hapticFeedbackType,
//         closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
//         useNativeKeyboard: widget.useNativeKeyboard,
//         cursor: _buildCustomCursor(),
//         onCompleted: (pin) {
//           if (widget.enableHapticFeedback) {
//             HapticFeedback.heavyImpact();
//           }
//           widget.onCompleted?.call(pin);
//         },
//         onChanged: (pin) {
//           if (widget.enableHapticFeedback && pin.isNotEmpty) {
//             HapticFeedback.selectionClick();
//           }
//           widget.onChanged?.call(pin);
//         },
//         validator: (value) {
//           final error = widget.validator?.call(value);
//           if (error != null) {
//             setState(() {
//               _hasError = true;
//             });
//             if (widget.enableHapticFeedback) {
//               HapticFeedback.vibrate();
//             }
//           }
//           return error;
//         },
//         forceErrorState: _hasError,
//         errorText: widget.errorText,
//         animationDuration: widget.animationDuration,
//         animationCurve: widget.animationCurve,
//         enableSuggestions: widget.enableSuggestions,
//       ),
//     );
//   }

//   Widget _buildCustomCursor() {
//     final cursorColor = widget.cursorColor ?? context.colors.primary;

//     if (widget.showBottomBorder) {
//       // Bottom positioned cursor
//       return Positioned(
//         bottom: 0,
//         left: 0,
//         right: 0,
//         child: AnimatedContainer(
//           duration: widget.cursorAnimationDuration,
//           height: widget.cursorHeight,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: widget.enableCursorAnimation
//                 ? cursorColor.withValues(alpha: _cursorOpacityAnimation.value)
//                 : cursorColor,
//             borderRadius: BorderRadius.circular(widget.cursorHeight / 2),
//           ),
//         ),
//       );
//     } else {
//       // Standard cursor
//       return Container(
//         width: widget.cursorWidth,
//         height: 20.h,
//         decoration: BoxDecoration(
//           color: widget.enableCursorAnimation
//               ? cursorColor.withValues(alpha: _cursorOpacityAnimation.value)
//               : cursorColor,
//           borderRadius: BorderRadius.circular(widget.cursorWidth / 2),
//         ),
//       );
//     }
//   }

//   Widget _buildErrorText() {
//     return AnimatedSlide(
//       duration: const Duration(milliseconds: 200),
//       offset: _hasError ? Offset.zero : const Offset(0, -0.5),
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 200),
//         opacity: _hasError ? 1.0 : 0.0,
//         child: Container(
//           padding: EdgeInsets.only(
//             left: context.spacing.xs,
//             top: context.spacing.xs,
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 16.sp,
//                 color: context.colors.error,
//               ),
//               context.spacing.horizontalGapXS,
//               Expanded(
//                 child: Text(
//                   widget.errorText ?? 'Please check your input',
//                   style: context.bodySmall?.copyWith(
//                     color: context.colors.error,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
