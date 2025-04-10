import 'package:blockchain_wallet/common/extension/amount_format_extension.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/ui/authentication/widget/authentication_dialog.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:blockchain_wallet/widget/toast.dart';
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
            Obx(() {
              final isEnabled = G.wallet.isBiometricEnabledRx;
              return SwitchListTile(
                value: isEnabled,
                title: Text('指纹验证'),
                onChanged: (value) async{
                  if (value) {
                    final password = await AuthenticationDialog.show();
                    if(password != null && password.isNotEmpty){
                      G.wallet.enableBiometric(password);
                    }
                  } else {
                    G.wallet.disableBiometric();
                  }
                },
              );
            }),
            // ElevatedButton(
            //   onPressed: () {
            //     AuthenticationDialog.show(onSuccess: (_) async {
            //       await G.wallet.deleteWallet();
            //       Get.offAllNamed(kWalletPage);
            //     });
            //   },
            //   child: Text(G.text.deleteWallet),
            // ),
            Obx(() {
              return ElevatedButton(
                onPressed: () async{
                  final password = await AuthenticationDialog.show();
                  if(password != null && password.isNotEmpty){
                    final isOk = await G.wallet.authentication(password);
                    if(isOk){
                      Get.toNamed(kMnemonicPage);
                    }else{
                      Toast.show('密码错误');
                    }
                  }
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
