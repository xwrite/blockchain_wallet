import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {

  @override
  int? get priority => -999;

  @override
  RouteSettings? redirect(String? route) {
    if (route == null || route.isEmpty || route.startsWith(kPublicPrefix)){
      return null;
    }
    // if(Global.wallet.isOpen){
    //   return null;
    // }
    // if(Global.wallet.hasWallet){
    //   //有钱包，没打开就要输密码
    //   return const RouteSettings(name: kAuthenticationPage);
    // }else{
      //没钱包，去欢迎页
      return const RouteSettings(name: kWalletPage);
    // }
  }

}
