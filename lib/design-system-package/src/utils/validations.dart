import 'package:easy_localization/easy_localization.dart';

class Validations {
  factory Validations() => _instance;

  Validations._();

  static final Validations _instance = Validations._();

  static String? validateEmail(String? value) {
    final regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    if (value == null || value.isEmpty || !regExp.hasMatch(value)) {
      return 'email_validation';
    }
    return null;
  }
}
