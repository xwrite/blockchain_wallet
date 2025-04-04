
///本地安全存储服务
abstract class SecureStorageService{
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
}