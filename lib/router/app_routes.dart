import 'package:blockchain_wallet/common/extension/map_extension.dart';
import 'package:blockchain_wallet/ui/authentication/authentication_page.dart';
import 'package:blockchain_wallet/ui/home/home_page.dart';
import 'package:blockchain_wallet/ui/mnemonic/backup/mnemonic_backup_page.dart';
import 'package:blockchain_wallet/ui/mnemonic/mnemonic_controller.dart';
import 'package:blockchain_wallet/ui/mnemonic/mnemonic_page.dart';
import 'package:blockchain_wallet/ui/password/password_page.dart';
import 'package:get/get.dart';

import 'auth_middleware.dart';

const kHomePage = '/';
const kAuthenticationPage = '/AuthenticationPage';
const kPasswordPage = '/PasswordPage';
const kMnemonicPage = '/MnemonicPage';
const kMnemonicBackupPage = '/MnemonicBackupPage';

///路由配置
final routeConfigs = [
  //主页
  GetPage(name: kHomePage, page: () => HomePage()),

  //验证密码
  GetPage(name: kAuthenticationPage, page: () => AuthenticationPage()),

  //设置密码
  GetPage(name: kPasswordPage, page: () => PasswordPage()),

  //助记词查看
  GetPage(
    name: kMnemonicPage,
    page: () => MnemonicPage(),
    binding: BindingsBuilder.put(() => MnemonicController()),
  ),

  //助记词备份
  GetPage(name: kMnemonicBackupPage, page: () => MnemonicBackupPage()),
].map((page) {
  return page.copy(
    middlewares: [
      ...?page.middlewares,
      AuthMiddleware(), //全局认证中间件
    ],
  );
}).toList();
