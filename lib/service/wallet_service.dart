import 'dart:convert';
import 'package:blockchain_wallet/common/util/encrypt_util.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/common/util/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

///钱包服务
class WalletService extends GetxService {
  static const _kWalletEncryptedInfo = '_kWalletEncryptedInfo';
  static const _kBackupMnemonicTag = '_kBackupMnemonicTag';
  var _hasWallet = false;
  final RxBool _isBackupMnemonicRx;

  static SecureStorage get _store => SecureStorage();

  TWHDWallet? _wallet;

  WalletService._(this._hasWallet, bool isBackupMnemonic)
      : _isBackupMnemonicRx = isBackupMnemonic.obs;

  static Future<WalletService> create() async {
    final info = await _store.read(_kWalletEncryptedInfo);
    final backup = await _store.read(_kBackupMnemonicTag);
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
    final info = await _getEncryptedInfo();
    if(info != null){
      final hash = TWHash.keccak256(utf8.encode(password));
      return EncryptUtil.toHexString(hash) == info.passwordHash;
    }
    return false;
  }

  ///钱包加密信息
  Future<WalletEncryptedInfo?> _getEncryptedInfo() async{
    final infoStr = await _store.read(_kWalletEncryptedInfo);
    if (infoStr == null) {
      logger.d('钱包不存在');
      return null;
    }
    return WalletEncryptedInfo.fromJsonString(infoStr);
  }

  ///获取助记词
  Future<String?> _getMnemonic(String password) async{
    final info = await _getEncryptedInfo();
    if (info == null) {
      logger.d('钱包不存在');
      return null;
    }

    return compute((args) {
      final info = args[0] as WalletEncryptedInfo;
      final password = args[1] as String;
      final passwordBytes = utf8.encode(password);

      //使用密码短语派生AES密钥
      final salt = EncryptUtil.fromHexString(info.salt);
      final aesKey = EncryptUtil.deriveKeyWithArgon2(
        password: passwordBytes,
        salt: salt,
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
  Future<bool> createWallet(String password) {
    return _createWallet(password: password);
  }

  ///通过助记词导入钱包
  Future<bool> importWallet({required String mnemonic, required String password}) {
    return _createWallet(mnemonic: mnemonic, password: password);
  }

  ///创建钱包
  Future<bool> _createWallet({final String? mnemonic, required String password}) async {

    //创建
    final TWHDWallet wallet;
    if(mnemonic != null){
      wallet = TWHDWallet.createWithMnemonic(mnemonic);
    }else{
      wallet = TWHDWallet();
    }

    //使用AES保存密码和助记词
    final result = await compute((args) {
      final passwordBytes = utf8.encode(args[0]);
      final mnemonicBytes = utf8.encode(args[1]);

      //使用密码短语派生AES密钥
      final salt = EncryptUtil.generateKey(16);
      final aesKey = EncryptUtil.deriveKeyWithArgon2(
        password: passwordBytes,
        salt: salt,
        iterations: 3,
      );

      //AES加密助记词
      final aesNonce = EncryptUtil.generateKey(16);
      final encryptedMnemonic = EncryptUtil.aesGcmEncrypt(
        key: aesKey,
        data: mnemonicBytes,
        nonce: aesNonce,
      );

      //密码哈希
      final passwordHash = TWHash.keccak256(passwordBytes);

      return WalletEncryptedInfo(
        salt: EncryptUtil.toHexString(salt),
        nonce: EncryptUtil.toHexString(aesNonce),
        encryptedMnemonic: EncryptUtil.toHexString(encryptedMnemonic),
        passwordHash: EncryptUtil.toHexString(passwordHash),
      );
    }, [password, wallet.mnemonic]);

    //保存
    await _store.write(_kWalletEncryptedInfo, result.toJsonString());

    _wallet = wallet;
    _hasWallet = true;
    return true;
  }

  ///通过密码打开钱包
  Future<bool> openWallet(String password) async {

    final mnemonic = await _getMnemonic(password);

    //密码不对,解密失败
    if (mnemonic == null) {
      return false;
    }
    _wallet = TWHDWallet.createWithMnemonic(mnemonic);
    return true;
  }

  ///备份助记词
  Future<bool> backupMnemonic(String mnemonic) async {
    if (_wallet?.mnemonic != mnemonic) {
      return false;
    }
    await _store.write(_kBackupMnemonicTag, 'backup');
    _isBackupMnemonicRx.value = true;
    return true;
  }

  ///获取币种默认地址
  String? getDefaultAddress(){
    return _wallet?.getAddressForCoin(TWCoinType.Ethereum);
  }

  ///获取默认地址私钥
  Uint8List? getDefaultPrivateKey(){
    return _wallet?.getKeyForCoin(TWCoinType.Ethereum).data;
  }

  ///关闭钱包
  void closeWallet() {
    _wallet = null;
  }

  ///删除钱包
  Future<void> deleteWallet() async {
    await _store.delete(_kWalletEncryptedInfo);
    await _store.delete(_kBackupMnemonicTag);
    _wallet?.delete();
    _wallet = null;
    _hasWallet = false;
    _isBackupMnemonicRx.value = false;
  }
}

///钱包密钥信息
class WalletEncryptedInfo {
  ///盐
  final String salt;

  ///AES的nonce
  final String nonce;

  ///AES加密后的助记词
  final String encryptedMnemonic;

  ///密码hash（keccak256）
  final String passwordHash;

  WalletEncryptedInfo({
    required this.salt,
    required this.nonce,
    required this.encryptedMnemonic,
    required this.passwordHash,
  });

  static WalletEncryptedInfo? fromJsonString(String jsonStr) {
    try {
      final json = jsonDecode(jsonStr);
      if (json is Map) {
        return WalletEncryptedInfo(
          salt: json['s'],
          nonce: json['n'],
          encryptedMnemonic: json['m'],
          passwordHash: json['p'],
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
      'p': passwordHash,
    });
  }
}
