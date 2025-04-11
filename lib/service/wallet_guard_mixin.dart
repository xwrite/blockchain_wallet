
part of 'wallet_service.dart';

mixin _WalletGuardMixin on WalletService {

  var _isBiometricEnabled = false;

  Future<void> _initGuard() async {
    _isBiometricEnabled = await _keyStore.hasBiometricPassword();
  }

  ///是否已启用指纹识别
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