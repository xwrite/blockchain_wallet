import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository.dart';
import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository_impl.dart';
import 'package:blockchain_wallet/data/services/secure_storage_service.dart';
import 'package:blockchain_wallet/data/services/wallet_service.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> _sharedProviders = [];

List<SingleChildWidget> get providers {
  return [
    Provider(create: (_) => SecureStorageService()),
    ChangeNotifierProvider(
      create: (context) => WalletRepositoryImpl(
        walletServiceFactory: Factory(WalletService.new),
        secureStorageService: context.read(),
      ) as WalletRepository,
    ),
    ..._sharedProviders,
  ];
}
