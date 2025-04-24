import 'package:blockchain_wallet/common/util/password_validator.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'create_wallet_state.dart';

class CreateWalletController extends GetxController {
  final state = CreateWalletState();
  final accountNameFieldController = TextEditingController(text: '钱包');
  final passwordFieldController = TextEditingController();
  final passwordAgainFieldController = TextEditingController();
  final formKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    accountNameFieldController.addListener(_checkFormReady);
    passwordAgainFieldController.addListener(_checkFormReady);
    passwordFieldController.addListener(() {
      _checkFormReady();
      state.passwordConditionsRx.value = PasswordValidator.test(
        passwordFieldController.text,
      );
    });
  }

  void _checkFormReady() {
    state.isFormReadyRx.value =
        accountNameValidator(accountNameFieldController.text) == null &&
            passwordValidator(passwordFieldController.text) == null &&
            passwordAgainValidator(passwordAgainFieldController.text) == null;
  }

  String? accountNameValidator(String? value) {
    final length = value?.length ?? 0;
    if (length < 2 || length > 14) {
      return '需包含2-14个字符';
    }
    return null;
  }

  String? passwordValidator(final String? value) {
    final result = PasswordValidator.isValid(value ?? '');
    return result ? null : '密码无效';
  }

  String? passwordAgainValidator(final String? value) {
    if (value != passwordFieldController.text) {
      return '两次密码输入不一致';
    }
    return null;
  }

  Future<void> onTapConfirm() async {
    final accountName = accountNameFieldController.text;
    final password = passwordFieldController.text;
    final result = await Loading.asyncWrapper(
      () => Global.wallet.createWallet(name: accountName, password: password),
    );
    Get.offAllNamed(kMnemonicPage);
  }

  @override
  void onClose() {
    super.onClose();
    accountNameFieldController.dispose();
    passwordFieldController.dispose();
    passwordAgainFieldController.dispose();
  }
}
