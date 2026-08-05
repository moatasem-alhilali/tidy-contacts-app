// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
// import 'package:purnameg/core/extension/theme_extensions.dart';

// /// A gradient pinput widget with beautiful gradient effects.
// ///
// /// Features:
// /// - Customizable gradient backgrounds
// /// - Animated gradient transitions
// /// - Shimmer effect on focus
// /// - Advanced visual feedback
// /// - Theme-aware styling
// /// - Smooth animations
// /// - Accessibility support
// /// - SMS autofill support (iOS & Android)
// class PinputGradientWidget extends StatefulWidget {
//   const PinputGradientWidget({
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
//     this.animationDuration = const Duration(milliseconds: 400),
//     this.animationCurve = Curves.easeInOutQuart,
//     this.enableShimmerEffect = true,
//     this.gradientColors,
//     this.focusedGradientColors,
//     this.submittedGradientColors,
//     this.errorGradientColors,
//     this.customPinputSize,
//     this.customBorderRadius,
//     this.enablePulseAnimation = true,
//     this.enableGlowEffect = true,
//     this.glowColor,
//     this.gradientBegin = Alignment.topLeft,
//     this.gradientEnd = Alignment.bottomRight,
//     this.customTextStyle,
//     this.enableHapticFeedback = true,

//     // SMS Autofill
//     this.enableSmsAutofill = true,
//     this.smsAutofillHints = const [AutofillHints.oneTimeCode],
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

//   /// Whether to enable shimmer effect.
//   final bool enableShimmerEffect;

//   /// Default gradient colors.
//   final List<Color>? gradientColors;

//   /// Focused state gradient colors.
//   final List<Color>? focusedGradientColors;

//   /// Submitted state gradient colors.
//   final List<Color>? submittedGradientColors;

//   /// Error state gradient colors.
//   final List<Color>? errorGradientColors;

//   /// Custom size for pin input fields.
//   final Size? customPinputSize;

//   /// Custom border radius for pin input fields.
//   final BorderRadius? customBorderRadius;

//   /// Whether to enable pulse animation.
//   final bool enablePulseAnimation;

//   /// Whether to enable glow effect.
//   final bool enableGlowEffect;

//   /// Custom glow color.
//   final Color? glowColor;

//   /// Gradient begin alignment.
//   final Alignment gradientBegin;

//   /// Gradient end alignment.
//   final Alignment gradientEnd;

//   /// Custom text style.
//   final TextStyle? customTextStyle;

//   /// Whether to enable haptic feedback.
//   final bool enableHapticFeedback;

//   /// Whether to enable SMS autofill.
//   final bool enableSmsAutofill;

//   /// SMS autofill hints for iOS and Android.
//   final List<String> smsAutofillHints;

//   @override
//   State<PinputGradientWidget> createState() => _PinputGradientWidgetState();
// }

// class _PinputGradientWidgetState extends State<PinputGradientWidget>
//     with TickerProviderStateMixin {
//   late TextEditingController _controller;
//   late FocusNode _focusNode;
//   late AnimationController _shimmerController;
//   late AnimationController _pulseController;
//   late AnimationController _glowController;
//   late Animation<double> _shimmerAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _glowAnimation;
//   bool _hasError = false;
//   // Removed unused field _isCompleted

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//     _focusNode = widget.focusNode ?? FocusNode();

//     // Setup shimmer animation
//     _shimmerController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _shimmerAnimation = Tween<double>(
//       begin: -2,
//       end: 2,
//     ).animate(
//       CurvedAnimation(
//         parent: _shimmerController,
//         curve: Curves.easeInOutSine,
//       ),
//     );

//     // Setup pulse animation
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _pulseAnimation = Tween<double>(
//       begin: 1,
//       end: 1.1,
//     ).animate(
//       CurvedAnimation(
//         parent: _pulseController,
//         curve: Curves.easeInOutCirc,
//       ),
//     );

//     // Setup glow animation
//     _glowController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _glowAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _glowController,
//         curve: Curves.easeInOutCubic,
//       ),
//     );

//     // Listen to focus changes
//     _focusNode.addListener(_onFocusChanged);
//     _controller.addListener(_onTextChanged);

//     // Start shimmer animation if enabled
//     if (widget.enableShimmerEffect) {
//       _shimmerController.repeat();
//     }
//   }

//   @override
//   void dispose() {
//     _shimmerController.dispose();
//     _pulseController.dispose();
//     _glowController.dispose();
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     if (widget.focusNode == null) {
//       _focusNode.dispose();
//     }
//     super.dispose();
//   }

//   void _onFocusChanged() {
//     if (_focusNode.hasFocus) {
//       if (widget.enablePulseAnimation) {
//         _pulseController.forward();
//       }
//       if (widget.enableGlowEffect) {
//         _glowController.forward();
//       }
//     } else {
//       if (widget.enablePulseAnimation) {
//         _pulseController.reverse();
//       }
//       if (widget.enableGlowEffect) {
//         _glowController.reverse();
//       }
//     }
//   }

//   void _onTextChanged() {
//     if (mounted) {
//       setState(() {
//         _hasError = false;
//         // _isCompleted removed as it was only set but never used
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _shimmerController,
//         _pulseController,
//         _glowController,
//       ]),
//       builder: (context, child) {
//         return Transform.scale(
//           scale: widget.enablePulseAnimation ? _pulseAnimation.value : 1.0,
//           child: Container(
//             decoration: widget.enableGlowEffect
//                 ? BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: (widget.glowColor ?? context.colors.primary)
//                             .withValues(alpha: 0.3 * _glowAnimation.value),
//                         blurRadius: 20.r * _glowAnimation.value,
//                         spreadRadius: 5.r * _glowAnimation.value,
//                       ),
//                     ],
//                   )
//                 : null,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildPinput(),
//                 if (widget.errorText != null || _hasError) ...[
//                   context.spacing.verticalGapXS,
//                   _buildErrorText(),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPinput() {
//     final pinSize = widget.customPinputSize ?? Size(56.w, 64.h);
//     final borderRadius =
//         widget.customBorderRadius ?? context.radius.borderLarge;

//     // Default gradient colors
//     final defaultGradient = widget.gradientColors ??
//         [
//           context.colors.primary,
//           context.colors.primaryContainer,
//         ];

//     final focusedGradient = widget.focusedGradientColors ??
//         [
//           context.colors.primary,
//           context.colors.secondary,
//         ];

//     final submittedGradient = widget.submittedGradientColors ??
//         [
//           context.colors.primary,
//           context.colors.tertiary,
//         ];

//     final errorGradient = widget.errorGradientColors ??
//         [
//           context.colors.error,
//           context.colors.errorContainer,
//         ];

//     final defaultPinTheme = PinTheme(
//       width: pinSize.width,
//       height: pinSize.height,
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onPrimary,
//             fontSize: 22.sp,
//           ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: defaultGradient,
//           begin: widget.gradientBegin,
//           end: widget.gradientEnd,
//         ),
//         borderRadius: borderRadius,
//         boxShadow: context.shadows.medium,
//       ),
//       margin: EdgeInsets.symmetric(horizontal: context.spacing.xs),
//     );

//     final focusedPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: focusedGradient,
//           begin: widget.gradientBegin,
//           end: widget.gradientEnd,
//         ),
//         borderRadius: borderRadius,
//         boxShadow: [
//           BoxShadow(
//             color: context.colors.primary.withValues(alpha: 0.4),
//             blurRadius: 12.r,
//             offset: const Offset(0, 4),
//           ),
//           BoxShadow(
//             color: context.colors.primary.withValues(alpha: 0.2),
//             blurRadius: 24.r,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: submittedGradient,
//           begin: widget.gradientBegin,
//           end: widget.gradientEnd,
//         ),
//         borderRadius: borderRadius,
//         boxShadow: [
//           BoxShadow(
//             color: context.colors.primary.withValues(alpha: 0.5),
//             blurRadius: 8.r,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//     );

//     final errorPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: errorGradient,
//           begin: widget.gradientBegin,
//           end: widget.gradientEnd,
//         ),
//         borderRadius: borderRadius,
//         boxShadow: [
//           BoxShadow(
//             color: context.colors.error.withValues(alpha: 0.4),
//             blurRadius: 12.r,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onError,
//             fontSize: 22.sp,
//           ),
//     );

//     final followingPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: defaultGradient
//               .map((color) => color.withValues(alpha: 0.3))
//               .toList(),
//           begin: widget.gradientBegin,
//           end: widget.gradientEnd,
//         ),
//         borderRadius: borderRadius,
//         boxShadow: context.shadows.small,
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: context.colors.onSurface.withValues(alpha: 0.6),
//             fontSize: 22.sp,
//           ),
//     );

//     final Widget pinputWidget = Pinput(
//       length: widget.length,
//       controller: _controller,
//       focusNode: _focusNode,
//       defaultPinTheme: defaultPinTheme,
//       focusedPinTheme: focusedPinTheme,
//       submittedPinTheme: submittedPinTheme,
//       followingPinTheme: followingPinTheme,
//       errorPinTheme: errorPinTheme,
//       enabled: widget.enabled,
//       obscureText: widget.obscureText,
//       readOnly: widget.readOnly,
//       autofocus: widget.autofocus,
//       pinputAutovalidateMode: widget.autovalidateMode,
//       hapticFeedbackType: widget.hapticFeedbackType,
//       closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
//       useNativeKeyboard: widget.useNativeKeyboard,
//       cursor: Container(
//         width: 2.w,
//         height: 28.h,
//         decoration: BoxDecoration(
//           color: context.colors.onPrimary,
//           borderRadius: BorderRadius.circular(1.r),
//         ),
//       ),
//       onCompleted: (pin) {
//         if (widget.enableHapticFeedback) {
//           HapticFeedback.heavyImpact();
//         }
//         widget.onCompleted?.call(pin);
//       },
//       onChanged: (pin) {
//         if (widget.enableHapticFeedback && pin.isNotEmpty) {
//           HapticFeedback.selectionClick();
//         }
//         widget.onChanged?.call(pin);
//       },
//       validator: (value) {
//         final error = widget.validator?.call(value);
//         if (error != null) {
//           setState(() {
//             _hasError = true;
//           });
//           if (widget.enableHapticFeedback) {
//             HapticFeedback.vibrate();
//           }
//         }
//         return error;
//       },
//       forceErrorState: _hasError,
//       errorText: widget.errorText,
//       animationDuration: widget.animationDuration,
//       animationCurve: widget.animationCurve,
//       // SMS Autofill
//       autofillHints: widget.enableSmsAutofill ? widget.smsAutofillHints : null,
//     );

//     // Add shimmer effect if enabled
//     if (widget.enableShimmerEffect && !_hasError) {
//       return ClipRRect(
//         borderRadius: borderRadius,
//         child: ShaderMask(
//           shaderCallback: (bounds) {
//             return LinearGradient(
//               colors: [
//                 Colors.transparent,
//                 Colors.white.withValues(alpha: 0.5),
//                 Colors.transparent,
//               ],
//               stops: const [0.0, 0.5, 1.0],
//               begin: Alignment(_shimmerAnimation.value, 0),
//               end: Alignment(_shimmerAnimation.value + 0.5, 0),
//             ).createShader(bounds);
//           },
//           blendMode: BlendMode.srcOver,
//           child: pinputWidget,
//         ),
//       );
//     }

//     return Semantics(
//       label: widget.semanticsLabel ?? 'Gradient pin input field',
//       child: pinputWidget,
//     );
//   }

//   Widget _buildErrorText() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       padding: EdgeInsets.only(left: context.spacing.xs),
//       child: Row(
//         children: [
//           TweenAnimationBuilder<double>(
//             tween: Tween<double>(begin: 0, end: 1),
//             duration: const Duration(milliseconds: 300),
//             builder: (context, value, child) {
//               return Transform.scale(
//                 scale: value,
//                 child: Icon(
//                   Icons.error_outline_rounded,
//                   size: 18.sp,
//                   color: context.colors.error,
//                 ),
//               );
//             },
//           ),
//           context.spacing.horizontalGapXS,
//           Expanded(
//             child: Text(
//               widget.errorText ?? 'Please check your input',
//               style: context.bodySmall?.copyWith(
//                 color: context.colors.error,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
