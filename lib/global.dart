import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:get/get.dart';

import 'data/app_preferences.dart';
import 'service/web3_service.dart';

///全局对象
class Global{
  const Global._();
  
  ///国际化文本
  static S get text => S.current;
  
  ///钱包
  // static WalletService get wallet => Get.find<WalletService>();


  ///应用偏好设置
  static AppPreferences get preferences => Get.find<AppPreferences>();

}