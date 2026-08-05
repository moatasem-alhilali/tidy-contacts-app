import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage({required this.preferences});
  final SharedPreferences preferences;

  Future<void> insert(String key, String value) =>
      preferences.setString(key, value);
  Future<void> insertBool(String key, bool value) =>
      preferences.setBool(key, value);

  Future<void> update(String key, String value) async {
    await delete(key);
    await insert(key, value);
  }

  Future<void> updateBool(String key, bool value) async {
    await delete(key);
    await insertBool(key, value);
  }

  Future<void> delete(String key) async => preferences.remove(key);

  String? get(String key) => preferences.getString(key);
  bool? getBool(String key) => preferences.getBool(key);

  Future<void> clear() => preferences.clear();
}
