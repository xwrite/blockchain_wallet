import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:get/get.dart';
import 'authentication_state.dart';

class AuthenticationController extends GetxController {
  final state = AuthenticationState();

  Future<void> onTapVerifyPassword() async {
    final password = state.password.trim();
    if (password.isEmpty) {
      Toast.show(Global.text.passwordRequired);
      return;
    }
    final result = await Loading.asyncWrapper((){
      return Global.wallet.authentication(password);
    });
    if (!result) {
      Toast.show(Global.text.passwordError);
      return;
    }

    Get.offAllNamed(kHomePage);
  }

  Future<void> onTapVerifyBiometric() async {

  }

}
