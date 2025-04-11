
import 'package:blockchain_wallet/data/app_key_store.dart';

import 'common/util/encrypt_util.dart';
import 'common/util/secure_storage.dart';

class AppGuard {

  LockType? _unlockedType;

  final _configuredLocks = <LockType>[];

  static const _kPassword = '_kPassword';

  final _storage = SecureStorage();

  ///应用是否已解锁
  bool get isUnlocked => _unlockedType != null;

  ///应用目前已设置的锁类型
  List<LockType> get configuredLocks => List.of(_configuredLocks);

  ///锁定应用
  void lock(){
    _unlockedType = null;
  }

  ///通过密码解锁应用
  ///- return 解锁成功返回密码，否则返回null
  Future<String?> unlockByPassword(String password) async{
    if(await verifyPassword(password)){
      _unlockedType = LockType.password;
      return password;
    }else{
      return null;
    }
  }

  ///通过指纹解锁应用
  ///- return 解锁成功返回密码，否则返回null
  Future<String?> unlockByBiometric() async{


    final value = await _storage.read(_kPassword);
    if(value != null && EncryptUtil.checkPassword(password, value)){
      _unlockedType = LockType.password;
      return password;
    }else{
      return null;
    }
  }

  ///是否已设置钱包密码
  Future<bool> hasPassword() async{
    return  await _storage.read(_kPassword) != null;
  }

  ///保存钱包密码
  Future<void> savePassword(String password) async{
    final value = EncryptUtil.hashPassword(password);
    await _storage.write(_kPassword, value);
  }

  ///验证密码
  Future<bool> verifyPassword(String password) async{
    final value = await _storage.read(_kPassword);
    return value != null && EncryptUtil.checkPassword(password, value);
  }

}


///应用锁类型
enum LockType{

  ///密码锁
  password,

  ///生物识别（指纹）
  biometric,

}