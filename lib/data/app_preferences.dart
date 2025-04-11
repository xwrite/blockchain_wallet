
import 'package:blockchain_wallet/common/util/local_storage.dart';
import 'package:get/get.dart';

class AppPreferences{
  AppPreferences._();

  static const _kBackedUpMnemonic = 'BackedUpMnemonic';

  final _storage = LocalStorage('AppPreferences');

  ///是否已备份助记词
  final isBackedUpMnemonicRx = false.obs;

  Future<void> _init() async{
    isBackedUpMnemonicRx.value = await _storage.getBool(_kBackedUpMnemonic) ?? false;
  }

  static Future<AppPreferences> create() async{
    return AppPreferences._().._init();
  }

  Future<void> setBackedUpMnemonic(bool isBackedUp) async{
    await _storage.setBool(_kBackedUpMnemonic, isBackedUp);
    isBackedUpMnemonicRx.value = isBackedUp;
  }

}