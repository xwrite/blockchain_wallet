import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/ui/mnemonic/mnemonic_page.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());
  final HomeState state = Get.find<HomeController>().state;

  @override
  Widget build(BuildContext context) {
    final walletService = Get.find<WalletService>();
    return Scaffold(
      appBar: AppBar(title: Text('Blockchain Wallet')),
      body: Container(
        padding: XEdgeInsets(all: 16),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () async{
                await walletService.deleteWallet();
                Get.offAllNamed(kPasswordPage);
              },
              child: Text('删除钱包'),
            ),
            Obx((){
              return ElevatedButton(
                onPressed: MnemonicPage.go,
                child: Text('是否已备份助记词（${walletService.isBackupMnemonicRx}）'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
