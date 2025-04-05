import 'dart:convert';

import 'package:blockchain_wallet/common/util/encrypt_util.dart';
import 'package:blockchain_wallet/common/util/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

import '../common/util/logger.dart' show logger;

///钱包服务
class WalletService extends GetxService {
  static const _kWalletSecretKeyInfo = '_kWalletSecretKeyInfo';
  static const _kBackupMnemonic = '_kBackupMnemonic';
  var _hasWallet = false;
  final RxBool _isBackupMnemonicRx;

  static SecureStorage get _store => SecureStorage();

  TWHDWallet? _wallet;

  WalletService._(this._hasWallet, bool isBackupMnemonic)
      : _isBackupMnemonicRx = isBackupMnemonic.obs;

  static Future<WalletService> create() async {
    final info = await _store.read(_kWalletSecretKeyInfo);
    final backup = await _store.read(_kBackupMnemonic);
    return WalletService._(info != null, backup != null);
  }

  ///是否已设置钱包
  bool get hasWallet => _hasWallet;

  ///是否已备份助记词
  bool get isBackupMnemonicRx => _isBackupMnemonicRx.value;

  ///钱包是否已打开
  bool get isOpen => _wallet != null;

  ///钱包助记词
  String? get mnemonic => _wallet?.mnemonic;

  ///认证密码是否正确
  Future<bool> authentication(String password) async{
    return await getMnemonic(password) != null;
  }

  ///获取助记词
  Future<String?> getMnemonic(String password) async{
    final infoStr = await _store.read(_kWalletSecretKeyInfo);
    if (infoStr == null) {
      logger.d('钱包不存在');
      return null;
    }
    final info = WalletSecretKeyInfo.fromJsonString(infoStr);
    if (info == null) {
      logger.d('钱包不存在');
      return null;
    }

    return compute((args) {
      final info = args[0] as WalletSecretKeyInfo;
      final password = args[1] as String;
      final passwordBytes = utf8.encode(password);

      //使用密码短语派生AES密钥
      final pbkdf2Salt = EncryptUtil.fromHexString(info.salt);
      final aesKey = EncryptUtil.deriveKeyWithArgon2(
        password: passwordBytes,
        salt: pbkdf2Salt,
        iterations: 3,
      );

      //AES解密助记词
      final aesNonce = EncryptUtil.fromHexString(info.nonce);
      final mnemonicBytes = EncryptUtil.aesGcmDecrypt(
        key: aesKey,
        data: EncryptUtil.fromHexString(info.encryptedMnemonic),
        nonce: aesNonce,
      );
      if (mnemonicBytes == null) {
        return null;
      }
      return utf8.decode(mnemonicBytes);
    }, [info, password]);
  }

  ///通过密码创建钱包
  Future<bool> createWallet(String password) async {
    //创建钱包
    final wallet = TWHDWallet(passphrase: password);

    //使用AES保存密码和助记词
    final result = await compute((args) {
      final passwordBytes = utf8.encode(args[0]);
      final mnemonicBytes = utf8.encode(args[1]);
      final stopwatch = Stopwatch()..start();

      //使用密码短语派生AES密钥
      final pbkdf2Salt = EncryptUtil.generateKey(16);
      stopwatch.stop();
      logger.d('EncryptUtil.generateKey: ${stopwatch.elapsed}');

      stopwatch
        ..reset()
        ..start();
      final aesKey = EncryptUtil.deriveKeyWithArgon2(
        password: passwordBytes,
        salt: pbkdf2Salt,
        iterations: 3,
      );
      stopwatch.stop();
      logger.d('deriveKeyWithArgon2: ${stopwatch.elapsed}');

      //AES加密助记词
      final aesNonce = EncryptUtil.generateKey(16);

      stopwatch
        ..reset()
        ..start();
      final encryptedMnemonic = EncryptUtil.aesGcmEncrypt(
        key: aesKey,
        data: mnemonicBytes,
        nonce: aesNonce,
      );
      stopwatch.stop();
      logger.d('aesGcmEncrypt: ${stopwatch.elapsed}');

      //加密助记词，pbkdf2Salt，aesNonce，
      return WalletSecretKeyInfo(
        encryptedMnemonic: EncryptUtil.toHexString(encryptedMnemonic),
        salt: EncryptUtil.toHexString(pbkdf2Salt),
        nonce: EncryptUtil.toHexString(aesNonce),
      );
    }, [password, wallet.mnemonic]);

    //保存
    await _store.write(_kWalletSecretKeyInfo, result.toJsonString());
    _wallet = wallet;
    _hasWallet = true;
    return true;
  }

  ///通过密码打开钱包
  Future<bool> openWallet(String password) async {

    final mnemonic = await getMnemonic(password);

    //密码不对,解密失败
    if (mnemonic == null) {
      return false;
    }
    _wallet = TWHDWallet.createWithMnemonic(mnemonic, passphrase: password);
    return true;
  }

  ///备份助记词
  Future<bool> backupMnemonic(String mnemonic) async {
    if (_wallet?.mnemonic != mnemonic) {
      return false;
    }
    await _store.write(_kBackupMnemonic, 'backup');
    _isBackupMnemonicRx.value = true;
    return true;
  }

  ///获取币种默认地址
  String? getDefaultAddress(TWCoinType coinType){
    return _wallet?.getAddressForCoin(coinType);
  }

  ///关闭钱包
  void closeWallet() {
    _wallet = null;
  }

  ///删除钱包
  Future<void> deleteWallet() async {
    await _store.delete(_kWalletSecretKeyInfo);
    await _store.delete(_kBackupMnemonic);
    _wallet?.delete();
    _wallet = null;
    _hasWallet = false;
    _isBackupMnemonicRx.value = false;
  }
}

///钱包密钥信息
class WalletSecretKeyInfo {
  ///PBKDF2的盐
  final String salt;

  ///AES的nonce
  final String nonce;

  ///AES加密后的助记词
  final String encryptedMnemonic;

  WalletSecretKeyInfo({
    required this.salt,
    required this.nonce,
    required this.encryptedMnemonic,
  });

  static WalletSecretKeyInfo? fromJsonString(String jsonStr) {
    try {
      final json = jsonDecode(jsonStr);
      if (json is Map) {
        return WalletSecretKeyInfo(
          salt: json['s'],
          nonce: json['n'],
          encryptedMnemonic: json['m'],
        );
      }
    } catch (ex) {
      logger.w(ex);
    }
    return null;
  }

  String toJsonString() {
    return jsonEncode({
      's': salt,
      'n': nonce,
      'm': encryptedMnemonic,
    });
  }
}
