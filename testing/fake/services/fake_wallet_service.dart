import 'dart:convert';
import 'dart:typed_data';

import 'package:blockchain_wallet/data/services/wallet_service.dart';

class FakeWalletService implements WalletService {
  final Uint8List _mnemonic;
  var _dispose = false;

  FakeWalletService({Uint8List? mnemonic})
      : _mnemonic = mnemonic ?? utf8.encode('mnemonic');

  @override
  void dispose() {
    _dispose = true;
  }

  @override
  String getAddress() {
    if (_dispose) {
      throw Exception('Wallet is disposed!');
    }
    return '0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97';
  }

  @override
  Uint8List getMnemonic() {
    if (_dispose) {
      throw Exception('Wallet is disposed!');
    }
    return _mnemonic;
  }
}
