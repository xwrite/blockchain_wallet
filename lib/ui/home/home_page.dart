import 'package:blockchain_wallet/common/extension/amount_format_extension.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/ui/authentication/widget/authentication_dialog.dart';
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
      body: SingleChildScrollView(
        padding: XEdgeInsets(all: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Obx(() {
              return ListTile(
                title: Text('Ethereum'),
                subtitle: Text(state.addressRx()),
                trailing: Text(state.balanceRx().formatEth()),
                isThreeLine: true,
              );
            }),
            ElevatedButton(
              onPressed: controller.fetchBalance,
              child: Text('刷新余额'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(kSendPage),
              child: Text('转账'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(kTransactionListPage),
              child: Text('转账记录'),
            ),
            ElevatedButton(
              onPressed: () {
                AuthenticationDialog.show(onSuccess: () async {
                  await G.wallet.deleteWallet();
                  Get.offAllNamed(kWalletPage);
                });
              },
              child: Text(G.text.deleteWallet),
            ),
            Obx(() {
              return ElevatedButton(
                onPressed: () {
                  AuthenticationDialog.show(onSuccess: () {
                    Get.toNamed(kMnemonicPage);
                  });
                },
                child: Text('是否已备份助记词（${G.wallet.isBackupMnemonicRx}）'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
