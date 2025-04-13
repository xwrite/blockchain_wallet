
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/data/app_key_store.dart';
import 'package:blockchain_wallet/data/repository/transaction_repository.dart';
import 'package:get/get.dart';

class AuthService extends GetxService{

  var _isBiometricEnabled = false;
  var _isPasswordEnabled = false;

  final Web3Provider _web3Provider;
  final TransactionRepository _transactionRepository;
  final AppKeyStore _keyStore;

  AuthService._({
    required Web3Provider web3Provider,
    required TransactionRepository transactionRepository,
    required AppKeyStore keyStore,
  })  : _web3Provider = web3Provider,
        _transactionRepository = transactionRepository,
        _keyStore = keyStore;

  static Future<AuthService> create({
    required Web3Provider web3Provider,
    required TransactionRepository transactionRepository,
    required AppKeyStore keyStore,
  }) {
    return AuthService._(
      web3Provider: web3Provider,
      transactionRepository: transactionRepository,
      keyStore: keyStore,
    )._init();
  }
  Future<AuthService> _init() async {
    _isBiometricEnabled = await _keyStore.hasBiometricPassword();
    _isPasswordEnabled = await _keyStore.hasPassword();
    return this;
  }

  ///是否已启用密码认证
  bool get isPasswordEnabled => _isPasswordEnabled;

  ///是否已启用指纹识别认证
  bool get isBiometricEnabled => _isBiometricEnabled;

  ///启用生物识别功能，用于保存密码
  ///- password 密码
  ///- return 用户取消返回null，成功返回true，失败返回false
  Future<bool?> enableBiometric(String password) async {
    if (!await _keyStore.verifyPassword(password)) {
      logger.d('密码错误');
      return false;
    }
    final result = await _keyStore.savePasswordByBiometric(password);
    if(result == true){
      _isBiometricEnabled = true;
    }
    return result;
  }

  ///关闭指纹验证功能
  Future<bool> disableBiometric() async {
    final result = await _keyStore.deleteBiometricPassword();
    if(result){
      _isBiometricEnabled = false;
    }
    return result;
  }


}