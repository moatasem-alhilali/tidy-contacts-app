import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_manager/src/core/local/local_storage.dart';

class LocalSecureStorage {
  LocalSecureStorage({required this.localStorage});
  final LocalStorage localStorage;

  final _storage = const FlutterSecureStorage();

  /// this code is for ios persist data
  /// i delete the local storage data if the app run for the first time
  Future<void> init() async {
    final firstRun = localStorage.getBool('first_run');
    if (firstRun == null || firstRun) {
      await _storage.deleteAll();
      await localStorage.updateBool('first_run', false);
    }
  }

  Future<void> insert(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  Future<void> update(String key, String value) async {
    await _storage.delete(key: key);
    return _storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<String?> get(String key) async {
    try {
      final encryptedValue = await _storage.read(key: key);
      if (encryptedValue == null) return null;
      return encryptedValue;
    } catch (e) {
      return null;
    }
  }

  Future<void> clear() async {
    return _storage.deleteAll();
  }
}
