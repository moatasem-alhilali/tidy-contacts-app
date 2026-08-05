import 'package:hive_manager/design-system-package/src/extensions/extensions.dart';
import 'package:hive_manager/design-system-package/src/utils/app_theme_mode.dart';
import 'package:hive_manager/src/core/di/injection_container.dart';
import 'package:hive_manager/src/core/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<AppThemeMode> build() async {
    state = const AsyncData(AppThemeMode.light);
    final stringThemeMode = await ref
        .read(localStorageProvider)
        .get(Constants.get.themeKey);
    final themeMode = AppThemeMode.values.firstWhereOrNull(
      (element) => element.name == stringThemeMode,
    );
    if (themeMode != null) {
      return themeMode;
    }
    return AppThemeMode.light;
  }

  set mode(AppThemeMode value) {
    ref.read(localStorageProvider).insert(Constants.get.themeKey, value.name);
    state = AsyncData(value);
  }
}
