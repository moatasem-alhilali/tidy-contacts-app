part of 'forms.dart';

/// A rounded filled pinput widget with modern styling.
///
/// Features:
/// - Rounded, filled design
/// - Smooth color transitions
/// - Enhanced visual feedback
/// - Theme-aware styling
/// - Accessibility support
/// - Haptic feedback
/// - SMS autofill support (iOS & Android)
class PinputRoundedFilledWidget extends StatefulWidget {
  const PinputRoundedFilledWidget({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.validator,
    this.enabled = true,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.errorText,
    this.autovalidateMode = PinputAutovalidateMode.onSubmit,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
    this.closeKeyboardWhenCompleted = true,
    this.useNativeKeyboard = true,
    this.semanticsLabel,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOutCubic,
    this.enableSmsRetrieverApi = false,
    this.smsCodeMatcher,
    this.androidSmsAutofillMethod = AndroidSmsAutofillMethod.none,
    this.enableSmsAutofill = true,
    this.smsAutofillHints = const [AutofillHints.oneTimeCode],
    this.enableIMEPersonalizedLearning = true,
    this.obscuringCharacter = '●',
    this.obscuringWidget,
    this.enableSuggestions = true,
    this.isCursorAnimationEnabled = true,
    this.customPinputSize,
    this.customFillColor,
    this.customBorderRadius,
  });

  /// The number of pin input fields. Default is 6.
  final int length;

  /// Called when all pin fields are filled.
  final void Function(String)? onCompleted;

  /// Called when any pin field changes.
  final void Function(String)? onChanged;

  /// Controller for the pin input.
  final TextEditingController? controller;

  /// Focus node for the pin input.
  final FocusNode? focusNode;

  /// Validator function for the pin input.
  final String? Function(String?)? validator;

  /// Whether the pin input is enabled.
  final bool enabled;

  /// Whether to obscure the pin input (for sensitive data).
  final bool obscureText;

  /// Whether the pin input is read-only.
  final bool readOnly;

  /// Whether to auto-focus on the pin input.
  final bool autofocus;

  /// Error text to display below the pin input.
  final String? errorText;

  /// When to automatically validate the pin input.
  final PinputAutovalidateMode autovalidateMode;

  /// Type of haptic feedback to use.
  final HapticFeedbackType hapticFeedbackType;

  /// Whether to close the keyboard when pin is completed.
  final bool closeKeyboardWhenCompleted;

  /// Whether to use native keyboard.
  final bool useNativeKeyboard;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Animation duration for state changes.
  final Duration animationDuration;

  /// Animation curve for state changes.
  final Curve animationCurve;

  /// Whether to enable SMS retriever API.
  final bool enableSmsRetrieverApi;

  /// SMS code matcher for autofill.
  final String? smsCodeMatcher;

  /// Android SMS autofill method.
  final AndroidSmsAutofillMethod androidSmsAutofillMethod;

  /// Whether to enable SMS autofill.
  final bool enableSmsAutofill;

  /// SMS autofill hints for iOS and Android.
  final List<String> smsAutofillHints;

  /// Whether to enable IME personalized learning.
  final bool enableIMEPersonalizedLearning;

  /// Character to use for obscuring.
  final String obscuringCharacter;

  /// Widget to use for obscuring.
  final Widget? obscuringWidget;

  /// Whether to enable suggestions.
  final bool enableSuggestions;

  /// Whether cursor animation is enabled.
  final bool isCursorAnimationEnabled;

  /// Custom size for pin input fields.
  final Size? customPinputSize;

  /// Custom fill color for pin input fields.
  final Color? customFillColor;

  /// Custom border radius for pin input fields.
  final BorderRadius? customBorderRadius;

  @override
  State<PinputRoundedFilledWidget> createState() =>
      _PinputRoundedFilledWidgetState();
}

class _PinputRoundedFilledWidgetState extends State<PinputRoundedFilledWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    // Setup animations
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    // Listen to controller changes for validation
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {
        _hasError = false;
      });
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPinput(),
                if (widget.errorText != null || _hasError) ...[
                  context.spaces.sm.verticalSpace,
                  _buildErrorText(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPinput() {
    final pinSize = widget.customPinputSize ?? Size(200.w, 60.h);
    final fillColor = widget.customFillColor ?? context.colors.surface;
    final borderRadius =
        widget.customBorderRadius ?? BorderRadius.all(context.corners.rb);

    final defaultPinTheme = PinTheme(
      width: pinSize.width,
      height: pinSize.height,
      textStyle: context.textStyles.titleLarge.copyWith(
        fontWeight: FontWeight.w700,
        color: context.colors.onSurface,
        fontSize: 20.sp,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.2),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: context.spaces.md),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: context.colors.onPrimary,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: context.colors.onPrimary.withValues(alpha: 0.2),
          blurRadius: 8.r,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: context.colors.onPrimary.withValues(alpha: 0.1),
          blurRadius: 16.r,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.colors.onPrimary,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: context.colors.onPrimary.withValues(alpha: 0.3),
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: context.textStyles.titleLarge.copyWith(
        fontWeight: FontWeight.w700,
        color: context.colors.onPrimary,
        fontSize: 20.sp,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      color: context.colors.error,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: context.colors.onError.withValues(alpha: 0.2),
          blurRadius: 8.r,
          offset: const Offset(0, 2),
        ),
      ],
    );

    final followingPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: fillColor.withValues(alpha: 0.6),
        borderRadius: borderRadius,
      ),
      textStyle: context.textStyles.titleLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.onSurface.withValues(alpha: 0.7),
        fontSize: 20.sp,
      ),
    );

    return Semantics(
      label: widget.semanticsLabel ?? 'Rounded filled pin input field',
      child: Pinput(
        length: widget.length,
        controller: _controller,
        focusNode: _focusNode,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        followingPinTheme: followingPinTheme,
        errorPinTheme: errorPinTheme,
        enabled: widget.enabled,
        obscureText: widget.obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        obscuringWidget: widget.obscuringWidget,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        pinputAutovalidateMode: widget.autovalidateMode,
        hapticFeedbackType: widget.hapticFeedbackType,
        closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
        useNativeKeyboard: widget.useNativeKeyboard,
        isCursorAnimationEnabled: widget.isCursorAnimationEnabled,
        cursor: Container(
          width: 2.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: context.colors.onPrimary,
            borderRadius: BorderRadius.circular(1.r),
          ),
        ),
        onCompleted: (pin) {
          // Add haptic feedback on completion
          if (widget.hapticFeedbackType != HapticFeedbackType.lightImpact) {
            HapticFeedback.heavyImpact();
          }
          widget.onCompleted?.call(pin);
        },
        onChanged: widget.onChanged,
        validator: (value) {
          final error = widget.validator?.call(value);
          if (error != null) {
            setState(() {
              _hasError = true;
            });
            // Add error haptic feedback
            HapticFeedback.vibrate();
          }
          return error;
        },
        forceErrorState: _hasError,
        errorText: widget.errorText,
        animationDuration: widget.animationDuration,
        animationCurve: widget.animationCurve,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        enableSuggestions: widget.enableSuggestions,
        // SMS Autofill
        autofillHints: widget.enableSmsAutofill
            ? widget.smsAutofillHints
            : null,
      ),
    );
  }

  Widget _buildErrorText() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(left: context.spaces.md),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16.sp, color: context.colors.error),
          context.spaces.md.horizontalSpace,
          Expanded(
            child: Text(
              widget.errorText ?? 'Please check your input',
              style: context.textStyles.bodySmall.copyWith(
                color: context.colors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
