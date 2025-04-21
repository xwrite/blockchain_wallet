import 'package:blockchain_wallet/common/extension/functions_extension.dart';
import 'package:blockchain_wallet/data/app_preferences.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';

import 'wallet_state.dart';

class WalletController extends GetxController {
  final WalletState state = WalletState();

  AppLanguageEnum? get language{
    return Global.preferences.locale?.let(AppLanguageEnum.fromLocale);
  }

  void changeLanguage(AppLanguageEnum? language){
    if(language != null){
      Global.preferences.updateLocale(language.locale);
    }
  }

}
