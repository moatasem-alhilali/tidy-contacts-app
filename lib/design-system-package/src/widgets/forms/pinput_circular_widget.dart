// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
// import 'package:purnameg/core/extension/theme_extensions.dart';

// /// A circular pinput widget with beautiful circular design.
// ///
// /// Features:
// /// - Circular pin fields
// /// - Ripple animations
// /// - Bounce effects
// /// - Theme-aware styling
// /// - Advanced animations
// /// - Accessibility support
// /// - SMS autofill support
// /// - Customizable sizes and colors
// class PinputCircularWidget extends StatefulWidget {
//   const PinputCircularWidget({
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
//     this.animationDuration = const Duration(milliseconds: 300),
//     this.animationCurve = Curves.elasticOut,
//     this.enableRippleEffect = true,
//     this.enableBounceEffect = true,
//     this.enableRotationEffect = false,
//     this.circleSize = 56.0,
//     this.customTextStyle,
//     this.fillColor,
//     this.focusedFillColor,
//     this.submittedFillColor,
//     this.errorFillColor,
//     this.borderColor,
//     this.focusedBorderColor,
//     this.errorBorderColor,
//     this.borderWidth = 2.0,
//     this.enableHapticFeedback = true,
//     this.enableGlowEffect = true,
//     this.glowColor,
//     this.pinSpacing = 12.0,
//     this.obscuringCharacter = '●',
//     this.enableSuggestions = true,
//     this.enablePulseAnimation = true,
//     this.enableScaleAnimation = true,
//     this.customShadows,
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

//   /// Whether to enable ripple effect.
//   final bool enableRippleEffect;

//   /// Whether to enable bounce effect.
//   final bool enableBounceEffect;

//   /// Whether to enable rotation effect.
//   final bool enableRotationEffect;

//   /// Size of circular pin fields.
//   final double circleSize;

//   /// Custom text style.
//   final TextStyle? customTextStyle;

//   /// Fill color for pin fields.
//   final Color? fillColor;

//   /// Fill color for focused pin fields.
//   final Color? focusedFillColor;

//   /// Fill color for submitted pin fields.
//   final Color? submittedFillColor;

//   /// Fill color for error pin fields.
//   final Color? errorFillColor;

//   /// Border color for pin fields.
//   final Color? borderColor;

//   /// Border color for focused pin fields.
//   final Color? focusedBorderColor;

//   /// Border color for error pin fields.
//   final Color? errorBorderColor;

//   /// Border width for pin fields.
//   final double borderWidth;

//   /// Whether to enable haptic feedback.
//   final bool enableHapticFeedback;

//   /// Whether to enable glow effect.
//   final bool enableGlowEffect;

//   /// Custom glow color.
//   final Color? glowColor;

//   /// Spacing between pin fields.
//   final double pinSpacing;

//   /// Character to use for obscuring.
//   final String obscuringCharacter;

//   /// Whether to enable suggestions.
//   final bool enableSuggestions;

//   /// Whether to enable pulse animation.
//   final bool enablePulseAnimation;

//   /// Whether to enable scale animation.
//   final bool enableScaleAnimation;

//   /// Custom shadows for pin fields.
//   final List<BoxShadow>? customShadows;

//   @override
//   State<PinputCircularWidget> createState() => _PinputCircularWidgetState();
// }

// class _PinputCircularWidgetState extends State<PinputCircularWidget>
//     with TickerProviderStateMixin {
//   late TextEditingController _controller;
//   late FocusNode _focusNode;
//   late AnimationController _rippleController;
//   late AnimationController _bounceController;
//   late AnimationController _rotationController;
//   late AnimationController _pulseController;
//   late AnimationController _glowController;
//   late Animation<double> _rippleAnimation;
//   late Animation<double> _bounceAnimation;
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _glowAnimation;
//   bool _hasError = false;
//   // Removed unused field _isCompleted
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//     _focusNode = widget.focusNode ?? FocusNode();

//     // Setup ripple animation
//     _rippleController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _rippleAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _rippleController,
//         curve: Curves.easeOutCirc,
//       ),
//     );

//     // Setup bounce animation
//     _bounceController = AnimationController(
//       duration: widget.animationDuration,
//       vsync: this,
//     );
//     _bounceAnimation = Tween<double>(
//       begin: 1,
//       end: 1.2,
//     ).animate(
//       CurvedAnimation(
//         parent: _bounceController,
//         curve: widget.animationCurve,
//       ),
//     );

//     // Setup rotation animation
//     _rotationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _rotationAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _rotationController,
//         curve: Curves.elasticOut,
//       ),
//     );

//     // Setup pulse animation
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _pulseAnimation = Tween<double>(
//       begin: 1,
//       end: 1.1,
//     ).animate(
//       CurvedAnimation(
//         parent: _pulseController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Setup glow animation
//     _glowController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//     _glowAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _glowController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Listen to changes
//     _controller.addListener(_onTextChanged);
//     _focusNode.addListener(_onFocusChanged);

//     // Start pulse animation if enabled
//     if (widget.enablePulseAnimation) {
//       _pulseController.repeat(reverse: true);
//     }
//   }

//   @override
//   void dispose() {
//     _rippleController.dispose();
//     _bounceController.dispose();
//     _rotationController.dispose();
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

//   void _onTextChanged() {
//     if (mounted) {
//       final newIndex = _controller.text.length;
//       if (newIndex > _currentIndex) {
//         // Character added
//         if (widget.enableRippleEffect) {
//           _rippleController.forward().then((_) {
//             _rippleController.reset();
//           });
//         }
//         if (widget.enableBounceEffect) {
//           _bounceController.forward().then((_) {
//             _bounceController.reverse();
//           });
//         }
//         if (widget.enableRotationEffect) {
//           _rotationController.forward().then((_) {
//             _rotationController.reset();
//           });
//         }
//       }

//       setState(() {
//         _hasError = false;
//         // _isCompleted removed as it was only set but never used
//         _currentIndex = newIndex;
//       });
//     }
//   }

//   void _onFocusChanged() {
//     if (_focusNode.hasFocus) {
//       if (widget.enableGlowEffect) {
//         _glowController.forward();
//       }
//     } else {
//       if (widget.enableGlowEffect) {
//         _glowController.reverse();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _rippleController,
//         _bounceController,
//         _rotationController,
//         _pulseController,
//         _glowController,
//       ]),
//       builder: (context, child) {
//         return Transform.scale(
//           scale: widget.enableScaleAnimation && widget.enablePulseAnimation
//               ? _pulseAnimation.value
//               : 1.0,
//           child: Container(
//             decoration: widget.enableGlowEffect
//                 ? BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: (widget.glowColor ?? context.colors.primary)
//                             .withValues(alpha: 0.3 * _glowAnimation.value),
//                         blurRadius: 24.r * _glowAnimation.value,
//                         spreadRadius: 8.r * _glowAnimation.value,
//                       ),
//                     ],
//                   )
//                 : null,
//             child: Column(
//               children: [
//                 _buildPinput(),
//                 if (widget.errorText != null || _hasError) ...[
//                   context.spacing.verticalGapMD,
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
//     final circleSize = widget.circleSize.w;
//     final fillColor = widget.fillColor ?? context.colors.surface;
//     final focusedFillColor =
//         widget.focusedFillColor ?? context.colors.primaryContainer;
//     final submittedFillColor =
//         widget.submittedFillColor ?? context.colors.primary;
//     final errorFillColor =
//         widget.errorFillColor ?? context.colors.errorContainer;
//     final borderColor = widget.borderColor ?? context.colors.outline;
//     final focusedBorderColor =
//         widget.focusedBorderColor ?? context.colors.primary;
//     final errorBorderColor = widget.errorBorderColor ?? context.colors.error;

//     final defaultPinTheme = PinTheme(
//       width: circleSize,
//       height: circleSize,
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onSurface,
//             fontSize: 20.sp,
//           ),
//       decoration: BoxDecoration(
//         color: fillColor,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: widget.borderWidth.w,
//         ),
//         boxShadow: widget.customShadows ?? context.shadows.medium,
//       ),
//       margin: EdgeInsets.symmetric(horizontal: widget.pinSpacing / 2),
//     );

//     final focusedPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         color: focusedFillColor,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: focusedBorderColor,
//           width: (widget.borderWidth * 1.5).w,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: focusedBorderColor.withValues(alpha: 0.3),
//             blurRadius: 12.r,
//             offset: const Offset(0, 4),
//           ),
//           BoxShadow(
//             color: focusedBorderColor.withValues(alpha: 0.1),
//             blurRadius: 24.r,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onPrimaryContainer,
//             fontSize: 20.sp,
//           ),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         color: submittedFillColor,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: submittedFillColor,
//           width: widget.borderWidth.w,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: submittedFillColor.withValues(alpha: 0.4),
//             blurRadius: 8.r,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onPrimary,
//             fontSize: 20.sp,
//           ),
//     );

//     final errorPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         color: errorFillColor,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: errorBorderColor,
//           width: (widget.borderWidth * 1.5).w,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: errorBorderColor.withValues(alpha: 0.3),
//             blurRadius: 12.r,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onErrorContainer,
//             fontSize: 20.sp,
//           ),
//     );

//     final followingPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         color: fillColor.withValues(alpha: 0.5),
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor.withValues(alpha: 0.5),
//           width: widget.borderWidth.w,
//         ),
//         boxShadow: widget.customShadows ?? context.shadows.small,
//       ),
//       textStyle: widget.customTextStyle ??
//           context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: context.colors.onSurface.withValues(alpha: 0.6),
//             fontSize: 20.sp,
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
//       obscuringCharacter: widget.obscuringCharacter,
//       readOnly: widget.readOnly,
//       autofocus: widget.autofocus,
//       pinputAutovalidateMode: widget.autovalidateMode,
//       hapticFeedbackType: widget.hapticFeedbackType,
//       closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
//       useNativeKeyboard: widget.useNativeKeyboard,
//       showCursor: false, // Hide default cursor for circular design
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
//       enableSuggestions: widget.enableSuggestions,
//     );

//     // Add ripple effect overlay if enabled
//     if (widget.enableRippleEffect) {
//       return Stack(
//         alignment: Alignment.center,
//         children: [
//           pinputWidget,
//           if (_rippleAnimation.value > 0)
//             Positioned(
//               child: Container(
//                 width: circleSize * 2 * _rippleAnimation.value,
//                 height: circleSize * 2 * _rippleAnimation.value,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: focusedBorderColor.withValues(
//                       alpha: (1 - _rippleAnimation.value) * 0.5,
//                     ),
//                     width: 2.w,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       );
//     }

//     // Add rotation effect if enabled
//     if (widget.enableRotationEffect) {
//       return Transform.rotate(
//         angle: _rotationAnimation.value * 0.1,
//         child: pinputWidget,
//       );
//     }

//     // Add bounce effect if enabled
//     if (widget.enableBounceEffect) {
//       return Transform.scale(
//         scale: _bounceAnimation.value,
//         child: pinputWidget,
//       );
//     }

//     return Semantics(
//       label: widget.semanticsLabel ?? 'Circular pin input field',
//       child: pinputWidget,
//     );
//   }

//   Widget _buildErrorText() {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(
//         begin: 0,
//         end: _hasError ? 1.0 : 0.0,
//       ),
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.elasticOut,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Opacity(
//             opacity: value,
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: context.spacing.md,
//                 vertical: context.spacing.xs,
//               ),
//               decoration: BoxDecoration(
//                 color: context.colors.errorContainer,
//                 borderRadius: context.radius.borderLarge,
//                 boxShadow: context.shadows.small,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.error_outline_rounded,
//                     size: 18.sp,
//                     color: context.colors.onErrorContainer,
//                   ),
//                   context.spacing.horizontalGapXS,
//                   Flexible(
//                     child: Text(
//                       widget.errorText ?? 'Please check your input',
//                       style: context.bodySmall?.copyWith(
//                         color: context.colors.onErrorContainer,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
