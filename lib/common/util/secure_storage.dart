
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///本地安全存储
class SecureStorage{
  static SecureStorage? _instance;
  SecureStorage._();
  factory SecureStorage() => _instance ??= SecureStorage._();

  final _store = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<void> delete(String key) {
    return _store.delete(key: key);
  }

  Future<void> deleteAll() {
    return _store.deleteAll();
  }

  Future<String?> read(String key) {
    return _store.read(key: key);
  }

  Future<void> write(String key, String value) {
    return _store.write(key: key, value: value);
  }
}