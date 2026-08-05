part of 'forms.dart';

class EmailFormField extends StatefulWidget {
  const EmailFormField({
    required this.controller,
    super.key,
    this.hintText,
    this.errorText,
    this.labelText,
    this.helperText,
    this.validator,
    this.messageValidate,
    this.textAlign,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.displayValidation = false,
    this.isRequired = true,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? messageValidate;
  final String? errorText;
  final String? labelText;
  final String? helperText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool displayValidation;
  final bool isRequired;
  final TextInputAction? textInputAction;

  final void Function(String)? onSubmitted;

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  bool isValidEmail = false;
  String validationMessage = '';
  Color validationColor = Colors.grey;

  @override
  void dispose() {
    widget.controller?.dispose();
    widget.focusNode?.dispose();
    super.dispose();
  }

  void _validateEmail(String email) {
    if (email.isEmpty) {
      setState(() {
        isValidEmail = false;
        validationMessage = '';
        validationColor = Colors.grey;
      });
      return;
    }

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    setState(() {
      isValidEmail = emailRegex.hasMatch(email);
      if (isValidEmail) {
        validationMessage = 'البريد الإلكتروني صحيح';
        validationColor = Colors.green;
      } else {
        validationMessage = 'البريد الإلكتروني غير صحيح';
        validationColor = Colors.red;
      }
    });
  }

  String? _defaultValidator(String? value) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return 'البريد الإلكتروني مطلوب';
    }

    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'يرجى إدخال بريد إلكتروني صحيح';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldWidget(
          fillColor: context.colors.secondary,
          controller: widget.controller,
          messageValidate: widget.messageValidate,
          errorText: widget.errorText,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          isRequired: widget.isRequired,
          labelText: widget.labelText ?? 'البريد الإلكتروني',
          hintText: widget.hintText ?? 'ادخل البريد الإلكتروني',
          validator: widget.validator ?? _defaultValidator,
          helperText: widget.helperText,
          autofillHints: const [AutofillHints.email],
          enabledBorder:
              widget.displayValidation && widget.controller!.text.isNotEmpty
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isValidEmail ? Colors.green : Colors.red,
                  ),
                )
              : null,
          focusedBorder:
              widget.displayValidation && widget.controller!.text.isNotEmpty
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isValidEmail ? Colors.green : Colors.red,
                  ),
                )
              : null,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.displayValidation) {
              _validateEmail(value);
            }
          },
          suffixIcon:
              widget.displayValidation && widget.controller!.text.isNotEmpty
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isValidEmail ? Icons.check_circle : Icons.error,
                    key: ValueKey<bool>(isValidEmail),
                    color: isValidEmail ? Colors.green : Colors.red,
                    size: 24.sp,
                  ),
                )
              : Icon(
                  Icons.email_outlined,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
        ),
        if (widget.displayValidation &&
            widget.controller!.text.isNotEmpty &&
            validationMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  isValidEmail ? Icons.check_circle : Icons.error,
                  color: validationColor,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                TextWidget(
                  validationMessage,
                  style: TextStyle(color: validationColor, fontSize: 12.sp),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
