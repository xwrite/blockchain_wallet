import 'package:blockchain_wallet/router/app_router.dart';
import 'package:blockchain_wallet/service/authentication_service.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core_bindings_native/wallet_core_bindings_native.dart';
import 'generated/l10n.dart';
import 'service/impl/authentication_service_impl.dart';
import 'service/impl/loading_service_impl.dart';
import 'service/impl/secure_storage_service_impl.dart';
import 'service/loading_service.dart';
import 'service/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

Future<void> init() async {
  await WalletCoreBindingsNativeImpl().initialize();

  //依赖注入
  GetIt.I.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  GetIt.I.registerSingleton<SecureStorageService>(SecureStorageServiceImpl());
  GetIt.I.registerSingleton<AuthenticationService>(
    await AuthenticationServiceImpl.create(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Blockchain Wallet',
      routerConfig: appRouter,
      builder: Loading.init(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
