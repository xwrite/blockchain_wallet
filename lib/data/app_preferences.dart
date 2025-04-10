
import 'package:blockchain_wallet/common/util/local_storage.dart';
import 'package:get/get.dart';

class AppPreferences{
  AppPreferences._();

  static const _kBackedUpMnemonic = 'BackedUpMnemonic';
  static const _kBiometricEnabled = 'BiometricEnabled';

  final _localStorage = LocalStorage('AppPreferences');

  ///是否已备份助记词
  final isBackedUpMnemonicRx = false.obs;

  ///是否已启用生物识别
  final isBiometricEnabledRx = false.obs;

  Future<void> _init() async{
    isBackedUpMnemonicRx.value = await _localStorage.getBool(_kBackedUpMnemonic) ?? false;
    isBiometricEnabledRx.value = await _localStorage.getBool(_kBiometricEnabled) ?? false;
  }

  static Future<AppPreferences> create() async{
    return AppPreferences._().._init();
  }

  Future<void> setBackedUpMnemonic(bool isBackedUp) async{
    await _localStorage.setBool(_kBackedUpMnemonic, isBackedUp);
    isBackedUpMnemonicRx.value = isBackedUp;
  }

  Future<void> setBiometricEnabled(bool isEnabled) async{
    await _localStorage.setBool(_kBiometricEnabled, isEnabled);
    isBiometricEnabledRx.value = isEnabled;
  }

}