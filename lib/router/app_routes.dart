import 'package:blockchain_wallet/ui/authentication/authentication_page.dart';
import 'package:blockchain_wallet/ui/home/home_page.dart';
import 'package:blockchain_wallet/ui/mnemonic/backup/mnemonic_backup_page.dart';
import 'package:blockchain_wallet/ui/mnemonic/mnemonic_page.dart';
import 'package:blockchain_wallet/ui/send/send_page.dart';
import 'package:blockchain_wallet/ui/wallet/create/create_wallet_page.dart';
import 'package:blockchain_wallet/ui/wallet/import/import_wallet_page.dart';
import 'package:blockchain_wallet/ui/wallet/wallet_page.dart';
import 'package:get/get.dart';

import 'auth_middleware.dart';

///不需要密码认证即可访问的页面
const kPublicPrefix = '/public';

const kWalletPage = '$kPublicPrefix/WalletPage';
const kCreateWalletPage = '$kPublicPrefix/CreateWalletPage';
const kImportWalletPage = '$kPublicPrefix/ImportWalletPage';
const kAuthenticationPage = '$kPublicPrefix/AuthenticationPage';
const kHomePage = '/HomePage';
const kMnemonicPage = '/MnemonicPage';
const kMnemonicBackupPage = '/MnemonicBackupPage';
const kSendPage = '/SendPage';

///路由配置
final routeConfigs = [

  //钱包欢迎页
  GetPage(name: kWalletPage, page: () => WalletPage()),

  //主页
  GetPage(name: kHomePage, page: () => HomePage()),

  //验证密码
  GetPage(name: kAuthenticationPage, page: () => AuthenticationPage()),

  //创建钱包
  GetPage(name: kCreateWalletPage, page: () => CreateWalletPage()),

  //导入钱包
  GetPage(name: kImportWalletPage, page: () => ImportWalletPage()),

  //助记词查看
  GetPage(
    name: kMnemonicPage,
    page: () => MnemonicPage(),
  ),

  //助记词备份
  GetPage(name: kMnemonicBackupPage, page: () => MnemonicBackupPage()),

  //转账
  GetPage(name: kSendPage, page: () => SendPage()),

].map((page) {
  return page.copy(
    middlewares: [
      ...?page.middlewares,
      AuthMiddleware(), //全局认证中间件
    ],
  );
}).toList();
