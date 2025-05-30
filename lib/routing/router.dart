import 'dart:async';

import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository.dart';
import 'package:blockchain_wallet/routing/routes.dart';
import 'package:blockchain_wallet/ui/home/home_page.dart';
import 'package:blockchain_wallet/ui/home/home_view_model.dart';
import 'package:blockchain_wallet/ui/splash/splash_page.dart';
import 'package:blockchain_wallet/ui/splash/splash_view_model.dart';
import 'package:blockchain_wallet/ui/wallet/create/create_wallet_page.dart';
import 'package:blockchain_wallet/ui/wallet/create/create_wallet_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(WalletRepository walletRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    redirect: _redirect,
    refreshListenable: walletRepository,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) {
          return SplashPage(viewModel: SplashViewModel());
        },
      ),
      GoRoute(
        path: Routes.createWallet,
        builder: (context, state) {
          return CreateWalletPage(
            viewModel: CreateWalletViewModel(walletRepository: context.read()),
          );
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return HomePage(viewModel: HomeViewModel());
        },
      ),
    ],
  );
}

FutureOr<String?> _redirect(BuildContext context, GoRouterState state) async {
  final isCreated = await context.read<WalletRepository>().isCreated;
  if (!isCreated) {
    if(state.matchedLocation == Routes.createWallet){
      return null;
    }
    return Routes.splash;
  }
  if ([Routes.splash, Routes.createWallet].contains(state.matchedLocation)) {
    return Routes.home;
  }
  return null;
}
