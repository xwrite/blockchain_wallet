import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';

import 'mnemonic_state.dart';

class MnemonicController extends GetxController {
  final MnemonicState state = MnemonicState();

  @override
  void onInit() {
    super.onInit();
    state.mnemonicRx.value = G.wallet.mnemonic ?? '';
  }

}
