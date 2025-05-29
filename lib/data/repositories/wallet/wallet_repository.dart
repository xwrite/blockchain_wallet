
import 'dart:async';

import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:flutter/foundation.dart';

abstract class WalletRepository extends ChangeNotifier {

  ///是否已创建钱包
  FutureOr<bool> get isCreated;

  ///创建钱包
  ///- name 钱包名称
  ///- password 密码
  Future<Result<void>> createWallet({
    required String name,
    required String password,
  });

  ///重置钱包
  Future<Result<void>> resetWallet();

}