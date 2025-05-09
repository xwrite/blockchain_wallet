
import 'dart:convert';
import 'dart:typed_data';

import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class SecureStorageService{
  static const _kEncryptedMnemonic= '_kEncryptedMnemonic';

  final _log = Logger('SecureStorageService');

  final _store = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );


  ///保存钱包助记词
  ///- data 加密助记词
  Future<Result<void>> saveEncryptedMnemonic(Uint8List? data) async{
    try{
      if(data != null){
        await _store.write(key: _kEncryptedMnemonic, value: base64Encode(data));
        _log.fine('Replace encrypted mnemonic');
      }else{
        await _store.delete(key: _kEncryptedMnemonic);
        _log.fine('Delete encrypted mnemonic');
      }
      return Result.ok(null);
    }on Exception catch(ex){
      _log.warning('Failed to save encrypted mnemonic', ex);
      return Result.error(ex);
    }
  }

  ///获取钱包助记词
  Future<Result<Uint8List?>> getEncryptedMnemonic() async{
    try{
      final data = await _store.read(key: _kEncryptedMnemonic);
      if(data != null){
        return Result.ok(base64Decode(data));
      }else{
        return Result.ok(null);
      }
    }on Exception catch(ex){
      _log.warning('Failed to get encrypted mnemonic', ex);
      return Result.error(ex);
    }
  }


}