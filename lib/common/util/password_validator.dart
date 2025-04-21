///密码验证器
class PasswordValidator {
  PasswordValidator._();

  ///密码要求正则：不少于8个字符，必须包含大小写字母、数字
  static final _regExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
    caseSensitive: true,
  );

  ///密码强度是否符合要求
  static bool isValid(String password) {
    // return _regExp.hasMatch(password);
    return test(password).length == PasswordConditionEnum.values.length;
  }

  static List<PasswordConditionEnum> test(String password) {
    return PasswordConditionEnum.values
        .where((element) => element.test(password))
        .toList(growable: false);
  }
}

enum PasswordConditionEnum {

  ///大写字母
  upperCase(r'[A-Z]'),

  ///小写字母
  lowerCase(r'[a-z]'),

  ///数字
  number(r'\d'),

  ///长度要求至少8位
  length(r'^.{8,}$');

  final String _source;

  const PasswordConditionEnum(this._source);

  ///判断文本是否满足条件
  bool test(String text) {
    return RegExp(_source).hasMatch(text);
  }

  String get label{
    switch(this){
      case PasswordConditionEnum.upperCase:
        return '大写字母';
      case PasswordConditionEnum.lowerCase:
        return '小写字母';
      case PasswordConditionEnum.number:
        return '数字';
      case PasswordConditionEnum.length:
        return '至少8位';
    }
  }
}
