import 'dart:convert';

import 'package:blockchain_wallet/common/utils/crypto/aes_gcm.dart';
import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository.dart';
import 'package:blockchain_wallet/data/services/secure_storage_service.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

class WalletRepositoryImpl extends WalletRepository {
  final SecureStorageService _secureStorageService;

  WalletRepositoryImpl({
    required SecureStorageService secureStorageService,
  }) : _secureStorageService = secureStorageService;

  @override
  Future<Result<void>> createWallet({
    required String name,
    required String password,
  }) async{
    final wallet = TWHDWallet();
    final encryptedData = AesGcm.encrypt(
      passphrase: utf8.encode(password),
      plaintext: utf8.encode(wallet.mnemonic),
    );
    final address = wallet.getAddressForCoin(TWCoinType.Ethereum);
    wallet.delete();
    //保存助记词
    await _secureStorageService.saveEncryptedMnemonic(encryptedData);

    //保存钱包账户信息
    final account = AccountEntity(
      address: address,
      coin: TWCoinType.Ethereum.coin,
      index: 0,
      selected: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _accountRepository.saveAccount(account);
    _account = account;
  }

  @override
  // TODO: implement isCreated
  Future<bool> get isCreated => throw UnimplementedError();

  @override
  Future<Result<void>> resetWallet() {
    // TODO: implement resetWallet
    throw UnimplementedError();
  }
}
