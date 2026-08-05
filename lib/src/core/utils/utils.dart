import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Utils {
  factory Utils() => _instance;

  Utils._();

  static final Utils _instance = Utils._();

  static void disposeKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
  }
}
