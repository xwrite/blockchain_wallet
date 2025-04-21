import 'package:blockchain_wallet/data/api/impl/web3_provider_impl.dart';
import 'package:blockchain_wallet/data/dao/address_dao.dart';
import 'package:blockchain_wallet/data/dao/impl/transaction_dao_impl.dart';
import 'package:blockchain_wallet/data/repository/transaction_repository.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:wallet_core_bindings_native/wallet_core_bindings_native.dart';
import 'package:web3dart/web3dart.dart';
import 'common/app_config.dart';
import 'data/app_database.dart';
import 'data/app_preferences.dart';
import 'data/dao/impl/address_dao_impl.dart';
import 'data/dao/transaction_dao.dart';
import 'generated/l10n.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bootstrap();
}

void bootstrap() async {
  await WalletCoreBindingsNativeImpl().initialize();

  //数据库
  final database = await Get.putAsync(AppDatabase.create);
  Get.lazyPut<AddressDao>(() => database.createDao(AddressDaoImpl.new));
  Get.lazyPut<TransactionDao>(() => database.createDao(TransactionDaoImpl.new));

  final web3Provider = Web3ProviderImpl(
    client: Web3Client(AppConfig.ethNetworkUrl, Client()),
  );

  //repository
  Get.lazyPut(() => TransactionRepository(
        transactionDao: Get.find(),
        web3provider: web3Provider,
      ));

  //应用偏好设置
  await Get.putAsync(AppPreferences.create);

  //注入服务
  // await Get.putAsync(
  //   () => WalletService.create(
  //     web3Provider: web3Provider,
  //     transactionRepository: Get.find(),
  //   ),
  //   permanent: true,
  // );

  //启用应用
  runApp(const WalletApp());
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
        locale: Global.preferences.locale,
      ),
    );
  }
}
