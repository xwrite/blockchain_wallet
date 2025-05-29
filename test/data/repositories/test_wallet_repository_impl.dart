import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/fake/services/fake_secure_storage_service.dart';
import '../../../testing/fake/services/fake_wallet_service.dart';

void main() {
  group('WalletRepositoryImpl tests', () {
    final walletRepo = WalletRepositoryImpl(
      secureStorageService: FakeSecureStorageService(),
      walletServiceFactory: Factory(FakeWalletService.new),
    );

    test('wallet should be created', () async {
      final result = await walletRepo.createWallet(
        name: 'wallet',
        password: '123456',
      );
      expect(result, isA<Ok>());

      final isCreated = await walletRepo.isCreated;
      expect(isCreated, true);
    });

    test('wallet should be removed', () async {
      final result = await walletRepo.resetWallet();
      expect(result, isA<Ok>());

      final isCreated = await walletRepo.isCreated;
      expect(isCreated, false);
    });

  });
}
