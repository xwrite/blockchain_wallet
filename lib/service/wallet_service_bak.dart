// import 'dart:convert';
// import 'package:biometric_storage/biometric_storage.dart';
// import 'package:blockchain_wallet/common/utils/encrypt_util.dart';
// import 'package:blockchain_wallet/common/utils/hex.dart';
// import 'package:blockchain_wallet/common/utils/logger.dart';
// import 'package:blockchain_wallet/common/utils/secure_storage.dart';
// import 'package:blockchain_wallet/data/api/web3_provider.dart';
// import 'package:blockchain_wallet/data/app_key_store.dart';
// import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
// import 'package:blockchain_wallet/data/repository/transaction_repository.dart';
// import 'package:blockchain_wallet/global.dart';
// import 'package:blockchain_wallet/ui/authentication/widget/authentication_dialog.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:hex/hex.dart';
// import 'package:wallet_core_bindings/wallet_core_bindings.dart';
//
// part 'wallet_guard_mixin.dart';
//
// ///钱包服务
// abstract class WalletService extends GetxService {
//   final Web3Provider _web3Provider;
//   final TransactionRepository _transactionRepository;
//   final AppKeyStore _keyStore;
//   bool _hasWallet = false;
//
//   WalletService({
//     required Web3Provider web3Provider,
//     required TransactionRepository transactionRepository,
//     required AppKeyStore keyStore,
//   })  : _web3Provider = web3Provider,
//         _transactionRepository = transactionRepository,
//         _keyStore = keyStore;
//
//   ///是否已设置钱包
//   bool get hasWallet => _hasWallet;
// }
//
// class WalletServiceImpl extends WalletService{
//   ///转账标准gas Limit
//   final transferGasLimit = 21000;
//
//
//   WalletServiceImpl({
//     required super.web3Provider,
//     required super.transactionRepository,
//     required super.keyStore,
//   });
//
//   static Future<WalletService> create({
//     required Web3Provider web3Provider,
//     required TransactionRepository transactionRepository,
//     required AppKeyStore keyStore,
//   }) async {
//     return WalletServiceImpl(
//       web3Provider: web3Provider,
//       transactionRepository: transactionRepository,
//       keyStore: keyStore,
//     )._init();
//   }
//
//   Future<WalletServiceImpl> _init() async {
//     _hasWallet = await _keyStore.getWalletEncryptedData() != null;
//     return this;
//   }
//
//
//   ///指纹认证
//   Future<bool?> biometricAuthentication(
//       {ValueChanged<String>? onSuccess}) async {
//     try {
//       //检查设备是否支持
//       final resp = await BiometricStorage().canAuthenticate();
//       if (resp != CanAuthenticateResponse.success) {
//         return false;
//       }
//       final storage = await BiometricStorage().getStorage(_kBiometricFeature);
//       final password = await storage.read();
//       if (password == null) {
//         return false;
//       }
//       final isSuccess = await authentication(password);
//       if (isSuccess) {
//         onSuccess?.call(password);
//       }
//       return isSuccess;
//     } on AuthException catch (e) {
//       logger.d('AuthException: $e');
//       return null;
//     }
//   }
//
//
//   ///获取助记词
//   Future<String?> _getMnemonic(String password) async {
//     final info = await _getEncryptedInfo();
//     if (info == null) {
//       logger.d('钱包不存在');
//       return null;
//     }
//
//     return compute((args) {
//       final info = args[0] as WalletEncryptedData;
//       final password = args[1] as String;
//       final passwordBytes = utf8.encode(password);
//
//       //使用密码短语派生AES密钥
//       final salt = info.salt.decodeHex();
//       final aesKey = EncryptUtil.deriveKeyWithArgon2(
//         password: passwordBytes,
//         salt: salt,
//         memoryPowerOf2: _memoryPowerOf2,
//         iterations: _iterations,
//       );
//
//       //AES解密助记词
//       final aesNonce = info.nonce.decodeHex();
//       final mnemonicBytes = EncryptUtil.aesGcmDecrypt(
//         key: aesKey,
//         data: info.encryptedMnemonic.decodeHex(),
//         nonce: aesNonce,
//       );
//       if (mnemonicBytes == null) {
//         return null;
//       }
//       return utf8.decode(mnemonicBytes);
//     }, [info, password]);
//   }
//
//   ///通过密码创建钱包
//   Future<void> createWallet(String password) async {
//     final wallet = TWHDWallet();
//
//     final encryptedData = await compute((args) {
//       final password = utf8.encode(args[0]);
//       final mnemonic = utf8.encode(args[1]);
//
//       //通过密码派生AES密钥
//       final salt = EncryptUtil.generateKey(16);
//       final memoryPowerOf2 = 13;
//       final iterations = 1;
//       final desiredKeyLength = 32;
//       final aesKey = EncryptUtil.deriveKeyWithArgon2(
//         password: password,
//         memoryPowerOf2: memoryPowerOf2,
//         salt: salt,
//         iterations: iterations,
//         desiredKeyLength: desiredKeyLength,
//       );
//
//       //AES加密助记词
//       final aesNonce = EncryptUtil.generateKey(16);
//       Uint8List? aad;
//       final tagLength = 16;
//       final encryptedMnemonic = EncryptUtil.aesGcmEncrypt(
//         key: aesKey,
//         data: mnemonic,
//         nonce: aesNonce,
//         aad: aad,
//         tagLength: tagLength,
//       );
//       return WalletEncryptedData(
//         argon2Salt: salt,
//         argon2MemoryPowerOf2: memoryPowerOf2,
//         argon2Iterations: iterations,
//         argon2KeyLength: desiredKeyLength,
//         aesNonce: aesNonce,
//         aesAad: aad,
//         aesTagLength: tagLength,
//         aesEncryptedMnemonic: encryptedMnemonic,
//       ).toJsonString();
//     }, [password, wallet.mnemonic]);
//
//     //保存加密数据
//     await _keyStore.saveWalletEncryptedData(encryptedData);
//
//     //保存密码
//     await _keyStore.savePassword(password);
//
//     //TODO 保存钱包默认地址
//     final address = wallet.getAddressForCoin(TWCoinType.Ethereum);
//
//     wallet.getAddressDerivation(coin, derivation)
//
//     //删除钱包
//     wallet.delete();
//   }
//
//   ///通过助记词导入钱包
//   Future<bool> importWallet(
//       {required String mnemonic, required String password}) {
//     return _createWallet(mnemonic: mnemonic, password: password);
//   }
//
//   ///创建钱包
//   Future<TWHDWallet?> _createWallet(String password) async {
//     //创建
//     final TWHDWallet wallet;
//     if (mnemonic != null) {
//       wallet = TWHDWallet.createWithMnemonic(mnemonic);
//     } else {
//       wallet = TWHDWallet();
//     }
//
//     //使用AES保存密码和助记词
//     final result = await compute((args) {
//       final passwordBytes = utf8.encode(args[0]);
//       final mnemonicBytes = utf8.encode(args[1]);
//
//       //使用密码短语派生AES密钥
//       final salt = EncryptUtil.generateKey(16);
//       final aesKey = EncryptUtil.deriveKeyWithArgon2(
//         password: passwordBytes,
//         memoryPowerOf2: _memoryPowerOf2,
//         salt: salt,
//         iterations: _iterations,
//       );
//
//       //AES加密助记词
//       final aesNonce = EncryptUtil.generateKey(16);
//       final encryptedMnemonic = EncryptUtil.aesGcmEncrypt(
//         key: aesKey,
//         data: mnemonicBytes,
//         nonce: aesNonce,
//       );
//       return WalletEncryptedData(
//         salt: salt.encodeHex(),
//         nonce: aesNonce.encodeHex(),
//         encryptedMnemonic: encryptedMnemonic.encodeHex(),
//         passwordHash: EncryptUtil.hashPassword(password),
//       );
//     }, [password, wallet.mnemonic]);
//
//     //保存
//     await _store.write(_kWalletEncryptedInfo, result.toJsonString());
//
//     _wallet = wallet;
//     _hasWallet = true;
//     return true;
//   }
//
//   ///通过密码打开钱包
//   Future<bool> openWallet(String password) async {
//     final mnemonic = await _getMnemonic(password);
//
//     //密码不对,解密失败
//     if (mnemonic == null) {
//       return false;
//     }
//     _wallet = TWHDWallet.createWithMnemonic(mnemonic);
//     return true;
//   }
//
//   ///备份助记词
//   Future<bool> backupMnemonic(String mnemonic) async {
//     if (_wallet?.mnemonic != mnemonic) {
//       return false;
//     }
//     await _store.write(_kBackupMnemonicTag, 'backup');
//     _isBackupMnemonicRx.value = true;
//     return true;
//   }
//
//   ///获取币种默认地址
//   String? getDefaultAddress() {
//     // final key = _wallet?.getDerivedKey(coin: TWCoinType.Ethereum, account: 0, change: 0, address: 1);
//     // if(key != null){
//     //   return TWCoinType.Ethereum.deriveAddress(key);
//     // }
//     return _wallet?.getAddressForCoin(TWCoinType.Ethereum);
//   }
//
//   ///获取默认地址私钥
//   Uint8List? getDefaultPrivateKey() {
//     return _wallet?.getKeyForCoin(TWCoinType.Ethereum).data;
//   }
//
//   ///关闭钱包
//   void closeWallet() {
//     _wallet = null;
//   }
//
//   ///删除钱包
//   Future<void> deleteWallet() async {
//     await _store.delete(_kWalletEncryptedInfo);
//     await _store.delete(_kBackupMnemonicTag);
//     _wallet?.delete();
//     _wallet = null;
//     _hasWallet = false;
//     _isBackupMnemonicRx.value = false;
//   }
//
//   ///转账
//   ///- password 钱包密码
//   ///- toAddress 接收地址
//   ///- gasPrice gas价格
//   ///- value 转账数量
//   ///- returns 成功返回交易hash
//   Future<String?> transfer({
//     required String password,
//     required String toAddress,
//     required BigInt gasPrice,
//     required BigInt value,
//   }) async {
//     final fromAddress = getDefaultAddress();
//     final privateKey = getDefaultPrivateKey();
//     if (privateKey == null || fromAddress == null) {
//       logger.w('privateKey or address is null!');
//       return null;
//     }
//     final txHash = await _web3Provider.sendTransaction(
//       privateKey: privateKey,
//       toAddress: toAddress,
//       gasPrice: gasPrice,
//       gasLimit: BigInt.from(transferGasLimit),
//       value: value,
//     );
//     if (txHash == null) {
//       return null;
//     }
//
//     //保存交易记录
//     final txEntity = TransactionEntity(
//       txHash: txHash,
//       from: fromAddress,
//       to: toAddress,
//       value: value.toString(),
//       gasPrice: gasPrice.toString(),
//       status: 0,
//       type: 0,
//     );
//     await _transactionRepository.saveTransaction(txEntity);
//
//     return txHash;
//   }
// }
//
// ///钱包加密数据
// class WalletEncryptedData {
//   ///argon2盐
//   final Uint8List argon2Salt;
//
//   ///argon2内存
//   final int argon2MemoryPowerOf2;
//
//   ///argon2迭代次数
//   final int argon2Iterations;
//
//   ///argon2密钥长度
//   final int argon2KeyLength;
//
//   ///AES的nonce
//   final Uint8List aesNonce;
//
//   ///AES的附加认证数据
//   final Uint8List? aesAad;
//
//   ///认证标签长度
//   final int aesTagLength;
//
//   ///AES加密后的助记词
//   final Uint8List aesEncryptedMnemonic;
//
//   WalletEncryptedData({
//     required this.argon2Salt,
//     required this.argon2MemoryPowerOf2,
//     required this.argon2Iterations,
//     required this.argon2KeyLength,
//     required this.aesNonce,
//     this.aesAad,
//     required this.aesTagLength,
//     required this.aesEncryptedMnemonic,
//   });
//
//   String toJsonString() {
//     return jsonEncode({
//       'argon2Salt': Hex.encode(argon2Salt),
//       'argon2MemoryPowerOf2': argon2MemoryPowerOf2,
//       'argon2Iterations': argon2Iterations,
//       'argon2KeyLength': argon2KeyLength,
//       'aesNonce': Hex.encode(aesNonce),
//       if (aesAad != null) 'aesAad': Hex.encode(aesAad!),
//       'aesTagLength': aesTagLength,
//       'aesEncryptedMnemonic': Hex.encode(aesEncryptedMnemonic),
//     });
//   }
//
//   static WalletEncryptedData? fromJsonString(String jsonString) {
//     try {
//       final json = jsonDecode(jsonString);
//       if (json is Map) {
//         final argon2Salt = json['argon2Salt'] as String;
//         final aesNonce = json['aesNonce'] as String;
//         final aesAad = json['aesAad'] as String?;
//         final aesEncryptedMnemonic = json['aesEncryptedMnemonic'] as String;
//
//         return WalletEncryptedData(
//           argon2Salt: Hex.decode(argon2Salt),
//           argon2MemoryPowerOf2: json['argon2MemoryPowerOf2'] as int,
//           argon2Iterations: json['argon2Iterations'] as int,
//           argon2KeyLength: json['argon2KeyLength'] as int,
//           aesNonce: Hex.decode(aesNonce),
//           aesAad: aesAad != null ? Hex.decode(aesAad) : null,
//           aesTagLength: json['aesTagLength'] as int,
//           aesEncryptedMnemonic: Hex.decode(aesEncryptedMnemonic),
//         );
//       }
//     } catch (ex) {
//       logger.w(ex);
//     }
//     return null;
//   }
// }
