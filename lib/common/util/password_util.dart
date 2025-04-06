
class PasswordUtil{

  ///密码要求正则：不少于8个字符，必须包含大小写字母、数字
  static final _regExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
    caseSensitive: true,
  );

  ///密码强度是否符合要求
  static bool isValid(String password){
    return _regExp.hasMatch(password);
  }

}