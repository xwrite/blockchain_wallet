
import 'package:blockchain_wallet/service/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///本地安全存储服务
class SecureStorageServiceImpl extends SecureStorageService{

  final _store = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> delete(String key) {
    return _store.delete(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _store.deleteAll();
  }

  @override
  Future<String?> read(String key) {
    return _store.read(key: key);
  }

  @override
  Future<void> write(String key, String value) {
    return _store.write(key: key, value: value);
  }
}