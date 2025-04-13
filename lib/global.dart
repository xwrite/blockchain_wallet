import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:get/get.dart';

import 'service/web3_service.dart';

///全局对象
class Global{
  const Global._();
  
  ///国际化文本
  static S get text => S.current;
  
  ///钱包
  // static WalletService get wallet => Get.find<WalletService>();

}