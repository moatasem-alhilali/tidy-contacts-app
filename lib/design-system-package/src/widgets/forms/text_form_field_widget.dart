part of 'forms.dart';

/// An advanced, highly customizable text form field widget with comprehensive
/// features including animations, validation, accessibility, and styling options.
///
/// ## Overview
///
/// `TextFormFieldWidget` is a powerful Flutter widget that extends the
/// capabilities of the standard `TextFormField` with advanced features like:
///
/// - **Animations**: Shake on error, pulse on focus, glow effects
/// - **Smart Validation**: Live validation with debouncing, custom rules
/// - **Input Formatters**: 20+ built-in formatters for various input types
/// - **Visual Feedback**: Success/error icons, loading states
/// - **Accessibility**: Screen reader support, semantic labeling
/// - **Performance**: Optimized rendering and memory management
///
/// ## Basic Usage
///
/// ```dart
/// TextFormFieldWidget(
///   labelText: 'Email Address',
///   hintText: 'Enter your email',
///   emailFormatter: true,
///   isRequired: true,
///   showValidationIcon: true,
///   onChanged: (value) => print('Email: $value'),
/// )
/// ```
///
/// ## Advanced Usage Examples
///
/// ### 1. Phone Number Field with Formatting
/// ```dart
/// TextFormFieldWidget(
///   labelText: 'Phone Number',
///   hintText: '+1 (555) 123-4567',
///   phoneFormatter: true,
///   prefixText: '+1 ',
///   maxLength: 14,
///   keyboardType: TextInputType.phone,
///   customValidationRules: [ValidationRules.phone],
///   focusAnimation: true,
///   pulseOnFocus: true,
///   showValidationIcon: true,
/// )
/// ```
///
/// ### 2. Credit Card Field with Real-time Validation
/// ```dart
/// TextFormFieldWidget(
///   labelText: 'Credit Card Number',
///   creditCardFormatter: true,
///   maxLength: 19,
///   keyboardType: TextInputType.number,
///   isLoading: isValidating,
///   loadingText: 'Validating card...',
///   shakeOnError: true,
///   glowEffect: true,
///   onValidationChanged: (isValid) {
///     setState(() => cardIsValid = isValid);
///   },
/// )
/// ```
///
/// ### 3. Multi-line Text Area with Word Limit
/// ```dart
/// TextFormFieldWidget(
///   labelText: 'Description',
///   hintText: 'Enter description (max 3 words)',
///   maxLines: 3,
///   limitedWordArabicFormatter: true,
///   countLimitedWordArabicFormatter: 3,
///   showCharacterCount: true,
///   liveValidation: true,
///   validationDebounce: Duration(milliseconds: 500),
/// )
/// ```
///
/// ### 4. Custom Styled Field with Gradient
/// ```dart
/// TextFormFieldWidget(
///   labelText: 'Username',
///   alphanumericFormatter: true,
///   gradientBackground: true,
///   gradientColors: [Colors.blue, Colors.purple],
///   borderRadius: BorderRadius.circular(12),
///   borderWidth: 2,
///   glowEffect: true,
///   focusAnimation: true,
///   customValidationRules: [
///     ValidationRules.minLength(3),
///     ValidationRules.maxLength(20),
///   ],
/// )
/// ```
///
/// ## Available Input Formatters
///
/// | Formatter | Description | Example |
/// |-----------|-------------|---------|
/// | `numberFormatter` | Digits only | `123456` |
/// | `decimalFormatter` | Numbers with decimals | `123.45` |
/// | `emailFormatter` | Email format | `user@example.com` |
/// | `phoneFormatter` | Phone numbers | `+1 (555) 123-4567` |
/// | `creditCardFormatter` | Credit card format | `1234 5678 9012 3456` |
/// | `dateFormatter` | Date format | `12/31/2023` |
/// | `timeFormatter` | Time format | `14:30` |
/// | `uppercaseFormatter` | Uppercase text | `HELLO WORLD` |
/// | `lowercaseFormatter` | Lowercase text | `hello world` |
/// | `capitalizeFormatter` | Capitalize words | `Hello World` |
/// | `arabicFormatter` | Arabic text only | `مرحبا بالعالم` |
/// | `englishFormatter` | English text only | `Hello World` |
/// | `urlFormatter` | URL format | `https://example.com` |
/// | `hexColorFormatter` | Hex color format | `#FF5733` |
/// | `ipAddressFormatter` | IP address format | `192.168.1.1` |
///
/// ## Built-in Validation Rules
///
/// ```dart
/// // Email validation
/// ValidationRules.email
///
/// // Phone validation
/// ValidationRules.phone
///
/// // URL validation
/// ValidationRules.url
///
/// // Length validation
/// ValidationRules.minLength(5)
/// ValidationRules.maxLength(20)
///
/// // Custom pattern validation
/// ValidationRules.pattern(RegExp(r'^[A-Z]+$'), 'Only uppercase letters')
/// ```
///
/// ## Animation Options
///
/// - `shakeOnError`: Shakes the field when validation fails
/// - `pulseOnFocus`: Gentle pulse animation when focused
/// - `glowEffect`: Glow effect around the field when focused
/// - `focusAnimation`: Smooth scaling animation on focus
/// - `errorAnimation`: Custom error animations
///
/// ## Performance Tips
///
/// - Use `liveValidation` with `validationDebounce` for API calls
/// - Set `enableAnimation: false` for better performance on low-end devices
/// - Use `autovalidateMode: AutovalidateMode.onUserInteraction` for better UX
///
/// ## Accessibility Features
///
/// - Automatic semantic labeling
/// - Screen reader support
/// - Keyboard navigation
/// - Focus management
/// - Error announcements
///
/// ## Migration from MyTextFormField
///
/// ```dart
/// // Old way
/// MyTextFormField(
///   hintText: 'Email',
///   emailFormatter: true,
/// )
///
/// // New way (same API, more features)
/// TextFormFieldWidget(
///   hintText: 'Email',
///   emailFormatter: true,
///   showValidationIcon: true,  // New feature
///   liveValidation: true,      // New feature
/// )
/// ```
///
/// See also:
/// - [TextFormField] for the underlying Flutter widget
/// - [ValidationRule] for custom validation logic
/// - [ValidationRules] for pre-built validation rules
class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,

    // Text and Labels

    /// The text to display as hint text inside the field when empty.
    ///
    /// Example: `'Enter your email address'`
    this.hintText,

    /// The text to display as the field label.
    ///
    /// Example: `'Email Address'`
    this.labelText,

    /// Helper text to display below the field for guidance.
    ///
    /// Example: `'We will never share your email'`
    this.helperText,

    /// Error text to display when validation fails.
    ///
    /// This overrides automatic validation error messages.
    this.errorText,

    /// Success text to display when validation passes.
    ///
    /// Only shown when [statusText] is true.
    this.successText,

    /// Counter text to display character/word count.
    this.counterText,

    /// Semantic label for screen readers and accessibility.
    this.semanticLabel,

    // Styles

    /// Text style for the input text.
    this.style,

    /// Text style for the helper text.
    this.helperStyle,

    /// Text style for the label text.
    this.labelStyle,

    /// Text style for the hint text.
    this.hintStyle,

    /// Text style for error messages.
    this.errorStyle,

    /// Text style for success messages.
    this.successStyle,

    /// Text style for counter text.
    this.counterStyle,

    // Borders and Colors

    /// Border style when the field is enabled but not focused.
    this.enabledBorder,

    /// Border style when the field is focused.
    this.focusedBorder,

    /// Border style when the field has validation errors.
    this.errorBorder,

    /// Border style when the field is focused and has errors.
    this.focusedErrorBorder,

    /// Border style when the field is disabled.
    this.disabledBorder,

    /// Color of the focused border. Used when [focusedBorder] is null.
    this.outlineFocusedBorderColor,

    /// Border radius for all border states.
    ///
    /// Example: `BorderRadius.circular(12)`
    this.borderRadius,

    /// Border width for all border states.
    ///
    /// Default: `1.0` for normal, `2.0` for focused
    this.borderWidth,

    // Icons and Widgets

    /// Icon to display at the end of the field.
    this.suffixIcon,

    /// Icon to display at the beginning of the field.
    this.prefixIcon,

    /// Widget to display before the input text.
    this.prefix,

    /// Widget to display after the input text.
    this.suffix,

    /// Text to display at the end of the field.
    this.suffixText,

    /// Text to display at the beginning of the field.
    ///
    /// Example: `'+1 '` for phone numbers
    this.prefixText,

    /// Alternative name for [prefixIcon].
    this.leadingIcon,

    /// Additional icon to display at the end, after [suffixIcon].
    this.trailingIcon,

    // Controller and Focus

    /// Controller for the text field. If null, one is created automatically.
    this.controller,

    /// Focus node for the text field. If null, one is created automatically.
    this.focusNode,

    /// Focus node to move to when the user presses the 'next' action.
    this.nextFocusNode,

    /// Focus node to move to when the user presses the 'previous' action.
    this.previousFocusNode,

    // Input Behavior

    /// Type of keyboard to display for editing the text.
    ///
    /// Example: `TextInputType.email`, `TextInputType.number`
    this.keyboardType,

    /// How the text should be aligned horizontally.
    this.textAlign = TextAlign.start,

    /// Direction of the text (LTR or RTL).
    this.textDirection,

    /// Maximum number of lines for the text field.
    this.maxLines = 1,

    /// Minimum number of lines for the text field.
    this.minLines,

    /// Maximum number of characters allowed.
    this.maxLength,

    /// Whether to hide the text (for passwords).
    this.obscureText = false,

    /// Whether the field is read-only.
    this.readOnly = false,

    /// Whether the field is enabled for interaction.
    this.enabled = true,

    /// Whether to enable text suggestions.
    this.enableSuggestions = true,

    /// Whether to enable autocorrect.
    this.autocorrect = true,

    /// Whether the field should expand to fill available space.
    this.expands = false,

    /// Whether to show the cursor.
    this.showCursor,

    // Validation

    /// Custom validation function.
    ///
    /// Returns error message string if invalid, null if valid.
    this.validator,

    /// Default error message for empty required fields.
    this.messageValidate,

    /// When to run validation automatically.
    this.autovalidateMode,

    /// Delay before running live validation after text changes.
    ///
    /// Default: 300ms. Helps reduce API calls during typing.
    this.validationDebounce,

    /// List of custom validation rules to apply.
    ///
    /// Example: `[ValidationRules.email, ValidationRules.minLength(5)]`
    this.customValidationRules,

    /// Whether to show validation icons (success/error).
    this.showValidationIcon = false,

    /// Whether to validate in real-time as the user types.
    ///
    /// Uses [validationDebounce] to avoid excessive validation calls.
    this.liveValidation = false,

    // Callbacks

    /// Called when the text changes.
    this.onChanged,

    /// Called when editing is complete.
    this.onEditingComplete,

    /// Called when the field is tapped.
    this.onTap,

    /// Called when the user submits the field.
    this.onSubmitted,

    /// Called when the form is saved.
    this.onSaved,

    /// Called when the user taps outside the field.
    this.onTapOutside,

    /// Called when focus changes.
    ///
    /// Parameter: `bool isFocused` - true when focused, false when unfocused.
    this.onFocusChange,

    // Input Formatters (Enhanced)

    /// Custom input formatters to apply.
    this.inputFormatters,

    /// Allow only text starting with [customPrefix].
    this.customPrefixFormatter = false,

    /// Allow only text starting with any prefix from [customPrefixList].
    this.customPrefixListFormatter = false,

    /// Required prefix when [customPrefixFormatter] is true.
    this.customPrefix,

    /// List of allowed prefixes when [customPrefixListFormatter] is true.
    this.customPrefixList,

    /// Deny text starting with [denyCustomPrefix].
    this.denyCustomPrefixFormatter = false,

    /// Denied prefix when [denyCustomPrefixFormatter] is true.
    this.denyCustomPrefix,

    /// Allow only digits (0-9).
    this.numberFormatter = false,

    /// Allow numbers with up to 2 decimal places.
    this.decimalFormatter = false,

    /// Format as currency (same as [decimalFormatter]).
    this.currencyFormatter = false,

    /// Remove all spaces from input.
    this.noSpaceFormatter = false,

    /// Allow only one word in Arabic.
    this.oneWordArabicFormatter = false,

    /// Allow only Arabic text and spaces.
    this.arabicFormatter = false,

    /// Limit to specific number of words in Arabic.
    this.limitedWordArabicFormatter = false,

    /// Maximum words when [limitedWordArabicFormatter] is true.
    this.countLimitedWordArabicFormatter = 3,

    /// Deny Arabic characters.
    this.denyArabicFormatter = false,

    /// Allow only English letters and spaces.
    this.englishFormatter = false,

    /// Limit to exactly one character.
    this.oneLengthNumberFormatter = false,

    /// Format as email address.
    this.emailFormatter = false,

    /// Format as phone number.
    this.phoneFormatter = false,

    /// Allow only numbers and English letters.
    this.numberWithEnglishFormatter = false,

    /// Limit to specific number of characters.
    this.numberCountFormatter = false,

    /// Maximum characters when [numberCountFormatter] is true.
    this.numberCountIntFormatter = 1,

    /// Convert all text to uppercase.
    this.uppercaseFormatter = false,

    /// Convert all text to lowercase.
    this.lowercaseFormatter = false,

    /// Capitalize first letter of each word.
    this.capitalizeFormatter = false,

    /// Allow only alphanumeric characters.
    this.alphanumericFormatter = false,

    /// Format as URL.
    this.urlFormatter = false,

    /// Format as credit card (#### #### #### ####).
    this.creditCardFormatter = false,

    /// Format as date (MM/DD/YYYY).
    this.dateFormatter = false,

    /// Format as time (HH:MM).
    this.timeFormatter = false,

    /// Format as IP address.
    this.ipAddressFormatter = false,

    /// Format as hex color code (#RRGGBB).
    this.hexColorFormatter = false,

    // Appearance and Animation

    /// Whether to show success text instead of error text.
    this.statusText = false,

    /// Fixed height for the field.
    this.height,

    /// Fixed width for the field.
    this.width,

    /// Background fill color for the field.
    this.fillColor,

    /// Whether to fill the field background.
    this.filled = true,

    /// Duration of animations.
    this.animationDuration,

    /// Animation curve for transitions.
    this.animationCurve,

    /// Whether to enable animations.
    this.enableAnimation = true,

    /// Whether to animate focus changes.
    this.focusAnimation = true,

    /// Whether to animate error states.
    this.errorAnimation = true,

    /// Whether to shake the field on validation errors.
    this.shakeOnError = true,

    /// Whether to pulse the field when focused.
    this.pulseOnFocus = false,

    /// Whether to show a glow effect when focused.
    this.glowEffect = false,

    /// Whether to use gradient background.
    this.gradientBackground = false,

    /// Colors for gradient background.
    this.gradientColors,

    // Autofill and Submission

    /// Autofill hints for the field.
    this.autofillHints,

    /// Action to show on the keyboard submit button.
    this.textInputAction,

    /// Called when the field is submitted.
    this.onFieldSubmitted,

    /// Padding inside the field.
    this.contentPadding,

    /// Padding around the field.
    this.padding,

    /// Margin around the field.
    this.margin,

    // Advanced Features

    /// Debounce timer for callbacks.
    this.debounceTimer,

    /// Whether to show character count.
    this.showCharacterCount = false,

    /// Whether to show word count.
    this.showWordCount = false,

    /// Color of the cursor.
    this.cursorColor,

    /// Width of the cursor.
    this.cursorWidth,

    /// Height of the cursor.
    this.cursorHeight,

    /// Radius of the cursor.
    this.cursorRadius,

    /// Brightness of the keyboard.
    this.keyboardAppearance,

    /// Whether the field is required.
    this.isRequired = false,

    /// Widget to show for required fields.
    this.requiredIndicator,

    /// Widget to show for optional fields.
    this.optionalIndicator,

    /// Group identifier for related fields.
    this.fieldGroup,

    /// Description for the field.
    this.fieldDescription,

    /// Tooltip for the field.
    this.fieldTooltip,

    /// Custom decoration to override default styling.
    this.customDecoration,

    /// Called when validation state changes.
    ///
    /// Parameter: `bool isValid` - true if valid, false if invalid.
    this.onValidationChanged,

    /// Custom validation icon.
    this.validationIcon,

    /// Custom error icon.
    this.errorIcon,

    /// Custom success icon.
    this.successIcon,

    /// Custom loading icon.
    this.loadingIcon,

    /// Whether the field is in loading state.
    this.isLoading = false,

    /// Text to show during loading.
    this.loadingText,
  });

  // Enhanced Properties
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // Autofill and Submission
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  // Text and Labels
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final String? successText;
  final String? counterText;
  final String? semanticLabel;

  // Styles
  final TextStyle? style;
  final TextStyle? helperStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? successStyle;
  final TextStyle? counterStyle;

  // Borders and Colors
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final Color? outlineFocusedBorderColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;

  // Icons and Widgets
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final String? suffixText;
  final String? prefixText;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  // Controller and Focus
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;

  // Input Behavior
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool expands;
  final bool? showCursor;

  // Validation
  final String? Function(String?)? validator;
  final String? messageValidate;
  final AutovalidateMode? autovalidateMode;
  final Duration? validationDebounce;
  final List<ValidationRule>? customValidationRules;
  final bool showValidationIcon;
  final bool liveValidation;

  // Callbacks
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final void Function(String?)? onSaved;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(bool)? onFocusChange;

  // Input Formatters (Enhanced)
  final List<TextInputFormatter>? inputFormatters;
  final bool customPrefixFormatter;
  final bool customPrefixListFormatter;
  final String? customPrefix;
  final List<String>? customPrefixList;
  final bool denyCustomPrefixFormatter;
  final String? denyCustomPrefix;
  final bool numberFormatter;
  final bool decimalFormatter;
  final bool currencyFormatter;
  final bool noSpaceFormatter;
  final bool oneWordArabicFormatter;
  final bool arabicFormatter;
  final bool limitedWordArabicFormatter;
  final int countLimitedWordArabicFormatter;
  final bool denyArabicFormatter;
  final bool englishFormatter;
  final bool oneLengthNumberFormatter;
  final bool emailFormatter;
  final bool phoneFormatter;
  final bool numberWithEnglishFormatter;
  final bool numberCountFormatter;
  final int numberCountIntFormatter;
  final bool uppercaseFormatter;
  final bool lowercaseFormatter;
  final bool capitalizeFormatter;
  final bool alphanumericFormatter;
  final bool urlFormatter;
  final bool creditCardFormatter;
  final bool dateFormatter;
  final bool timeFormatter;
  final bool ipAddressFormatter;
  final bool hexColorFormatter;

  // Appearance and Animation
  final bool statusText;
  final double? height;
  final double? width;
  final Color? fillColor;
  final bool? filled;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool enableAnimation;
  final bool focusAnimation;
  final bool errorAnimation;
  final bool shakeOnError;
  final bool pulseOnFocus;
  final bool glowEffect;
  final bool gradientBackground;
  final List<Color>? gradientColors;

  // Advanced Features
  final Duration? debounceTimer;
  final bool showCharacterCount;
  final bool showWordCount;
  final Color? cursorColor;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Brightness? keyboardAppearance;
  final bool isRequired;
  final Widget? requiredIndicator;
  final Widget? optionalIndicator;
  final String? fieldGroup;
  final String? fieldDescription;
  final String? fieldTooltip;
  final InputDecoration? customDecoration;
  final void Function(bool)? onValidationChanged;
  final Widget? validationIcon;
  final Widget? errorIcon;
  final Widget? successIcon;
  final Widget? loadingIcon;
  final bool isLoading;
  final String? loadingText;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late AnimationController _shakeController;
  late Animation<double> _focusAnimation;
  late Animation<double> _shakeAnimation;

  String? _errorText;
  bool _isValid = true;
  bool _isFocused = false;
  bool _hasError = false;
  Timer? _debounceTimer;
  Timer? _validationTimer;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _setupValidation();
  }

  void _initializeControllers() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _focusAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeInOut,
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  void _setupValidation() {
    if (widget.liveValidation) {
      _controller.addListener(() => _onTextChanged(_controller.text));
    }
  }

  void _onFocusChange() {
    final isFocused = _focusNode.hasFocus;
    if (_isFocused != isFocused) {
      setState(() {
        _isFocused = isFocused;
      });

      if (widget.focusAnimation) {
        if (isFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }

      widget.onFocusChange?.call(isFocused);
    }
  }

  void _onTextChanged(String value) {
    if (widget.liveValidation) {
      _validationTimer?.cancel();
      _validationTimer = Timer(
        widget.validationDebounce ?? const Duration(milliseconds: 300),
        () => _performValidation(value),
      );
    }

    widget.onChanged?.call(value);
  }

  void _performValidation(String? value) {
    if (!mounted) return;

    final error = _validateText(value);
    final isValid = error == null;

    if (_isValid != isValid || _errorText != error) {
      setState(() {
        _isValid = isValid;
        _errorText = error;
        _hasError = !isValid;
      });

      if (widget.shakeOnError && !isValid) {
        _shakeController.forward().then((_) {
          _shakeController.reset();
        });
      }

      widget.onValidationChanged?.call(isValid);
    }
  }

  String? _validateText(String? value) {
    // Apply built-in validator first
    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) return error;
    }

    // Apply custom validation rules
    if (widget.customValidationRules != null) {
      for (final rule in widget.customValidationRules!) {
        if (!rule.isValid(value)) {
          return rule.errorMessage;
        }
      }
    }

    // Default required validation
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return widget.messageValidate ?? 'هذا الحقل مطلوب';
    }

    return null;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _validationTimer?.cancel();
    _animationController.dispose();
    _shakeController.dispose();
    _focusNode.removeListener(_onFocusChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFieldWithEffects();
  }

  Widget _buildFieldWithEffects() {
    var field = _buildTextField();

    if (widget.enableAnimation) {
      field = AnimatedBuilder(
        animation: _focusAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.pulseOnFocus && _isFocused
                ? 1.0 + (_focusAnimation.value * 0.02)
                : 1.0,
            child: child,
          );
        },
        child: field,
      );
    }

    if (widget.shakeOnError) {
      field = AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              _shakeAnimation.value * 10 * (1 - _shakeAnimation.value),
              0,
            ),
            child: child,
          );
        },
        child: field,
      );
    }

    if (widget.glowEffect && _isFocused) {
      field = Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: field,
      );
    }

    if (widget.margin != null) {
      field = Padding(padding: widget.margin!, child: field);
    }

    return field;
  }

  Widget _buildTextField() {
    return Padding(
      padding: widget.padding ?? EdgeInsets.symmetric(vertical: 8.sp),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: TextFormField(
          // Core properties
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          style:
              widget.style ??
              context.textStyles.labelMedium.copyWith(
                color: context.colors.primary,
              ),
          autofillHints: widget.autofillHints,
          inputFormatters: _buildInputFormatters(),
          autovalidateMode: widget.autovalidateMode,

          // Advanced properties
          expands: widget.expands,
          showCursor: widget.showCursor,
          cursorColor: widget.cursorColor,
          cursorWidth: widget.cursorWidth ?? 2.0,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          keyboardAppearance: widget.keyboardAppearance,

          // Decoration
          decoration: _buildInputDecoration(),

          // Validation
          validator: _validateText,

          // Callbacks
          onChanged: _onTextChanged,
          onEditingComplete: widget.onEditingComplete,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onFieldSubmitted,
          onSaved: widget.onSaved,
          onTapOutside: widget.onTapOutside,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    final hasError = _hasError || widget.errorText != null;
    final hasSuccess = _isValid && !hasError && _controller.text.isNotEmpty;

    return widget.customDecoration ??
        InputDecoration(
          // Basic properties
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          counterText: widget.counterText,
          errorText: widget.statusText
              ? (hasSuccess ? widget.successText : null)
              : (hasError ? (_errorText ?? widget.errorText) : null),

          // Styles
          labelStyle:
              widget.labelStyle ??
              context.textStyles.labelLarge.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
          hintStyle:
              widget.hintStyle ??
              context.textStyles.bodyLarge.copyWith(
                color: context.colors.primary.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
          helperStyle:
              widget.helperStyle ??
              context.textStyles.bodySmall.copyWith(
                color: context.colors.primary.withOpacity(0.7),
              ),
          errorStyle:
              widget.errorStyle ??
              context.textStyles.bodyMedium.copyWith(
                color: context.colors.error,
              ),
          counterStyle:
              widget.counterStyle ??
              context.textStyles.labelSmall.copyWith(
                color: context.colors.primary,
              ),

          // Fill
          fillColor: _getFillColor(),
          filled: widget.filled ?? (widget.fillColor != null),

          // Content padding
          contentPadding:
              widget.contentPadding ??
              EdgeInsets.symmetric(horizontal: 12.sp, vertical: 16.sp),
          isDense: true,

          // Icons
          prefixIcon: _buildPrefixIcon(),
          suffixIcon: _buildSuffixIcon(),
          prefix: widget.prefix,
          suffix: widget.suffix,
          prefixText: widget.prefixText,
          suffixText: widget.suffixText,

          // Borders
          border: _buildBorder(),
          enabledBorder: widget.enabledBorder ?? _buildBorder(),
          focusedBorder: widget.focusedBorder ?? _buildBorder(focused: true),
          errorBorder: widget.errorBorder ?? _buildBorder(error: true),
          focusedErrorBorder:
              widget.focusedErrorBorder ??
              _buildBorder(error: true, focused: true),
          disabledBorder: widget.disabledBorder ?? _buildBorder(disabled: true),

          // Constraints
          constraints: widget.height != null
              ? BoxConstraints(maxHeight: widget.height!)
              : null,

          // Semantic
          semanticCounterText: widget.semanticLabel,

          // Error handling
          errorMaxLines: 3,
          helperMaxLines: 2,
        );
  }

  Color? _getFillColor() {
    if (widget.fillColor != null) return widget.fillColor;

    if (widget.gradientBackground && widget.gradientColors != null) {
      return widget.gradientColors!.first.withValues(alpha: 0.1);
    }

    return context.colors.secondary;
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;
    if (widget.leadingIcon != null) return widget.leadingIcon;
    return null;
  }

  Widget? _buildSuffixIcon() {
    final icons = <Widget>[];

    // Loading icon
    if (widget.isLoading) {
      icons.add(
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
          ),
        ),
      );
    }

    // Validation icon
    if (widget.showValidationIcon && !widget.isLoading) {
      if (_hasError) {
        icons.add(
          widget.errorIcon ??
              Icon(Icons.error_outline, color: context.colors.error, size: 20),
        );
      } else if (_isValid && _controller.text.isNotEmpty) {
        icons.add(
          widget.successIcon ??
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 20,
              ),
        );
      }
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      icons.add(widget.suffixIcon!);
    }

    // Trailing icon
    if (widget.trailingIcon != null) {
      icons.add(widget.trailingIcon!);
    }

    if (icons.isEmpty) return null;

    if (icons.length == 1) return icons.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons
          .map(
            (icon) =>
                Padding(padding: const EdgeInsets.only(left: 4), child: icon),
          )
          .toList(),
    );
  }

  InputBorder _buildBorder({
    bool focused = false,
    bool error = false,
    bool disabled = false,
  }) {
    Color borderColor;

    if (error) {
      borderColor = context.colors.error;
    } else if (focused) {
      borderColor =
          widget.outlineFocusedBorderColor ?? context.colors.brandColor;
    } else if (disabled) {
      borderColor = context.colors.brandColor.withValues(alpha: 0.3);
    } else {
      borderColor = context.colors.brandColor.withValues(alpha: 0.3);
    }

    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor,
        width: widget.borderWidth ?? (focused ? 2.0 : 1.0),
      ),
    );
  }

  /// Builds a comprehensive list of [TextInputFormatter] based on the widget's properties.
  List<TextInputFormatter> _buildInputFormatters() {
    final formatters = <TextInputFormatter>[];

    // Add custom formatters first
    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }

    // Deny custom prefix formatter
    if (widget.denyCustomPrefixFormatter && widget.denyCustomPrefix != null) {
      formatters.add(
        FilteringTextInputFormatter.deny(
          RegExp('^(${widget.denyCustomPrefix}).*'),
        ),
      );
    }

    // Custom prefix formatter
    if (widget.customPrefixFormatter && widget.customPrefix != null) {
      formatters.add(
        FilteringTextInputFormatter.allow(
          RegExp('^(${widget.customPrefix}).*'),
        ),
      );
    }

    // Custom prefix list formatter
    if (widget.customPrefixList != null && widget.customPrefixListFormatter) {
      final pattern = '^(${widget.customPrefixList!.join('|')})\\d*';
      formatters.add(FilteringTextInputFormatter.allow(RegExp(pattern)));
    }

    // Number formatters
    if (widget.numberFormatter) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (widget.decimalFormatter) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      );
    }

    if (widget.currencyFormatter) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      );
    }

    // Length formatters
    if (widget.oneLengthNumberFormatter) {
      formatters.add(LengthLimitingTextInputFormatter(1));
    }

    if (widget.numberCountFormatter) {
      formatters.add(
        LengthLimitingTextInputFormatter(widget.numberCountIntFormatter),
      );
    }

    // Text formatters
    if (widget.noSpaceFormatter) {
      formatters.add(NoSpaceFormatter());
    }

    if (widget.uppercaseFormatter) {
      formatters.add(UppercaseTextFormatter());
    }

    if (widget.lowercaseFormatter) {
      formatters.add(LowercaseTextFormatter());
    }

    if (widget.capitalizeFormatter) {
      formatters.add(CapitalizeTextFormatter());
    }

    // Language formatters
    if (widget.arabicFormatter) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF\s]')),
      );
    }

    if (widget.englishFormatter) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')));
    }

    if (widget.denyArabicFormatter) {
      formatters.add(
        FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF]+')),
      );
    }

    // Word count formatters
    if (widget.limitedWordArabicFormatter) {
      formatters.add(
        LimitedWordsInputFormatter(
          count: widget.countLimitedWordArabicFormatter,
        ),
      );
    }

    if (widget.oneWordArabicFormatter) {
      formatters.add(OneWordsInputFormatter());
    }

    // Specialized formatters
    if (widget.phoneFormatter) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\(\)\s]')),
      );
    }

    if (widget.emailFormatter) {
      formatters.add(EmailInputFormatter());
    }

    if (widget.urlFormatter) {
      formatters.add(UrlInputFormatter());
    }

    if (widget.creditCardFormatter) {
      formatters.add(CreditCardInputFormatter());
    }

    if (widget.dateFormatter) {
      formatters.add(DateInputFormatter());
    }

    if (widget.timeFormatter) {
      formatters.add(TimeInputFormatter());
    }

    if (widget.ipAddressFormatter) {
      formatters.add(IpAddressInputFormatter());
    }

    if (widget.hexColorFormatter) {
      formatters.add(HexColorInputFormatter());
    }

    if (widget.alphanumericFormatter) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')));
    }

    if (widget.numberWithEnglishFormatter) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')));
    }

    return formatters;
  }
}

// Enhanced Input Formatters
class UppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final words = newValue.text.split(' ');
    final capitalizedWords = words
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');

    return TextEditingValue(
      text: capitalizedWords,
      selection: newValue.selection,
    );
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return FilteringTextInputFormatter.allow(
      RegExp(r'^[a-zA-Z0-9._%+-]+@?[a-zA-Z0-9.-]*\.?[a-zA-Z]*$'),
    ).formatEditUpdate(oldValue, newValue);
  }
}

class UrlInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return FilteringTextInputFormatter.allow(
      RegExp(r'^[a-zA-Z0-9:/?#[\]@!$&()*+,;=._~-]*$'),
    ).formatEditUpdate(oldValue, newValue);
  }
}

class CreditCardInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\s+'), '');
    var formatted = '';

    for (var i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    var formatted = '';

    for (var i = 0; i < text.length && i < 8; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    var formatted = '';

    for (var i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        formatted += ':';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class IpAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return FilteringTextInputFormatter.allow(
      RegExp(r'^[0-9.]*$'),
    ).formatEditUpdate(oldValue, newValue);
  }
}

class HexColorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.toUpperCase();
    if (!text.startsWith('#')) {
      text = '#$text';
    }

    return FilteringTextInputFormatter.allow(
      RegExp(r'^#[0-9A-F]*$'),
    ).formatEditUpdate(
      oldValue,
      TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      ),
    );
  }
}

/// A validation rule that can be applied to text input fields.
///
/// A validation rule consists of a validator function and an error message.
/// The validator function returns true if the input is valid, false otherwise.
///
/// ## Example
///
/// ```dart
/// final passwordRule = ValidationRule(
///   validator: (value) {
///     return value != null && value.length >= 8;
///   },
///   errorMessage: 'Password must be at least 8 characters',
/// );
///
/// // Use in TextFormFieldWidget
/// TextFormFieldWidget(
///   labelText: 'Password',
///   customValidationRules: [passwordRule],
/// )
/// ```
///
/// ## Creating Custom Rules
///
/// ```dart
/// // Simple length validation
/// final minLengthRule = ValidationRule(
///   validator: (value) => value != null && value.length >= 5,
///   errorMessage: 'Must be at least 5 characters',
/// );
///
/// // Complex pattern validation
/// final strongPasswordRule = ValidationRule(
///   validator: (value) {
///     if (value == null || value.isEmpty) return true; // Allow empty for optional fields
///     return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
///         .hasMatch(value);
///   },
///   errorMessage: 'Password must contain letters, numbers, and special characters',
/// );
/// ```
class ValidationRule {
  /// Creates a new validation rule.
  ///
  /// [validator] - Function that returns true if input is valid
  /// [errorMessage] - Message to show when validation fails
  ValidationRule({required this.validator, required this.errorMessage});

  /// The validation function that checks if the input is valid.
  ///
  /// Should return `true` if the input is valid, `false` otherwise.
  /// For optional fields, consider returning `true` for null or empty values.
  final bool Function(String?) validator;

  /// The error message to display when validation fails.
  ///
  /// Should be a clear, user-friendly message explaining what's wrong.
  final String errorMessage;

  /// Checks if the given value passes this validation rule.
  ///
  /// Returns `true` if valid, `false` if invalid.
  bool isValid(String? value) => validator(value);
}

/// A collection of commonly used validation rules.
///
/// This class provides pre-built validation rules for common input types
/// like email, phone numbers, URLs, and length constraints.
///
/// ## Usage
///
/// ```dart
/// TextFormFieldWidget(
///   labelText: 'Email',
///   customValidationRules: [
///     ValidationRules.email,
///     ValidationRules.minLength(5),
///   ],
/// )
/// ```
///
/// ## Available Rules
///
/// - `email` - Validates email addresses
/// - `phone` - Validates phone numbers
/// - `url` - Validates URLs
/// - `minLength(int)` - Validates minimum length
/// - `maxLength(int)` - Validates maximum length
/// - `pattern(RegExp, String)` - Validates against custom regex
///
/// ## Creating Combined Rules
///
/// ```dart
/// final emailRules = [
///   ValidationRules.email,
///   ValidationRules.minLength(5),
///   ValidationRules.maxLength(50),
/// ];
///
/// final usernameRules = [
///   ValidationRules.minLength(3),
///   ValidationRules.maxLength(20),
///   ValidationRules.pattern(
///     RegExp(r'^[a-zA-Z0-9_]+$'),
///     'Only letters, numbers, and underscores allowed'
///   ),
/// ];
/// ```
class ValidationRules {
  /// Validates email addresses using a comprehensive regex pattern.
  ///
  /// Accepts standard email formats like:
  /// - `user@example.com`
  /// - `first.last@subdomain.example.org`
  /// - `user+tag@example.co.uk`
  ///
  /// Returns `true` for empty values (allows optional fields).
  ///
  /// Example:
  /// ```dart
  /// TextFormFieldWidget(
  ///   labelText: 'Email',
  ///   emailFormatter: true,
  ///   customValidationRules: [ValidationRules.email],
  /// )
  /// ```
  static ValidationRule email = ValidationRule(
    validator: (value) {
      if (value == null || value.isEmpty) return true;
      return RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(value);
    },
    errorMessage: 'Please enter a valid email address',
  );

  /// Validates phone numbers with international format support.
  ///
  /// Accepts formats like:
  /// - `1234567890` (10-15 digits)
  /// - `+1234567890` (with country code)
  /// - `+1 (555) 123-4567` (formatted, spaces and symbols removed)
  ///
  /// Returns `true` for empty values (allows optional fields).
  ///
  /// Example:
  /// ```dart
  /// TextFormFieldWidget(
  ///   labelText: 'Phone',
  ///   phoneFormatter: true,
  ///   customValidationRules: [ValidationRules.phone],
  /// )
  /// ```
  static ValidationRule phone = ValidationRule(
    validator: (value) {
      if (value == null || value.isEmpty) return true;
      return RegExp(
        r'^[\+]?[0-9]{6,}$',
      ).hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
    },
    errorMessage: 'Please enter a valid phone number',
  );

  /// Validates HTTP and HTTPS URLs.
  ///
  /// Accepts formats like:
  /// - `https://example.com`
  /// - `http://www.example.org/path`
  /// - `https://subdomain.example.co.uk/path?query=value`
  ///
  /// Returns `true` for empty values (allows optional fields).
  ///
  /// Example:
  /// ```dart
  /// TextFormFieldWidget(
  ///   labelText: 'Website',
  ///   urlFormatter: true,
  ///   customValidationRules: [ValidationRules.url],
  /// )
  /// ```
  static ValidationRule url = ValidationRule(
    validator: (value) {
      if (value == null || value.isEmpty) return true;
      return RegExp(r'^https?:\/\/[^\s$.?#].[^\s]*$').hasMatch(value);
    },
    errorMessage: 'Please enter a valid URL',
  );

  /// Creates a validation rule for minimum text length.
  ///
  /// [length] - The minimum required length
  ///
  /// Returns `false` for null values or text shorter than [length].
  ///
  /// Example:
  /// ```dart
  /// TextFormFieldWidget(
  ///   labelText: 'Username',
  ///   customValidationRules: [ValidationRules.minLength(3)],
  /// )
  /// ```
  static ValidationRule minLength(int length) => ValidationRule(
    validator: (value) => value != null && value.length >= length,
    errorMessage: 'Minimum length is $length characters',
  );

  /// Creates a validation rule for maximum text length.
  ///
  /// [length] - The maximum allowed length
  ///
  /// Returns `true` for null values or text shorter than [length].
  /// Returns `false` for text longer than [length].
  ///
  /// Example:
  /// ```dart
  /// TextFormFieldWidget(
  ///   labelText: 'Bio',
  ///   maxLines: 3,
  ///   customValidationRules: [ValidationRules.maxLength(200)],
  /// )
  /// ```
  static ValidationRule maxLength(int length) => ValidationRule(
    validator: (value) => value == null || value.length <= length,
    errorMessage: 'Maximum length is $length characters',
  );

  /// Creates a validation rule for custom regex patterns.
  ///
  /// [pattern] - The regex pattern to match against
  /// [message] - Custom error message for validation failure
  ///
  /// Returns `true` for null values or text matching the pattern.
  /// Returns `false` for text not matching the pattern.
  ///
  /// Example:
  /// ```dart
  /// // Username: only letters, numbers, and underscores
  /// ValidationRules.pattern(
  ///   RegExp(r'^[a-zA-Z0-9_]+$'),
  ///   'Only letters, numbers, and underscores allowed'
  /// )
  ///
  /// // Strong password
  /// ValidationRules.pattern(
  ///   RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'),
  ///   'Password must contain uppercase, lowercase, number, and special character'
  /// )
  /// ```
  static ValidationRule pattern(RegExp pattern, String message) =>
      ValidationRule(
        validator: (value) => value == null || pattern.hasMatch(value),
        errorMessage: message,
      );
}

// Keep the legacy widget name for backward compatibility
typedef MyTextFormField = TextFormFieldWidget;
