
import 'dart:typed_data';

import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/data/services/secure_storage_service.dart';

class FakeSecureStorageService implements SecureStorageService{

  Uint8List? _data;

  @override
  Future<Result<Uint8List?>> getEncryptedMnemonic() async{
    return Result.ok(_data);
  }

  @override
  Future<Result<void>> saveEncryptedMnemonic(Uint8List? data) async{
    _data = data;
    return Result.ok(null);
  }

}