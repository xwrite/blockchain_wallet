import 'dart:convert';

import 'package:blockchain_wallet/common/util/crypto_util.dart';
import 'package:blockchain_wallet/common/util/hex.dart';
import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:get/get.dart';

class WalletService extends GetxService {
  WalletService._();

  static Future<WalletService> create({
    required Web3Provider web3Provider,
  }) async {
    return WalletService._();
  }

  ///创建钱包
  ///- name 账户名称
  ///- password 密码
  Future<bool> createWallet({
    required String name,
    required String password,
  }) async {

    //通过密码派生AES密钥
    final aesSalt = CryptoUtil.generateKey(16);
    final memoryPowerOf2 = 13;
    final iterations = 1;
    final desiredKeyLength = 32;

    final aesKey = CryptoUtil.argon2(
      key: utf8.encode(password),
      memoryPowerOf2: memoryPowerOf2,
      salt: aesSalt,
      iterations: iterations,
      desiredKeyLength: desiredKeyLength,
    );

    //加密


    return false;
  }
}
