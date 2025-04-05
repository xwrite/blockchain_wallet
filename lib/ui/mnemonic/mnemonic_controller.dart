import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:get/get.dart';

import 'mnemonic_state.dart';

class MnemonicController extends GetxController {
  final MnemonicState state = MnemonicState();

  @override
  void onInit() {
    super.onInit();
    state.mnemonicRx.value = Get.find<WalletService>().mnemonic ?? '';
  }

}
