import 'dart:math';

import 'package:blockchain_wallet/common/mixin/get_auto_dispose_mixin.dart';
import 'package:blockchain_wallet/common/util/ether_amount_util.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/ui/authentication/widget/authentication_dialog.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/wallet.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';
import 'package:web3dart/web3dart.dart';

import 'send_state.dart';

class SendController extends GetxController with GetAutoDisposeMixin {
  final state = SendState();
  final amountEditingController = TextEditingController();
  final _web3Provider = Get.find<Web3Provider>();

  @override
  void onInit() {
    super.onInit();

    amountEditingController.addListener(() {
      final value = amountEditingController.text.trim();
      state.amountRx.value = EtherAmountUtil.toWei(value);
    });

    state.addressRx.value = G.wallet.getDefaultAddress() ?? '';
    fetchData();
  }

  void fetchData() async {

    //获取余额
    final address = state.addressRx();
    if (address.isNotEmpty) {
      final balance = await _web3Provider.getBalance(address);
      if (balance != null) {
        state.balanceRx.value = balance;
      }
    }

    //gasLimit
    state.gasLimitRx.value = BigInt.from(G.wallet.transferGasLimit);

    //gasPrice
    final gasPrice = await _web3Provider.getGasPrice();
    if(gasPrice != null){
      state.gasPriceRx.value = gasPrice;
    }
  }

  ///交易矿工费
  BigInt get feeRx => state.gasLimitRx() * state.gasPriceRx();

  ///是否已满足发送条件
  bool get isReadySendRx {
    //接收地址是否有效
    final isValidAddress = TWAnyAddress.isValid(
      state.receiveAddressRx(),
      TWCoinType.Ethereum,
    );
    if(!isValidAddress){
      return false;
    }
    if(feeRx <= BigInt.zero){
      return false;
    }
    //发送数量是否小于等于可用余额
    final amount = state.amountRx();
    return amount > BigInt.zero && amount <= _availableAmount;
  }

  ///最大可用数量
  BigInt get _availableAmount{
    final value = state.balanceRx() - feeRx;
    return value.isNegative ? BigInt.zero : value;
  }

  void onTapAll(){
    amountEditingController.text = EtherAmountUtil.toEth(_availableAmount, accuracy: 8);
  }

  ///确认发送
  void onTapSend() async {
    if(!isReadySendRx){
      Toast.show('当前无法发送交易');
      return;
    }

    //验证钱包密码
    final password = await AuthenticationDialog.show();
    if(password == null || password.isEmpty){
      return;
    }

    final txHash = await Loading.asyncWrapper((){
      return G.wallet.transfer(
        password: password,
        toAddress: state.receiveAddressRx(),
        gasPrice: state.gasPriceRx(),
        value: state.amountRx(),
      );
    });

    if(txHash != null){
      Toast.show('交易发送成功');
      Get.offNamed(kTransactionDetailPage, parameters: {
        'txHash': txHash,
      });
    }else{
      Toast.show('交易发送失败');
    }

  }

  @override
  void onClose() {
    amountEditingController.dispose();
    super.onClose();
  }
}
