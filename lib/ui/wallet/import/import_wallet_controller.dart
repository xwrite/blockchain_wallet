import 'package:blockchain_wallet/common/util/password_util.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:get/get.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';
import 'import_wallet_state.dart';

class ImportWalletController extends GetxController {
  final ImportWalletState state = ImportWalletState();

  void onTapConfirm() async {
    final mnemonic = state.mnemonic.trim();
    final password = state.password.trim();
    final passwordAgain = state.passwordAgain.trim();

    if (!TWMnemonic.isValid(mnemonic)) {
      Toast.show('请输入有效的助记词(BIP-39)');
      return;
    }
    if (!PasswordUtil.isValid(password)) {
      Toast.show(G.text.passwordTips);
      return;
    }
    if (passwordAgain.isEmpty) {
      Toast.show(G.text.passwordAgainRequired);
      return;
    }
    if (password != passwordAgain) {
      Toast.show(G.text.passwordInputInconsistency);
      return;
    }
    final result = await Loading.asyncWrapper(
      () => G.wallet.importWallet(mnemonic: mnemonic, password: password),
    );
    if (result) {
      Get.offAllNamed(kHomePage);
    }
  }
}
