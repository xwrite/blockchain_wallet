import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();

  @override
  void onInit() {
    super.onInit();
    state.ethAddressRx.value = G.wallet.getDefaultAddress(TWCoinType.Ethereum) ?? '';
    fetchBalance();
  }

  void fetchBalance() async{
    final address = state.ethAddressRx();
    if(address.isNotEmpty){
      final balance = await G.web3.getBalance(state.ethAddressRx());
      if(balance != null){
        state.ethBalanceRx.value = balance.toRadixString(10);
      }
    }
  }
}
