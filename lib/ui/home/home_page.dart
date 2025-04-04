import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/global.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(G.text.appName)),
      body: Container(
        padding: XEdgeInsets(all: 16),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () async{
                await G.wallet.deleteWallet();
                Get.offAllNamed(kPasswordPage);
              },
              child: Text(G.text.deleteWallet),
            ),
            Obx((){
              return ElevatedButton(
                onPressed: MnemonicPage.go,
                child: Text('是否已备份助记词（${G.wallet.isBackupMnemonicRx}）'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
