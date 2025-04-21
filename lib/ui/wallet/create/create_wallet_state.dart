
import 'package:blockchain_wallet/common/util/password_validator.dart';
import 'package:get/get.dart';

class CreateWalletState{
  final accountNameRx = ''.obs;
  final passwordRx = ''.obs;
  final isFormReadyRx = false.obs;
  final passwordConditionsRx = <PasswordConditionEnum>[].obs;

}
