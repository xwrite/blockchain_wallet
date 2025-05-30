
import 'package:blockchain_wallet/main_app.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wallet_core_bindings_native/wallet_core_bindings_native.dart';

import 'config/dependencies.dart';

void main() async{
  Logger.root.level = Level.ALL;
  WidgetsFlutterBinding.ensureInitialized();
  await WalletCoreBindingsNativeImpl().initialize();

  runApp(MultiProvider(providers: providers, child: MainApp()));

}