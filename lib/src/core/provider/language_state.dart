import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/src/config/app_routes.dart';
import 'package:hive_manager/src/core/utils/logger.dart';
// import 'package:hive_manager/src/features/auth/data/di/injection_container.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_state.g.dart';

@Riverpod(keepAlive: true)
class LanguageState extends _$LanguageState {
  static const _defaultLanguage = 'ar';

  @override
  String build() {
    final context = Routers.navigatorKey.currentContext;
    final fomartLang = getFormatedLanguage(null);
    if (context != null && context.locale.languageCode != fomartLang) {
      changeLanguageLocal(fomartLang);
    }

    return context?.locale.languageCode ?? _defaultLanguage;
  }

  Future<void> changeLanguageLocal(String value) async {
    try {
      final context = Routers.navigatorKey.currentContext;
      if (context != null && context.locale.languageCode != value) {
        await context.setLocale(Locale(value));
      }

      state = value;
    } catch (e) {
      logger.e('Error changing language: $e');
    }
  }

  Future<void> changeLanguage(String selectedLanguage) async {
    await changeLanguageLocal(selectedLanguage);
    // final user = ref.read(userStateProvider);

    // if (user.value == null) return const Right(null);
    // final authRepository = ref.read(authRepositoryProvider);

    // final either = await authRepository.changeLanguage(selectedLanguage);
    // return either;
  }

  String getFormatedLanguage(String? lang) {
    final normalized = lang?.trim().toLowerCase();
    switch (normalized) {
      case 'ar':
      case 'arabic':
        return 'ar';
      case 'en':
      case 'english':
        return 'en';
      default:
        return _defaultLanguage;
    }
  }
}
