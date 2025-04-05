import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:get/get.dart';
import 'authentication_state.dart';

class AuthenticationController extends GetxController {
  final state = AuthenticationState();

  void togglePasswordVisible() {
    state.isPasswordVisible = !state.isPasswordVisible;
    update();
  }

  Future<void> onTapVerifyPassword() async {
    final password = state.password.trim();
    if (password.isEmpty) {
      Toast.show('请输入密码');
      return;
    }
    final result = await Loading.asyncWrapper(
      Get.find<WalletService>().openWallet(password),
    );
    if (!result) {
      Toast.show('密码错误');
      return;
    }

    Get.offAllNamed(kHomePage);
  }
}
