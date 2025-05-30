
import 'dart:async';

import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository.dart';

class FakeWalletRepository extends WalletRepository{

  bool _isCreated = false;

  @override
  Future<Result<void>> createWallet({required String name, required String password}) async{
    _isCreated = true;
    return Result.ok(null);
  }

  @override
  FutureOr<bool> get isCreated => _isCreated;

  @override
  Future<Result<void>> resetWallet() async{
    _isCreated = false;
    return Result.ok(null);
  }

}