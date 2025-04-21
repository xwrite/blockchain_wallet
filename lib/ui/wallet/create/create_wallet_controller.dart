import 'package:blockchain_wallet/common/util/password_validator.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'create_wallet_state.dart';

class CreateWalletController extends GetxController {
  final state = CreateWalletState();
  final accountNameFieldController = TextEditingController(text: '钱包');
  final passwordFieldController = TextEditingController();
  final passwordAgainFieldController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    passwordFieldController.addListener(() {
      state.passwordRx.value = passwordFieldController.text;
      state.passwordConditionsRx.value = PasswordValidator.test(
        state.passwordRx(),
      );
    });
  }

  String? accountNameValidator(String? value){
    final length = value?.length ?? 0;
    if (length < 2 || length > 14) {
      return '需包含2-14个字符';
    }
    return null;
  }

  String? passwordValidator(final String? value){
    final result = PasswordValidator.isValid(value ?? '');
    return result ? null : '密码无效';
  }

  String? passwordAgainValidator(final String? value){
    if (value != state.passwordRx()) {
      return '两次密码输入不一致';
    }
    return null;
  }

  Future<void> onTapConfirm() async {
    final password = state.passwordRx();
    final passwordAgain = passwordAgainFieldController.text;
    // if (!PasswordUtil.isValid(password)) {
    //   Toast.show(Global.text.passwordTips);
    //   return;
    // }
    if (passwordAgain.isEmpty) {
      Toast.show(Global.text.passwordAgainRequired);
      return;
    }
    if (password != passwordAgain) {
      Toast.show(Global.text.passwordInputInconsistency);
      return;
    }
    // final result = await Loading.asyncWrapper(
    //   () => Global.wallet.createWallet(password),
    // );
    // if (result) {
    //   Get.offAllNamed(kHomePage);
    // }
  }

  @override
  void onClose() {
    super.onClose();
    accountNameFieldController.dispose();
    passwordFieldController.dispose();
    passwordAgainFieldController.dispose();
  }
}
