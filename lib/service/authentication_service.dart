

///授权服务
abstract class AuthenticationService {

  ///是否已设置钱包密码
  bool get hasPassword;

  ///设置钱包密码
  Future<void> setPassword(String password);

  ///验证密码是否正确
  Future<bool> verifyPassword(String password);

}
