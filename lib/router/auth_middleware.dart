import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

class AuthMiddleware extends GetMiddleware {

  @override
  int? get priority => -999;

  @override
  RouteSettings? redirect(String? route) {
    if (route == null || route.isEmpty || [
      kPasswordPage,
      kAuthenticationPage,
    ].contains(route)){
      return null;
    }
    final walletService = Get.find<WalletService>();
    if(walletService.isOpen){
      return null;
    }
    if(walletService.hasWallet){
      //有钱包，没打开就要输密码
      return const RouteSettings(name: kAuthenticationPage);
    }else{
      //没钱包，去设置密码创建钱包
      return const RouteSettings(name: kPasswordPage);
    }
  }

}
