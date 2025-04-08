import 'package:biometric_storage/biometric_storage.dart';
import 'package:blockchain_wallet/common/extension/amount_format_extension.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';

import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();

  @override
  void onInit() {
    super.onInit();
    state.addressRx.value = G.wallet.getDefaultAddress() ?? '';
    fetchBalance();
  }

  void fetchBalance() async{
    final address = state.addressRx();
    if(address.isNotEmpty){
      final balance = await G.web3.getBalance(address);
      if(balance != null){
        state.balanceRx.value = balance;
      }
    }
  }

  void biometricAuthenticate() async{
    final response = await BiometricStorage().canAuthenticate();
    logger.d('response=$response');
    if(response != CanAuthenticateResponse.success){
      return;
    }
    final store = await BiometricStorage().getStorage('mystorage');
    final data = await store.read();
    logger.d('data=$data');
  }
}
