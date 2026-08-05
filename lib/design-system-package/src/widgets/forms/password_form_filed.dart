part of 'forms.dart';

class PasswordFormFiled extends StatefulWidget {
  const PasswordFormFiled({
    required this.controller,
    super.key,
    this.hintText,
    this.errorText,
    this.labelText,
    this.helperText,
    this.togglePass = true,
    this.validator,
    this.messageValidate,
    this.textAlign,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    // this.passwordSettings,
    this.displayRequirements = false,
  });

  // final PasswordSettings? passwordSettings;
  final bool displayRequirements;
  final TextEditingController? controller;
  final String? hintText;
  final String? messageValidate;
  final String? errorText;
  final String? labelText;
  final String? helperText;
  final bool togglePass;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PasswordFormFiled> createState() => _PasswordFormFiledState();
}

class _PasswordFormFiledState extends State<PasswordFormFiled> {
  bool showPassword = true;
  ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);
  final String _passwordStrengthMessage = '';
  final Color _strengthColor = Colors.grey;
  bool allRequirementsMet = false;

  final Map<String, bool> _requirementsMet = {
    'uppercase': false,
    'lowercase': false,
    'numeric': false,
    'symbols': false,
    'length': false,
  };
  @override
  void dispose() {
    widget.controller?.dispose();
    widget.focusNode?.dispose();
    isVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldWidget(
          fillColor: context.colors.secondary,
          controller: widget.controller,
          noSpaceFormatter: true,
          messageValidate: widget.messageValidate,
          errorText: widget.errorText,
          denyArabicFormatter: true,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: TextInputType.visiblePassword,

          textInputAction: TextInputAction.done,
          isRequired: true,
          labelText: 'كلمة المرور',
          // labelColumn: widget.labelText,
          hintText: widget.hintText ?? 'ادخل كلمة المرور',
          validator: widget.validator,
          obscureText: widget.togglePass ? showPassword : true,
          helperText: widget.helperText,
          // prefixIcon: const Padding(
          //   padding: EdgeInsets.all(8),
          //   child: ImageWidget('Assets.icons.lock.path'),
          // ),
          autofillHints: const [AutofillHints.password],
          enabledBorder: widget.displayRequirements
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: allRequirementsMet ? Colors.green : Colors.red,
                  ),
                )
              : null,
          focusedBorder: widget.displayRequirements
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: allRequirementsMet ? Colors.green : Colors.red,
                  ),
                )
              : null,
          onChanged: (value) {
            widget.onChanged?.call(value);
            // _handlePasswordChange(value);
          },

          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                key: ValueKey<bool>(showPassword),
                color: context.colors.primary,
                size: 24.sp,
              ),
            ),
          ),
        ),
        if (widget.displayRequirements && widget.controller!.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_passwordStrengthMessage.isNotEmpty)
                  TextWidget(
                    _passwordStrengthMessage,
                    style: TextStyle(color: _strengthColor),
                  ),
                // ..._buildRequirementWidgets(),
              ],
            ),
          ),
      ],
    );
  }
}
