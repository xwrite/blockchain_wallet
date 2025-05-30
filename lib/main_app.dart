import 'package:blockchain_wallet/routing/router.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        builder: Loading.init(),
        routerConfig: router(context.read()),
      ),
    );
  }
}
