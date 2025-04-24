import 'dart:convert';

import 'package:blockchain_wallet/common/util/crypto/aes_gcm.dart';
import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/data/app_key_store.dart';
import 'package:blockchain_wallet/data/entity/account_entity.dart';
import 'package:blockchain_wallet/data/repository/account_repository.dart';
import 'package:get/get.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

class WalletService extends GetxService {
  final AppKeyStore _keystore;
  final Web3Provider _web3Provider;
  final AccountRepository _accountRepository;

  WalletService._({
    required AppKeyStore keystore,
    required Web3Provider web3Provider,
    required AccountRepository accountRepository,
  })  : _keystore = keystore,
        _web3Provider = web3Provider,
        _accountRepository = accountRepository;

  static Future<WalletService> create({
    required AppKeyStore keystore,
    required Web3Provider web3Provider,
    required AccountRepository accountRepository,
  }) async {
    return WalletService._(
      keystore: keystore,
      web3Provider: web3Provider,
      accountRepository: accountRepository,
    );
  }

  ///创建钱包
  ///- name 账户名称
  ///- password 密码
  Future<void> createWallet({
    required String name,
    required String password,
  }) async {
    final wallet = TWHDWallet();
    final encryptedData = AesGcm.encrypt(
      passphrase: utf8.encode(password),
      plaintext: utf8.encode(wallet.mnemonic),
    );
    final address = wallet.getAddressForCoin(TWCoinType.Ethereum);
    wallet.delete();
    //保存助记词
    await _keystore.saveEncryptedMnemonic(encryptedData);

    //保存钱包账户信息
    final account = AccountEntity(
      address: address,
      coin: TWCoinType.Ethereum.coin,
      index: 0,
      selected: 1,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _accountRepository.saveAccount(account);
  }
}
