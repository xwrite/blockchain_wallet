import 'package:blockchain_wallet/common/extension/amount_format_extension.dart';
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
}
