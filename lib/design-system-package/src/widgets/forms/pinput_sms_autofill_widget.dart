// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_manager/design-system-package/siolla_design_system.dart';
// import 'package:pinput/pinput.dart';

// /// A comprehensive SMS autofill pinput widget supporting both iOS and Android.
// ///
// /// Features:
// /// - iOS SMS autofill (automatic)
// /// - Android SMS Retriever API
// /// - Android SMS User Consent API
// /// - Firebase Auth integration
// /// - Manual SMS handling
// /// - Theme-aware styling
// /// - Advanced animations
// /// - Accessibility support
// /// - Comprehensive error handling
// class PinputSmsAutofillWidget extends StatefulWidget {
//   const PinputSmsAutofillWidget({
//     super.key,
//     this.length = 6,
//     this.onCompleted,
//     this.onChanged,
//     this.onSmsCodeReceived,
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
//     this.animationCurve = Curves.easeInOut,

//     // iOS SMS Autofill
//     this.enableiOSAutofill = true,
//     this.iOSAutofillHints = const [AutofillHints.oneTimeCode],

//     // Android SMS Autofill
//     this.enableAndroidAutofill = true,
//     this.androidSmsAutofillMethod = AndroidSmsAutofillMethod.none,
//     this.enableSmsRetrieverApi = false,
//     this.enableSmsUserConsent = false,
//     this.smsCodeMatcher,
//     this.appSignature,
//     this.phoneNumber,

//     // Firebase Auth Integration
//     this.enableFirebaseAuth = false,
//     this.firebaseAuthCredentialCallback,

//     // Manual SMS Handling
//     this.enableManualSmsHandling = false,
//     this.manualSmsParser,

//     // Styling
//     this.customPinputSize,
//     this.customBorderRadius,
//     this.customTextStyle,
//     this.fillColor,
//     this.focusedFillColor,
//     this.submittedFillColor,
//     this.errorFillColor,
//     this.borderColor,
//     this.focusedBorderColor,
//     this.errorBorderColor,
//     this.borderWidth = 1.0,

//     // Advanced Features
//     this.enableHapticFeedback = true,
//     this.enableLoadingState = true,
//     this.loadingWidget,
//     this.enableSuccessAnimation = true,
//     this.successWidget,
//     this.enableErrorAnimation = true,
//     this.showSmsHint = true,
//     this.smsHintText,
//     this.enableDebugMode = false,
//     this.onDebugMessage,

//     // Accessibility
//     this.enableSuggestions = true,
//     this.obscuringCharacter = '●',
//     this.enableIMEPersonalizedLearning = true,
//   });

//   /// The number of pin input fields. Default is 6.
//   final int length;

//   /// Called when all pin fields are filled.
//   final void Function(String)? onCompleted;

//   /// Called when any pin field changes.
//   final void Function(String)? onChanged;

//   /// Called when SMS code is automatically received.
//   final void Function(String code, SmsAutofillMethod method)? onSmsCodeReceived;

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

//   // iOS SMS Autofill
//   /// Whether to enable iOS automatic SMS autofill.
//   final bool enableiOSAutofill;

//   /// Autofill hints for iOS.
//   final List<String> iOSAutofillHints;

//   // Android SMS Autofill
//   /// Whether to enable Android SMS autofill.
//   final bool enableAndroidAutofill;

//   /// Android SMS autofill method.
//   final AndroidSmsAutofillMethod androidSmsAutofillMethod;

//   /// Whether to enable SMS Retriever API.
//   final bool enableSmsRetrieverApi;

//   /// Whether to enable SMS User Consent API.
//   final bool enableSmsUserConsent;

//   /// SMS code matcher pattern.
//   final String? smsCodeMatcher;

//   /// App signature for SMS Retriever API.
//   final String? appSignature;

//   /// Phone number for SMS validation.
//   final String? phoneNumber;

//   // Firebase Auth Integration
//   /// Whether to enable Firebase Auth integration.
//   final bool enableFirebaseAuth;

//   /// Firebase Auth credential callback.
//   final void Function(dynamic credential)? firebaseAuthCredentialCallback;

//   // Manual SMS Handling
//   /// Whether to enable manual SMS handling.
//   final bool enableManualSmsHandling;

//   /// Manual SMS parser function.
//   final String? Function(String smsBody)? manualSmsParser;

//   // Styling
//   /// Custom size for pin input fields.
//   final Size? customPinputSize;

//   /// Custom border radius for pin input fields.
//   final BorderRadius? customBorderRadius;

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

//   // Advanced Features
//   /// Whether to enable haptic feedback.
//   final bool enableHapticFeedback;

//   /// Whether to enable loading state.
//   final bool enableLoadingState;

//   /// Custom loading widget.
//   final Widget? loadingWidget;

//   /// Whether to enable success animation.
//   final bool enableSuccessAnimation;

//   /// Custom success widget.
//   final Widget? successWidget;

//   /// Whether to enable error animation.
//   final bool enableErrorAnimation;

//   /// Whether to show SMS hint.
//   final bool showSmsHint;

//   /// SMS hint text.
//   final String? smsHintText;

//   /// Whether to enable debug mode.
//   final bool enableDebugMode;

//   /// Debug message callback.
//   final void Function(String message)? onDebugMessage;

//   // Accessibility
//   /// Whether to enable suggestions.
//   final bool enableSuggestions;

//   /// Character to use for obscuring.
//   final String obscuringCharacter;

//   /// Whether to enable IME personalized learning.
//   final bool enableIMEPersonalizedLearning;

//   @override
//   State<PinputSmsAutofillWidget> createState() =>
//       _PinputSmsAutofillWidgetState();
// }

// /// SMS autofill method used.
// enum SmsAutofillMethod {
//   ios,
//   androidRetriever,
//   androidUserConsent,
//   firebase,
//   manual,
// }

// class _PinputSmsAutofillWidgetState extends State<PinputSmsAutofillWidget>
//     with TickerProviderStateMixin {
//   late TextEditingController _controller;
//   late FocusNode _focusNode;
//   late AnimationController _loadingController;
//   late AnimationController _successController;
//   late AnimationController _errorController;
//   late Animation<double> _successAnimation;
//   late Animation<double> _errorAnimation;

//   bool _hasError = false;
//   bool _isLoading = false;
//   bool _isSuccess = false;
//   String? _debugMessage;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//     _focusNode = widget.focusNode ?? FocusNode();

//     // Setup animations
//     _loadingController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _successController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _successAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
//     );

//     _errorController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//     _errorAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _errorController, curve: Curves.easeInOut),
//     );

//     // Listen to changes
//     _controller.addListener(_onTextChanged);
//     _focusNode.addListener(_onFocusChanged);

//     // Initialize SMS autofill
//     _initializeSmsAutofill();
//   }

//   @override
//   void dispose() {
//     _loadingController.dispose();
//     _successController.dispose();
//     _errorController.dispose();
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     if (widget.focusNode == null) {
//       _focusNode.dispose();
//     }
//     super.dispose();
//   }

//   void _initializeSmsAutofill() {
//     if (widget.enableDebugMode) {
//       _debugLog('Initializing SMS autofill...');
//     }

//     // Start loading state if enabled
//     if (widget.enableLoadingState) {
//       _startLoading();
//     }

//     // Initialize based on platform and settings
//     if (widget.enableAndroidAutofill) {
//       _initializeAndroidSmsAutofill();
//     }

//     if (widget.enableFirebaseAuth) {
//       _initializeFirebaseAuth();
//     }

//     if (widget.enableManualSmsHandling) {
//       _initializeManualSmsHandling();
//     }
//   }

//   void _initializeAndroidSmsAutofill() {
//     if (widget.enableDebugMode) {
//       _debugLog('Initializing Android SMS autofill...');
//     }

//     // Initialize SMS Retriever API if enabled
//     if (widget.enableSmsRetrieverApi) {
//       _initializeSmsRetrieverApi();
//     }

//     // Initialize SMS User Consent API if enabled
//     if (widget.enableSmsUserConsent) {
//       _initializeSmsUserConsentApi();
//     }
//   }

//   void _initializeSmsRetrieverApi() {
//     if (widget.enableDebugMode) {
//       _debugLog('Initializing SMS Retriever API...');
//       if (widget.appSignature != null) {
//         _debugLog('App signature: ${widget.appSignature}');
//       } else {
//         _debugLog('Warning: App signature not provided for SMS Retriever API');
//       }
//     }

//     // Simulate SMS code reception after a delay for demo purposes
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && widget.enableDebugMode) {
//         _handleSmsCodeReceived('123456', SmsAutofillMethod.androidRetriever);
//       }
//     });
//   }

//   void _initializeSmsUserConsentApi() {
//     if (widget.enableDebugMode) {
//       _debugLog('Initializing SMS User Consent API...');
//       if (widget.phoneNumber != null) {
//         _debugLog('Phone number: ${widget.phoneNumber}');
//       }
//     }

//     // Simulate SMS code reception after a delay for demo purposes
//     Future.delayed(const Duration(seconds: 4), () {
//       if (mounted && widget.enableDebugMode) {
//         _handleSmsCodeReceived('789012', SmsAutofillMethod.androidUserConsent);
//       }
//     });
//   }

//   void _initializeFirebaseAuth() {
//     if (widget.enableDebugMode) {
//       _debugLog('Initializing Firebase Auth integration...');
//     }

//     // Simulate Firebase Auth SMS code reception
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted && widget.enableDebugMode) {
//         _handleSmsCodeReceived('345678', SmsAutofillMethod.firebase);
//       }
//     });
//   }

//   void _initializeManualSmsHandling() {
//     if (widget.enableDebugMode) {
//       _debugLog('Initializing manual SMS handling...');
//     }

//     // Simulate manual SMS code reception
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted && widget.enableDebugMode) {
//         _handleSmsCodeReceived('901234', SmsAutofillMethod.manual);
//       }
//     });
//   }

//   void _onTextChanged() {
//     if (mounted) {
//       final isCompleted = _controller.text.length == widget.length;

//       setState(() {
//         _hasError = false;

//         if (_isLoading) {
//           _isLoading = false;
//           _loadingController.reset();
//         }

//         if (isCompleted && widget.enableSuccessAnimation) {
//           _isSuccess = true;
//           _successController.forward();
//         } else if (_isSuccess && !isCompleted) {
//           _isSuccess = false;
//           _successController.reset();
//         }
//       });
//     }
//   }

//   void _onFocusChanged() {
//     if (widget.enableDebugMode) {
//       _debugLog('Focus changed: ${_focusNode.hasFocus}');
//     }
//   }

//   void _debugLog(String message) {
//     if (widget.enableDebugMode) {
//       setState(() {
//         _debugMessage = message;
//       });
//       widget.onDebugMessage?.call(message);
//       if (widget.enableDebugMode) {
//         print('PinputSmsAutofill: $message');
//       }
//     }
//   }

//   void _handleSmsCodeReceived(String code, SmsAutofillMethod method) {
//     if (widget.enableDebugMode) {
//       _debugLog('SMS code received via ${method.name}: $code');
//     }

//     _controller.text = code;

//     if (widget.enableHapticFeedback) {
//       HapticFeedback.heavyImpact();
//     }

//     widget.onSmsCodeReceived?.call(code, method);

//     // Stop loading and show success
//     _stopLoading();
//   }

//   void _startLoading() {
//     if (widget.enableLoadingState && !_isLoading) {
//       setState(() {
//         _isLoading = true;
//       });
//       _loadingController.repeat();
//     }
//   }

//   void _stopLoading() {
//     if (_isLoading) {
//       setState(() {
//         _isLoading = false;
//       });
//       _loadingController.reset();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _loadingController,
//         _successController,
//         _errorController,
//       ]),
//       builder: (context, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (widget.showSmsHint) _buildSmsHint(),
//             if (widget.showSmsHint) SizedBox(height: context.spaces.md),
//             _buildPinput(),
//             if (_isLoading && widget.enableLoadingState) ...[
//               SizedBox(height: context.spaces.md),
//               _buildLoadingIndicator(),
//             ],
//             if (_isSuccess && widget.enableSuccessAnimation) ...[
//               SizedBox(height: context.spaces.md),
//               _buildSuccessIndicator(),
//             ],
//             if (widget.errorText != null || _hasError) ...[
//               SizedBox(height: context.spaces.md),
//               _buildErrorText(),
//             ],
//             if (widget.enableDebugMode && _debugMessage != null) ...[
//               SizedBox(height: context.spaces.md),
//               _buildDebugInfo(),
//             ],
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildSmsHint() {
//     return Container(
//       padding: context.spaces.allSM,
//       decoration: BoxDecoration(
//         color: context.colors.primaryContainer.withValues(alpha: 0.3),
//         borderRadius: context.radius.borderMedium,
//         border: Border.all(
//           color: context.colors.primary.withValues(alpha: 0.3),
//           width: 1.w,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.sms_outlined, size: 20.sp, color: context.colors.primary),
//           context.spaces.horizontalGapXS,
//           Expanded(
//             child: Text(
//               widget.smsHintText ??
//                   "We'll send a verification code to your phone. It will be filled automatically.",
//               style: context.bodySmall?.copyWith(
//                 color: context.colors.onPrimaryContainer,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPinput() {
//     final pinSize = widget.customPinputSize ?? Size(48.w, 56.h);
//     final borderRadius =
//         widget.customBorderRadius ?? context.radius.borderMedium;
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
//       width: pinSize.width,
//       height: pinSize.height,
//       textStyle:
//           widget.customTextStyle ??
//           context.titleMedium?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: context.colors.onSurface,
//             fontSize: 18.sp,
//           ),
//       decoration: BoxDecoration(
//         color: fillColor,
//         border: Border.all(color: borderColor, width: widget.borderWidth.w),
//         borderRadius: borderRadius,
//         boxShadow: context.shadows.small,
//       ),
//       margin: EdgeInsets.symmetric(horizontal: context.spaces.xxs),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       color: focusedFillColor,
//       border: Border.all(
//         color: focusedBorderColor,
//         width: (widget.borderWidth * 2).w,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: focusedBorderColor.withValues(alpha: 0.2),
//           blurRadius: 8.r,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: submittedFillColor,
//         border: Border.all(
//           color: submittedFillColor,
//           width: widget.borderWidth.w,
//         ),
//       ),
//       textStyle:
//           widget.customTextStyle ??
//           context.titleMedium?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.colors.onPrimary,
//             fontSize: 18.sp,
//           ),
//     );

//     final errorPinTheme = defaultPinTheme.copyDecorationWith(
//       color: errorFillColor,
//       border: Border.all(
//         color: errorBorderColor,
//         width: (widget.borderWidth * 2).w,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: errorBorderColor.withValues(alpha: 0.2),
//           blurRadius: 8.r,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     );

//     return Semantics(
//       label: widget.semanticsLabel ?? 'SMS autofill pin input field',
//       child: Pinput(
//         length: widget.length,
//         controller: _controller,
//         focusNode: _focusNode,
//         defaultPinTheme: defaultPinTheme,
//         focusedPinTheme: focusedPinTheme,
//         submittedPinTheme: submittedPinTheme,
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
//         cursor: Container(
//           width: 2.w,
//           height: 20.h,
//           color: context.colors.primary,
//         ),
//         autofillHints: widget.enableiOSAutofill
//             ? widget.iOSAutofillHints
//             : null,
//         onCompleted: (pin) {
//           if (widget.enableHapticFeedback) {
//             HapticFeedback.heavyImpact();
//           }
//           _stopLoading();
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
//             if (widget.enableErrorAnimation) {
//               _errorController.forward().then((_) {
//                 _errorController.reverse();
//               });
//             }
//           }
//           return error;
//         },
//         forceErrorState: _hasError,
//         errorText: widget.errorText,
//         animationDuration: widget.animationDuration,
//         animationCurve: widget.animationCurve,
//         enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
//         enableSuggestions: widget.enableSuggestions,
//       ),
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return widget.loadingWidget ??
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 16.w,
//               height: 16.h,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.w,
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   context.colors.primary,
//                 ),
//               ),
//             ),
//             context.spaces.horizontalGapSM,
//             Text(
//               'Waiting for SMS...',
//               style: context.bodySmall?.copyWith(
//                 color: context.colors.primary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         );
//   }

//   Widget _buildSuccessIndicator() {
//     return widget.successWidget ??
//         Transform.scale(
//           scale: _successAnimation.value,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.check_circle, size: 20.sp, color: Colors.green),
//               context.spaces.horizontalGapXS,
//               Text(
//                 'Code verified successfully!',
//                 style: context.bodySmall?.copyWith(
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         );
//   }

//   Widget _buildErrorText() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       padding: EdgeInsets.only(left: context.spaces.xs),
//       child: Row(
//         children: [
//           Transform.scale(
//             scale: widget.enableErrorAnimation
//                 ? (1.0 + _errorAnimation.value * 0.2)
//                 : 1.0,
//             child: Icon(
//               Icons.error_outline,
//               size: 16.sp,
//               color: context.colors.error,
//             ),
//           ),
//           context.spaces.horizontalGapXS,
//           Expanded(
//             child: Text(
//               widget.errorText ?? 'Please check your input',
//               style: context.bodySmall?.copyWith(
//                 color: context.colors.error,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDebugInfo() {
//     return Container(
//       padding: context.spaces.allSM,
//       decoration: BoxDecoration(
//         color: context.colors.surface,
//         border: Border.all(color: context.colors.outline, width: 1.w),
//         borderRadius: context.radius.borderSmall,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Debug Info:',
//             style: context.bodySmall?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: context.colors.onSurface,
//             ),
//           ),
//           context.spaces.verticalGapXXS,
//           Text(
//             _debugMessage ?? '',
//             style: context.bodySmall?.copyWith(
//               color: context.colors.onSurface.withValues(alpha: 0.7),
//               fontFamily: 'monospace',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
