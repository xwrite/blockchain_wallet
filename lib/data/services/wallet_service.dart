import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

class WalletService {
  final TWHDWallet _wallet;

  WalletService({Uint8List? mnemonic})
      : _wallet = mnemonic != null
            ? TWHDWallet.createWithMnemonic(utf8.decode(mnemonic))
            : TWHDWallet();

  ///获取助记词
  Uint8List getMnemonic() {
    return utf8.encode(_wallet.mnemonic);
  }
  
  ///获取地址
  String getAddress(){
    return _wallet.getAddressForCoin(TWCoinType.Ethereum);
  }

  void dispose() {
    _wallet.delete();
  }
}
