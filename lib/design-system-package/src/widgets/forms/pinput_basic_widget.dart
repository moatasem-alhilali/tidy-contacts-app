part of 'forms.dart';

/// A basic pinput widget with clean, minimal styling.
///
/// Features:
/// - Clean, minimal design
/// - Theme-aware colors
/// - Basic validation
/// - Smooth animations
/// - Accessibility support
/// - SMS autofill support (iOS & Android)
class PinputBasicWidget extends StatefulWidget {
  const PinputBasicWidget({
    super.key,
    this.length = 4,
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
    this.hintText,
    this.autovalidateMode = PinputAutovalidateMode.onSubmit,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
    this.closeKeyboardWhenCompleted = true,
    this.useNativeKeyboard = true,
    this.semanticsLabel,

    // SMS Autofill
    this.enableSmsAutofill = true,
    this.smsAutofillHints = const [AutofillHints.oneTimeCode],
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

  /// Hint text to display in empty pin fields.
  final String? hintText;

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

  /// Whether to enable SMS autofill.
  final bool enableSmsAutofill;

  /// SMS autofill hints for iOS and Android.
  final List<String> smsAutofillHints;

  @override
  State<PinputBasicWidget> createState() => _PinputBasicWidgetState();
}

class _PinputBasicWidgetState extends State<PinputBasicWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    // Listen to controller changes for validation
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPinput(),
        if (widget.errorText != null || _hasError) ...[
          context.spaces.sm.verticalSpace,
          _buildErrorText(),
        ],
      ],
    );
  }

  Widget _buildPinput() {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: context.textStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.onPrimary,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.outline, width: 1.w),
        borderRadius: BorderRadius.all(context.corners.rb),
      ),

      margin: EdgeInsets.symmetric(horizontal: context.spaces.sm),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: context.colors.brandColor, width: 2.w),
      boxShadow: [
        BoxShadow(
          color: context.colors.brandColor.withValues(alpha: 0.1),
          blurRadius: 4.r,
          offset: const Offset(0, 2),
        ),
      ],
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.colors.surface,
        border: Border.all(color: context.colors.brandColor, width: 2.w),
      ),
      textStyle: context.textStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.brandColor,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: context.colors.error, width: 2.w),
      boxShadow: [
        BoxShadow(
          color: context.colors.onError.withValues(alpha: 0.1),
          blurRadius: 4.r,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Semantics(
      label: widget.semanticsLabel ?? 'Pin input field',
      child: Pinput(
        crossAxisAlignment: CrossAxisAlignment.center,
        length: widget.length,
        controller: _controller,
        focusNode: _focusNode,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        enabled: widget.enabled,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        pinputAutovalidateMode: widget.autovalidateMode,
        hapticFeedbackType: widget.hapticFeedbackType,
        closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
        useNativeKeyboard: widget.useNativeKeyboard,
        cursor: Container(
          width: 1.w,
          height: 20.h,
          color: context.colors.brandColor,
        ),
        onCompleted: widget.onCompleted,
        onChanged: widget.onChanged,
        validator: (value) {
          final error = widget.validator?.call(value);
          if (error != null) {
            setState(() {
              _hasError = true;
            });
          }
          return error;
        },
        forceErrorState: _hasError,
        errorText: widget.errorText,
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.easeInOut,
        // SMS Autofill
        autofillHints: widget.enableSmsAutofill
            ? widget.smsAutofillHints
            : null,
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: EdgeInsets.only(left: context.spaces.md),
      child: Text(
        widget.errorText ?? 'Please check your input',
        style: context.textStyles.bodyMedium.copyWith(
          color: context.colors.onError,
        ),
      ),
    );
  }
}
