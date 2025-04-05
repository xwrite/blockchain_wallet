import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:get/get.dart';
import 'password_state.dart';

class PasswordController extends GetxController {
  final state = PasswordState();

  ///密码不少于8个字符，必须包含大小写字母、数字
  final _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
    caseSensitive: true,
  );

  void togglePasswordVisible() {
    state.isPasswordVisible = !state.isPasswordVisible;
    update();
  }

  void togglePasswordAgainVisible() {
    state.isPasswordAgainVisible = !state.isPasswordAgainVisible;
    update();
  }

  Future<void> onTapConfirm() async {
    final password = state.password.trim();
    final passwordAgain = state.passwordAgain.trim();
    if(!_passwordRegex.hasMatch(password)){
      Toast.show(S.current.passwordTips);
      return;
    }
    if (passwordAgain.isEmpty) {
      Toast.show('请再次输入密码');
      return;
    }
    if (password != passwordAgain) {
      Toast.show('两次密码输入不一致');
      return;
    }
    final result = await Loading.asyncWrapper(
      Get.find<WalletService>().createWallet(password),
    );
    if(result){
      Toast.show('密码设置成功');
      Get.offAllNamed(kHomePage);
    }
  }
}
