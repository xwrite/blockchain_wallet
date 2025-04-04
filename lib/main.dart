import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:wallet_core_bindings_native/wallet_core_bindings_native.dart';
import 'generated/l10n.dart';
import 'package:flutter_portal/flutter_portal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const WalletApp());
}

Future<void> init() async {
  await WalletCoreBindingsNativeImpl().initialize();

  //注入服务
  await Get.putAsync(WalletService.create, permanent: true);

}

class WalletApp extends StatelessWidget {
  const WalletApp({super.key});

  @override
  Widget build(BuildContext context) {

    return Portal(
      child: GetMaterialApp(
        title: 'Blockchain Wallet',
        builder: Loading.init(),
        getPages: routeConfigs,
        initialRoute: kHomePage,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
