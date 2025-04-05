import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    if(G.wallet.isOpen){
      return null;
    }
    if(G.wallet.hasWallet){
      //有钱包，没打开就要输密码
      return const RouteSettings(name: kAuthenticationPage);
    }else{
      //没钱包，去设置密码创建钱包
      return const RouteSettings(name: kPasswordPage);
    }
  }

}
