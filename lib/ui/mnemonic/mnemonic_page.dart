import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_content/secure_content.dart';

import 'mnemonic_controller.dart';

///查看助记词
class MnemonicPage extends GetView<MnemonicController> {
  const MnemonicPage({super.key});

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
