import 'dart:convert';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:blockchain_wallet/common/extension/hex_extension.dart';
import 'package:blockchain_wallet/common/util/encrypt_util.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/common/util/secure_storage.dart';
import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
import 'package:blockchain_wallet/data/repository/transaction_repository.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/ui/authentication/widget/authentication_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

///钱包服务
class WalletService extends GetxService {
  ///转账标准gas Limit
  final transferGasLimit = 21000;

  static const _kWalletEncryptedInfo = '_kWalletEncryptedInfo';

  ///是否已备份助记词
  static const _kBackupMnemonicTag = '_kBackupMnemonicTag';

  ///是否启用生物识别
  static const _kBiometricFeature = '_kBiometricFeature';
  static const _memoryPowerOf2 = 16;
  static const _iterations = 2;
  var _hasWallet = false;
  final RxBool _isBackupMnemonicRx;
  final RxBool _isBiometricEnabledRx;

  static SecureStorage get _store => SecureStorage();

  TWHDWallet? _wallet;
  final Web3Provider _web3Provider;
  final TransactionRepository _transactionRepository;

  WalletService._(
    this._web3Provider,
    this._transactionRepository,
    this._hasWallet,
    bool isBackupMnemonic,
    bool isBiometricEnabled,
  )   : _isBackupMnemonicRx = isBackupMnemonic.obs,
        _isBiometricEnabledRx = isBiometricEnabled.obs;

  static Future<WalletService> create({
    required Web3Provider web3Provider,
    required TransactionRepository transactionRepository,
  }) async {
    final info = await _store.read(_kWalletEncryptedInfo);
    final backup = await _store.read(_kBackupMnemonicTag);
    final biometric = await _store.read(_kBiometricFeature);
    return WalletService._(
      web3Provider,
      transactionRepository,
      info != null,
      backup != null,
      biometric != null,
    );
  }

  ///是否已设置钱包
  bool get hasWallet => _hasWallet;

  ///是否已备份助记词
  bool get isBackupMnemonicRx => _isBackupMnemonicRx.value;

  ///是否已启用指纹识别
  bool get isBiometricEnabledRx => _isBiometricEnabledRx.value;

  ///钱包是否已打开
  bool get isOpen => _wallet != null;

  ///钱包助记词
  String? get mnemonic => _wallet?.mnemonic;

  ///启用生物识别功能，用于保存密码
  Future<bool> enableBiometric(String password) async {
    //检查密码
    if(!await authentication(password)){
      logger.d('密码错误');
      return false;
    }

    try {
      //检查设备是否支持
      final resp = await BiometricStorage().canAuthenticate();
      if (resp != CanAuthenticateResponse.success) {
        return false;
      }

      final storage = await BiometricStorage().getStorage(_kBiometricFeature);
      await storage.write(password);
      await _store.write(_kBiometricFeature, 'enabled');
      _isBiometricEnabledRx.value = true;
      return true;
    } on AuthException catch (e) {
      logger.d('AuthException: $e');
    }
    return false;
  }

  ///关闭指纹验证功能
  Future<bool> disableBiometric() async {
    try {
      //检查设备是否支持
      final resp = await BiometricStorage().canAuthenticate();
      if (resp != CanAuthenticateResponse.success) {
        return false;
      }
      final storage = await BiometricStorage().getStorage(_kBiometricFeature);
      await storage.delete();
      await _store.delete(_kBiometricFeature);
      _isBiometricEnabledRx.value = false;
      return true;
    } on AuthException catch (e) {
      logger.d('AuthException: $e');
    }
    return false;
  }

  ///认证密码是否正确
  Future<bool> authentication(String password) async {
    final info = await _getEncryptedInfo();
    if (info != null) {
      return EncryptUtil.checkPassword(password, info.passwordHash);
    }
    return false;
  }

  ///指纹认证
  Future<bool?> biometricAuthentication(
      {ValueChanged<String>? onSuccess}) async {
    try {
      //检查设备是否支持
      final resp = await BiometricStorage().canAuthenticate();
      if (resp != CanAuthenticateResponse.success) {
        return false;
      }
      final storage = await BiometricStorage().getStorage(_kBiometricFeature);
      final password = await storage.read();
      if (password == null) {
        return false;
      }
      final isSuccess = await authentication(password);
      if (isSuccess) {
        onSuccess?.call(password);
      }
      return isSuccess;
    } on AuthException catch (e) {
      logger.d('AuthException: $e');
      return null;
    }
  }

  ///钱包加密信息
  Future<WalletEncryptedInfo?> _getEncryptedInfo() async {
    final infoStr = await _store.read(_kWalletEncryptedInfo);
    if (infoStr == null) {
      logger.d('钱包不存在');
      return null;
    }
    return WalletEncryptedInfo.fromJsonString(infoStr);
  }

  ///获取助记词
  Future<String?> _getMnemonic(String password) async {
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
      final salt = info.salt.decodeHex();
      final aesKey = EncryptUtil.deriveKeyWithArgon2(
        password: passwordBytes,
        salt: salt,
        memoryPowerOf2: _memoryPowerOf2,
        iterations: _iterations,
      );

      //AES解密助记词
      final aesNonce = info.nonce.decodeHex();
      final mnemonicBytes = EncryptUtil.aesGcmDecrypt(
        key: aesKey,
        data: info.encryptedMnemonic.decodeHex(),
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
  Future<bool> importWallet(
      {required String mnemonic, required String password}) {
    return _createWallet(mnemonic: mnemonic, password: password);
  }

  ///创建钱包
  Future<bool> _createWallet(
      {final String? mnemonic, required String password}) async {
    //创建
    final TWHDWallet wallet;
    if (mnemonic != null) {
      wallet = TWHDWallet.createWithMnemonic(mnemonic);
    } else {
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
        memoryPowerOf2: _memoryPowerOf2,
        salt: salt,
        iterations: _iterations,
      );

      //AES加密助记词
      final aesNonce = EncryptUtil.generateKey(16);
      final encryptedMnemonic = EncryptUtil.aesGcmEncrypt(
        key: aesKey,
        data: mnemonicBytes,
        nonce: aesNonce,
      );
      return WalletEncryptedInfo(
        salt: salt.encodeHex(),
        nonce: aesNonce.encodeHex(),
        encryptedMnemonic: encryptedMnemonic.encodeHex(),
        passwordHash: EncryptUtil.hashPassword(password),
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
  String? getDefaultAddress() {
    // final key = _wallet?.getDerivedKey(coin: TWCoinType.Ethereum, account: 0, change: 0, address: 1);
    // if(key != null){
    //   return TWCoinType.Ethereum.deriveAddress(key);
    // }
    return _wallet?.getAddressForCoin(TWCoinType.Ethereum);
  }

  ///获取默认地址私钥
  Uint8List? getDefaultPrivateKey() {
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


  ///转账
  ///- password 钱包密码
  ///- toAddress 接收地址
  ///- gasPrice gas价格
  ///- value 转账数量
  ///- returns 成功返回交易hash
  Future<String?> transfer({
    required String password,
    required String toAddress,
    required BigInt gasPrice,
    required BigInt value,
  }) async{
    final fromAddress = getDefaultAddress();
    final privateKey = getDefaultPrivateKey();
    if(privateKey == null || fromAddress == null){
      logger.w('privateKey or address is null!');
      return null;
    }
    final txHash = await _web3Provider.sendTransaction(
        privateKey: privateKey,
        toAddress: toAddress,
        gasPrice: gasPrice,
        gasLimit: BigInt.from(transferGasLimit),
        value: value,
    );
    if(txHash == null){
      return null;
    }

    //保存交易记录
    final txEntity = TransactionEntity(
      txHash: txHash,
      from: fromAddress,
      to: toAddress,
      value: value.toString(),
      gasPrice: gasPrice.toString(),
      status: 0,
      type: 0,
    );
    await _transactionRepository.saveTransaction(txEntity);

    return txHash;
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

  ///密码hash（BCrypt）
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
