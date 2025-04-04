import 'dart:convert';

import 'package:blockchain_wallet/common/util/encrypt_util.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/service/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pointycastle/export.dart';

import '../authentication_service.dart';

///授权服务
class AuthenticationServiceImpl extends AuthenticationService {
  static const _kSalt = 'AuthenticationSalt';
  static const _kPassword = 'AuthenticationPassword';
  var _hasPassword = false;

  AuthenticationServiceImpl._(this._hasPassword);

  static Future<AuthenticationServiceImpl> create() async {
    final password = await _store.read(_kPassword);
    return AuthenticationServiceImpl._(password?.isNotEmpty == true);
  }

  static SecureStorageService get _store => GetIt.I<SecureStorageService>();

  ///是否已设置钱包密码
  @override
  bool get hasPassword => _hasPassword;

  ///设置钱包密码
  @override
  Future<void> setPassword(String password) async{

    //使用Argon2算法派生密钥
    final results = await compute((password) {
      final salt = EncryptUtil.generateSalt();
      final bytes = EncryptUtil.argon2(salt: salt, password: password);
      return [
        EncryptUtil.toHexString(salt),
        EncryptUtil.toHexString(bytes),
      ];
    }, password);

    logger.d(results);

    //保存盐和密钥
    await Future.wait([
      _store.write(_kSalt, results[0]),
      _store.write(_kPassword, results[1]),
    ]);

    _hasPassword = true;
  }

  @override
  Future<bool> verifyPassword(String password) async {
    final saltHex = await _store.read(_kSalt);
    final ciphertextHex = await _store.read(_kPassword);
    if(saltHex == null || ciphertextHex == null){
      return false;
    }

    final result = await compute((args){
      final salt = EncryptUtil.fromHexString(args[0]);
      final data =  EncryptUtil.argon2(salt: salt, password: args[1]);
      return EncryptUtil.toHexString(data);
    }, [saltHex, password]);

    return ciphertextHex == result;
  }

}
