import 'package:blockchain_wallet/common/util/password_util.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:get/get.dart';

import 'create_wallet_state.dart';

class CreateWalletController extends GetxController {
  final state = CreateWalletState();

  Future<void> onTapConfirm() async {
    final password = state.password.trim();
    final passwordAgain = state.passwordAgain.trim();
    if (!PasswordUtil.isValid(password)) {
      Toast.show(Global.text.passwordTips);
      return;
    }
    if (passwordAgain.isEmpty) {
      Toast.show(Global.text.passwordAgainRequired);
      return;
    }
    if (password != passwordAgain) {
      Toast.show(Global.text.passwordInputInconsistency);
      return;
    }
    final result = await Loading.asyncWrapper(
      () => Global.wallet.createWallet(password),
    );
    if (result) {
      Get.offAllNamed(kHomePage);
    }
  }
}
