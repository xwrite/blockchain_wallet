import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/password_dialog.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_content/secure_content.dart';

import 'mnemonic_controller.dart';

///查看助记词
class MnemonicPage extends GetView<MnemonicController> {
  const MnemonicPage({super.key});

  static void go() async {
    final password = await PasswordDialog.show();
    if (password == null) {
      return;
    }
    final result = await Loading.asyncWrapper(
      G.wallet.authentication(password),
    );
    if (!result) {
      Toast.show(G.text.passwordError);
      return;
    }
    Get.toNamed(kMnemonicPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(G.text.mnemonicView),
      ),
      body: SecureWidget(builder: (context, onInit, onDispose){
        return Container(
          padding: XEdgeInsets(all: 16),
          child: Column(
            children: [
              Obx(() {
                return Text(
                  controller.state.mnemonicRx(),
                  style: TextStyle(fontSize: 16),
                );
              }),
              Padding(
                padding: XEdgeInsets(top: 24),
                child: ElevatedButton(
                  onPressed: () {
                    Get.offNamed(kMnemonicBackupPage);
                  },
                  child: Text(G.text.mnemonicBackup),
                ),
              ),
            ],
          ),
        );
      }, isSecure: true),
    );
  }
}
