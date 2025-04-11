import 'package:biometric_storage/biometric_storage.dart';
import 'package:blockchain_wallet/common/extension/amount_format_extension.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';

import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();
  final _web3Provider = Get.find<Web3Provider>();

  @override
  void onInit() {
    super.onInit();
    state.addressRx.value = Global.wallet.getDefaultAddress() ?? '';
    fetchBalance();
  }

  void fetchBalance() async{
    final address = state.addressRx();
    if(address.isNotEmpty){
      final balance = await _web3Provider.getBalance(address);
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
