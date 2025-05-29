import 'dart:async';
import 'dart:convert';
import 'package:blockchain_wallet/common/utils/crypto/aes_gcm.dart';
import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository.dart';
import 'package:blockchain_wallet/data/services/secure_storage_service.dart';
import 'package:blockchain_wallet/data/services/wallet_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class WalletRepositoryImpl extends WalletRepository {
  final Factory<WalletService> _walletServiceFactory;
  final SecureStorageService _secureStorageService;
  bool? _isCreated;
  final _log = Logger('WalletRepositoryImpl');

  WalletRepositoryImpl({
    required Factory<WalletService> walletServiceFactory,
    required SecureStorageService secureStorageService,
  })  : _walletServiceFactory = walletServiceFactory,
        _secureStorageService = secureStorageService;

  @override
  Future<Result<void>> createWallet({
    required String name,
    required String password,
  }) async {
    final wallet = _walletServiceFactory.constructor();
    final encryptedData = AesGcm.encrypt(
      passphrase: utf8.encode(password),
      plaintext: wallet.getMnemonic(),
    );
    final address = wallet.getAddress();
    wallet.dispose();

    //保存助记词
    final result =
        await _secureStorageService.saveEncryptedMnemonic(encryptedData);
    switch (result) {
      case Ok<void>():
        _isCreated = true;
        return Result.ok(null);
      case Error<void>(error: final error):
        _log.warning('Failed to save mnemonic to SecureStorageService', error);
        return Result.error(error);
    }

    // //保存钱包账户信息
    // final account = AccountEntity(
    //   address: address,
    //   coin: TWCoinType.Ethereum.coin,
    //   index: 0,
    //   selected: 1,
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    // );
    // await _accountRepository.saveAccount(account);
    // _account = account;
  }

  Future<void> _load() async {
    final result = await _secureStorageService.getEncryptedMnemonic();
    switch (result) {
      case Ok<Uint8List?>(value: final value):
        _isCreated = value != null;
        break;
      case Error<Uint8List?>(error: final error):
        _log.warning(
            'Failed to load mnemonic from SecureStorageService', error);
        break;
    }
  }

  @override
  FutureOr<bool> get isCreated async {
    if (_isCreated != null) {
      return _isCreated!;
    }
    await _load();
    return _isCreated ?? false;
  }

  @override
  Future<Result<void>> resetWallet() async {
    //删除助记词
    final result = await _secureStorageService.saveEncryptedMnemonic(null);
    switch (result) {
      case Ok<void>():
        _isCreated = false;
        return Result.ok(null);
      case Error<void>(error: final error):
        _log.warning(
            'Failed to delete mnemonic from SecureStorageService', error);
        return Result.error(error);
    }
  }
}
