import 'dart:async';

import 'package:blockchain_wallet/common/utils/command.dart';
import 'package:blockchain_wallet/common/utils/password_validator.dart';
import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class CreateWalletViewModel extends ChangeNotifier {
  final _log = Logger('CreateWalletViewModel');
  final WalletRepository _walletRepository;
  late Command1<void, (String name, String password)> create;

  var _passwordConditions = <PasswordConditionEnum>[];

  List<PasswordConditionEnum> get passwordConditions =>
      List.of(_passwordConditions);

  var _isFormValid = false;
  var _name = '钱包';
  var _password = '';
  var _passwordAgain = '';

  ///表单验证是否通过
  bool get isFormValid => _isFormValid;

  String get name => _name;

  set name(String value) {
    _name = value;
    _validateForm();
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    _passwordConditions = PasswordValidator.test(value);
    _validateForm();
    notifyListeners();
  }

  set passwordAgain(String value) {
    _passwordAgain = value;
    _validateForm();
    notifyListeners();
  }

  void _validateForm() {
    _isFormValid = accountNameValidator(_name) == null &&
        passwordValidator(_password) == null &&
        passwordAgainValidator(_password, _passwordAgain) == null;
  }

  CreateWalletViewModel({required WalletRepository walletRepository})
      : _walletRepository = walletRepository {
    create = Command1(_create);
  }

  FutureOr<Result<void>> _create((String, String) args) async {
    final (name, password) = args;
    final result = await _walletRepository.createWallet(name: name, password: password);
    if(result is Error<void>){
      _log.warning('Create failed!, ${result.error}');
    }
    return result;
  }

  String? accountNameValidator(String? value) {
    final length = value?.length ?? 0;
    if (length < 2 || length > 14) {
      return '需包含2-14个字符';
    }
    return null;
  }

  String? passwordValidator(final String? value) {
    final result = PasswordValidator.isValid(value ?? '');
    return result ? null : '密码无效';
  }

  String? passwordAgainValidator(
      final String? password, final String? passwordAgain) {
    if (password != passwordAgain) {
      return '两次密码输入不一致';
    }
    return null;
  }
}
