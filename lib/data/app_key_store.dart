import 'dart:convert';
import 'dart:typed_data';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:blockchain_wallet/common/util/crypto_util.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/common/util/secure_storage.dart';

///APP密钥存储库
class AppKeyStore {

  static const _kPasswordHash = '_kPasswordHash';
  static const _kPassword = '_kPassword';
  static const _kHasBiometricPassword = '_kHasBiometricPassword';
  static const _kWalletEncryptedData = '_kWalletEncryptedData';
  static const _kEncryptedMnemonic= '_kEncryptedMnemonic';

  final _storage = SecureStorage();

  ///保存钱包助记词
  ///- data 加密助记词
  Future<void> saveEncryptedMnemonic(Uint8List data){
    return _storage.write(_kEncryptedMnemonic, base64Encode(data));
  }

  ///获取钱包助记词
  Future<Uint8List?> getEncryptedMnemonic() async{
    try{
      final data = await _storage.read(_kEncryptedMnemonic);
      if(data != null){
        return base64Decode(data);
      }
    }catch(ex){
      logger.w('获取钱包助记词失败，$ex');
    }
    return null;
  }

  ///是否已设置钱包密码
  Future<bool> hasPassword() async {
    return await _storage.read(_kPasswordHash) != null;
  }

  ///保存钱包密码(hash)
  Future<bool> savePassword(String password) async {
    final value = CryptoUtil.hashPassword(password);
    await _storage.write(_kPasswordHash, value);
    return true;
  }

  ///验证钱包密码
  Future<bool> verifyPassword(String password) async {
    final value = await _storage.read(_kPasswordHash);
    if (value != null) {
      return CryptoUtil.checkPassword(password, value);
    }
    return false;
  }

  ///保存钱包密码(指纹识别)
  ///- return 用户取消返回null，成功返回true，失败返回false
  Future<bool?> savePasswordByBiometric(String password) async {
    try {
      final storage = await BiometricStorage().getStorage(_kPassword);
      await storage.write(password);
      await _storage.write(_kHasBiometricPassword, 'true');
      return true;
    } on AuthException catch (e) {
      logger.d('AuthException: $e');
      if ([
        AuthExceptionCode.canceled,
        AuthExceptionCode.userCanceled,
      ].contains(e.code)) {
        return null;
      }
    }
    return false;
  }

  ///获取钱包密码(指纹识别)
  ///- return 成功返回密码，失败返回null
  Future<String?> getPasswordByBiometric(String password) async {
    try {
      final storage = await BiometricStorage().getStorage(_kPassword);
      return storage.read();
    } on AuthException catch (e) {
      logger.d('AuthException: $e');
    }
    return null;
  }

  ///删除钱包密码(指纹识别)
  Future<bool> deleteBiometricPassword() async {
    try {
      final storage = await BiometricStorage().getStorage(_kPassword);
      await storage.delete();
      await _storage.delete(_kHasBiometricPassword);
      return true;
    } on AuthException catch (e) {
      logger.d('AuthException: $e');
    }
    return false;
  }

  ///是否已设置钱包密码(指纹识别)
  Future<bool> hasBiometricPassword() async {
    return await _storage.read(_kHasBiometricPassword) != null;
  }

  ///保存钱包加密数据
  Future<void> saveWalletEncryptedData(String data) {
    return _storage.write(_kWalletEncryptedData, data);
  }

  ///获取钱包加密数据
  Future<String?> getWalletEncryptedData() {
    return _storage.read(_kWalletEncryptedData);
  }

  ///清空数据
  Future<void> deleteAll(){
    return _storage.deleteAll();
  }

}
