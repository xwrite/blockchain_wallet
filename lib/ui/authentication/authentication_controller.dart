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
      Toast.show(G.text.passwordRequired);
      return;
    }
    final result = await Loading.asyncWrapper((){
      return G.wallet.authentication(password);
    });
    if (!result) {
      Toast.show(G.text.passwordError);
      return;
    }

    Get.offAllNamed(kHomePage);
  }

  Future<void> onTapVerifyBiometric() async {

  }

}
