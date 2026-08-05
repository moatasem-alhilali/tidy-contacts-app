import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';

/// Country configuration for phone number validation
class CountryConfig {
  const CountryConfig({
    required this.isoCode,
    required this.dialCode,
    required this.name,
    required this.nameAr,
    required this.digitCount,
    required this.validStartDigits,
  });
  final String isoCode;
  final String dialCode;
  final String name;
  final String nameAr;
  final int digitCount;
  final List<String> validStartDigits;

  /// Validates a phone number for this country
  bool isValid(String number) {
    if (number.isEmpty) return false;

    final cleanNumber = number.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.length != digitCount) return false;

    if (validStartDigits.isNotEmpty) {
      final hasValidStart = validStartDigits.any(cleanNumber.startsWith);
      if (!hasValidStart) return false;
    }

    return true;
  }
}

/// Supported countries - Easy to add new countries here
class SupportedCountries {
  static const CountryConfig saudiArabia = CountryConfig(
    isoCode: 'SA',
    dialCode: '+966',
    name: 'Saudi Arabia',
    nameAr: 'السعودية',
    digitCount: 9,
    validStartDigits: ['5'], // Saudi mobile numbers start with 5
  );

  // Add new countries here easily:
  static const CountryConfig egypt = CountryConfig(
    isoCode: 'EG',
    dialCode: '+20',
    name: 'Egypt',
    nameAr: 'مصر',
    digitCount: 10,
    validStartDigits: ['1'], // Egyptian mobile numbers start with 1
  );

  // static const CountryConfig uae = CountryConfig(
  //   isoCode: 'AE',
  //   dialCode: '+971',
  //   name: 'UAE',
  //   nameAr: 'الإمارات',
  //   digitCount: 9,
  //   validStartDigits: ['5'], // UAE mobile numbers start with 5
  // );

  /// List of all available countries
  static const List<CountryConfig> all = [
    saudiArabia,
    egypt,
    // Add more countries here as needed
  ];

  /// Get country by ISO code
  static CountryConfig? getByIsoCode(String isoCode) {
    try {
      return all.firstWhere((c) => c.isoCode == isoCode);
    } catch (e) {
      return null;
    }
  }
}

/// Simple phone number model that works with any supported country
class PhoneNumber {
  const PhoneNumber({required this.phoneNumber, required this.country});

  /// Convenience constructor for Saudi Arabia (default)
  factory PhoneNumber.saudiArabia({String phoneNumber = ''}) {
    return PhoneNumber(
      phoneNumber: phoneNumber,
      country: SupportedCountries.saudiArabia,
    );
  }
  final String phoneNumber;
  final CountryConfig country;

  String get dialCode => country.dialCode;
  String get isoCode => country.isoCode;

  /// Returns the full phone number with dial code
  String get fullNumber => '$dialCode$phoneNumber';

  /// Returns if the phone number is valid for its country
  bool get isValid => country.isValid(phoneNumber);

  @override
  String toString() =>
      'PhoneNumber(phoneNumber: $phoneNumber, dialCode: $dialCode, isoCode: $isoCode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber &&
        other.phoneNumber == phoneNumber &&
        other.country.isoCode == country.isoCode;
  }

  @override
  int get hashCode => phoneNumber.hashCode ^ country.isoCode.hashCode;
}

/// Simple and performant phone input widget
/// Supports multiple countries with easy configuration
class PhoneInputWidget extends StatefulWidget {
  const PhoneInputWidget({
    required this.onChanged,
    super.key,
    this.controller,
    this.initialValue,
    this.initialCountry,
    this.hintText = 'رقم الهاتف',
    this.labelText,
    this.isRequired = true,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final CountryConfig? initialCountry;
  final String hintText;
  final String? labelText;
  final bool isRequired;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final FocusNode? focusNode;
  final ValueChanged<PhoneNumber> onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final ValueChanged<PhoneNumber>? onSaved;

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  late TextEditingController _controller;
  late CountryConfig _selectedCountry;
  bool _isOwnController = false;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry ?? SupportedCountries.saudiArabia;

    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
      _isOwnController = true;
    } else {
      _controller = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (_isOwnController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String value) {
    final phoneNumber = PhoneNumber(
      phoneNumber: value,
      country: _selectedCountry,
    );
    widget.onChanged(phoneNumber);
  }

  void _onCountryChanged(CountryConfig? country) {
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        // Clear the input when changing country
        _controller.clear();
      });
      _onTextChanged('');
    }
  }

  String? _defaultValidator(String? value) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return 'رقم الهاتف مطلوب';
    }

    if (value != null && value.isNotEmpty) {
      final cleanNumber = value.replaceAll(RegExp(r'\D'), '');

      if (cleanNumber.isEmpty) {
        return 'أدخل رقم هاتف صحيح';
      }

      if (cleanNumber.length < _selectedCountry.digitCount) {
        return 'رقم الهاتف يجب أن يكون ${_selectedCountry.digitCount} أرقام';
      }

      if (cleanNumber.length > _selectedCountry.digitCount) {
        return 'رقم الهاتف يجب أن يكون ${_selectedCountry.digitCount} أرقام فقط';
      }

      if (_selectedCountry.validStartDigits.isNotEmpty) {
        final hasValidStart = _selectedCountry.validStartDigits.any(
          cleanNumber.startsWith,
        );
        if (!hasValidStart) {
          final validDigits = _selectedCountry.validStartDigits.join(' أو ');
          return 'رقم الهاتف يجب أن يبدأ بـ $validDigits';
        }
      }
    }

    return null;
  }

  Widget _buildCountrySelector() {
    // If only one country is available, don't show selector
    if (SupportedCountries.all.length == 1) {
      return TextWidget(
        _selectedCountry.dialCode,
        style: context.textStyles.headlineXSmall.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    // Show dropdown for multiple countries
    return DropdownButton<CountryConfig>(
      value: _selectedCountry,
      underline: const SizedBox(),
      isDense: true,
      icon: Icon(
        Icons.arrow_drop_down,
        color: context.colors.primary,
        size: 20.w,
      ),
      items: SupportedCountries.all.map((country) {
        return DropdownMenuItem<CountryConfig>(
          value: country,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                country.dialCode,
                style: context.textStyles.headlineXSmall.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              TextWidget(
                country.nameAr,
                style: context.textStyles.bodySmall.copyWith(
                  color: context.colors.onSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: widget.enabled ? _onCountryChanged : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      style: context.textStyles.headlineXSmall.copyWith(
        color: context.colors.primary,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_selectedCountry.digitCount),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: context.textStyles.headlineXSmall.copyWith(
          color: context.colors.onSecondary,
        ),
        labelStyle: context.textStyles.headlineXSmall.copyWith(
          color: context.colors.primary,
        ),
        fillColor: context.colors.secondary,
        filled: true,
        prefixIcon: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          margin: EdgeInsets.only(left: 8.w),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: context.colors.onSecondary.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [_buildCountrySelector()],
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(context.corners.rb),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(context.corners.rb),
          borderSide: BorderSide(color: context.colors.brandColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(context.corners.rb),
          borderSide: BorderSide(color: context.colors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(context.corners.rb),
          borderSide: BorderSide(color: context.colors.error, width: 2),
        ),
      ),
      validator: widget.validator ?? _defaultValidator,
      onChanged: _onTextChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: (value) {
        if (widget.onSaved != null && value != null) {
          widget.onSaved!(
            PhoneNumber(phoneNumber: value, country: _selectedCountry),
          );
        }
      },
    );
  }
}
