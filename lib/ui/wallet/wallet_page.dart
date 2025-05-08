import 'dart:collection';

import 'package:blockchain_wallet/common/extension/functions_extension.dart';
import 'package:blockchain_wallet/data/app_preferences.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
      appBar: AppBar(
        title: Text(Global.text.appName),
        actions: [buildLanguageSwitch()],
      ),
      body: Container(
        padding: XEdgeInsets(horizontal: 24, bottom: 56),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text('开始进入 Web3.0', style: Get.textTheme.headlineMedium),
            Padding(
              padding: XEdgeInsets(top: 24),
              child: Text(
                '安全的去中心化钱包，为用户的交昜保驾护航，保证用户可安心畅游 Web3 世界',
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
            const Spacer(flex: 1),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: Size.fromHeight(40)),
              onPressed: () {
                Get.toNamed(kCreateWalletPage);
              },
              child: Text(Global.text.createWallet),
            ),
            Padding(
              padding: const XEdgeInsets(top: 16),
              child: OutlinedButton(
                style:
                    OutlinedButton.styleFrom(minimumSize: Size.fromHeight(40)),
                onPressed: () {
                  Get.toNamed(kImportWalletPage);
                },
                child: Text(Global.text.importWallet),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLanguageSwitch() {
    return Padding(
      padding: XEdgeInsets(right: 16),
      child: DropdownMenu<AppLanguageEnum>(
        initialSelection: controller.language,
        dropdownMenuEntries: AppLanguageEnum.values.map((element) {
          return DropdownMenuEntry(label: element.label, value: element);
        }).toList(),
        onSelected: controller.changeLanguage,
      ),
    );
  }
}
