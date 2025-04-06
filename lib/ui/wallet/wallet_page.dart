import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'wallet_controller.dart';
import 'wallet_state.dart';

class WalletPage extends StatelessWidget {
  WalletPage({Key? key}) : super(key: key);

  final WalletController controller = Get.put(WalletController());
  final WalletState state = Get.find<WalletController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(G.text.appName)),
      body: Container(
        padding: XEdgeInsets(all: 16),
        alignment: Alignment.center,
        child: Column(
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(kCreateWalletPage);
              },
              child: Text(G.text.createWallet),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(kImportWalletPage);
              },
              child: Text(G.text.importWallet),
            ),
          ],
        ),
      ),
    );
  }
}
