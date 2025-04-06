import 'package:get/get.dart';

class SendState {

  ///发送地址
  final addressRx = ''.obs;

  ///接收地址
  final receiveAddressRx = ''.obs;

  ///余额wei
  final balanceRx = BigInt.zero.obs;

  ///发送数量wei
  final amountRx = BigInt.zero.obs;

  final gasLimitRx = BigInt.zero.obs;

  final gasPriceRx = BigInt.zero.obs;

}
