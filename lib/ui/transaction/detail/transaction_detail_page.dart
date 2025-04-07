import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'transaction_detail_controller.dart';
import 'transaction_detail_state.dart';

///交易详情
class TransactionDetailPage extends GetView<TransactionDetailController> {

  TransactionDetailPage({Key? key}) : super(key: key);

  final TransactionDetailState state = Get.find<TransactionDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('交易详情'),),
      body: Container(
        padding: XEdgeInsets(all: 16),
        child: Text(controller.txHash),
      ),
    );
  }
}
